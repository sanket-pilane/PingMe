part of 'room_bloc.dart';

@immutable
abstract class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object> get props => [];
}

class RoomsUpdated extends RoomEvent {
  const RoomsUpdated(this.rooms);
  final List<Room> rooms;

  @override
  List<Object> get props => [rooms];
}

class AddRoom extends RoomEvent {
  const AddRoom(this.name);
  final String name;

  @override
  List<Object> get props => [name];
}
