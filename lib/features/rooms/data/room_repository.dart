import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pingme/features/auth/data/models/user_model.dart';
import 'package:pingme/features/rooms/data/models/room_model.dart';
import 'package:uuid/uuid.dart';

class RoomRepository {
  final FirebaseFirestore _firestore;
  final Uuid _uuid;

  RoomRepository({FirebaseFirestore? firestore, Uuid? uuid})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _uuid = uuid ?? const Uuid();

  Stream<List<Room>> getRoomsStream(String userId) {
    return _firestore
        .collection('rooms')
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
          final rooms = snapshot.docs
              .map((doc) => Room.fromFirestore(doc))
              .toList();
          // In-app sort to avoid Firestore index errors
          rooms.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return rooms;
        });
  }

  Future<void> createRoom(String name, UserModel user) async {
    final newRoom = Room(
      id: _uuid.v4(),
      name: name,
      ownerId: user.uid,
      members: [user.uid],
      createdAt: DateTime.now(),
    );
    await _firestore
        .collection('rooms')
        .doc(newRoom.id)
        .set(newRoom.toFirestore());
  }
}
