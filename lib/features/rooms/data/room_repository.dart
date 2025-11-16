import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pingme/features/auth/data/models/user_model.dart';
import 'package:pingme/features/rooms/data/models/room_model.dart';
import 'package:rxdart/rxdart.dart';

class RoomRepository {
  final FirebaseFirestore _firestore;

  RoomRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<RoomModel>> getRoomsStream(String userId) {
    //
    // THE MAIN FIX IS HERE
    //
    return _firestore
        .collection('rooms')
        .where('memberUIDs', arrayContains: userId) // <-- CHANGED THIS QUERY
        .snapshots()
        .map((snapshot) {
          final rooms = snapshot.docs
              .map((doc) => RoomModel.fromFirestore(doc))
              .toList();
          rooms.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return rooms;
        })
        .onErrorReturnWith((error, stackTrace) {
          print(error);
          return [];
        });
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(
        6,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  Future<void> createRoom(String name, UserModel user) async {
    final memberMap = {'uid': user.uid, 'username': user.username};
    final inviteCode = _generateInviteCode();

    final newRoom = RoomModel.empty.copyWith(
      name: name,
      members: [memberMap],
      memberUIDs: [user.uid], // <-- ADDED THIS
      ownerId: user.uid,
      createdAt: DateTime.now(),
      inviteCode: inviteCode,
    );

    await _firestore.collection('rooms').add(newRoom.toFirestore());
  }

  Future<void> joinRoom(String inviteCode, UserModel user) async {
    final query = await _firestore
        .collection('rooms')
        .where('inviteCode', isEqualTo: inviteCode)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw Exception('Room not found');
    }

    final roomDoc = query.docs.first;
    final room = RoomModel.fromFirestore(roomDoc);

    final isAlreadyMember = room.memberUIDs.contains(
      user.uid,
    ); // <-- CLEANER CHECK

    if (!isAlreadyMember) {
      final newMemberMap = {'uid': user.uid, 'username': user.username};

      // Update both fields atomically
      await roomDoc.reference.update({
        'members': FieldValue.arrayUnion([newMemberMap]),
        'memberUIDs': FieldValue.arrayUnion([user.uid]),
      });
    } else {
      throw Exception('Already a member of this room');
    }
  }
}
