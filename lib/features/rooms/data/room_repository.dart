import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pingme/features/rooms/data/models/room_model.dart';
import 'package:uuid/uuid.dart';

class RoomRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final Uuid _uuid;

  RoomRepository({FirebaseFirestore? firestore, FirebaseAuth? auth, Uuid? uuid})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance,
      _uuid = uuid ?? const Uuid();

  Stream<List<Room>> getRoomsStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('rooms')
        .where('members', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Room.fromFirestore(doc)).toList();
        });
  }

  Future<void> createRoom(String name) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final roomId = _uuid.v4();
    final newRoom = Room(
      id: roomId,
      name: name,
      members: [userId],
      ownerId: userId,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('rooms').doc(roomId).set(newRoom.toFirestore());
  }
}
