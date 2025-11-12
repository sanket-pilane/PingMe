part of 'room_bloc.dart';

enum RoomStatus { initial, loading, success, failure }

@immutable
class RoomState extends Equatable {
  const RoomState({
    this.status = RoomStatus.initial,
    this.rooms = const [],
    this.errorMessage,
  });

  final RoomStatus status;
  final List<Room> rooms;
  final String? errorMessage;

  RoomState copyWith({
    RoomStatus? status,
    List<Room>? rooms,
    String? errorMessage,
  }) {
    return RoomState(
      status: status ?? this.status,
      rooms: rooms ?? this.rooms,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, rooms, errorMessage];
}
