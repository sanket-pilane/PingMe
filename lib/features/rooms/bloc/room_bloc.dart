import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pingme/features/auth/bloc/auth_bloc.dart';
import 'package:pingme/features/rooms/data/models/room_model.dart';
import 'package:pingme/features/rooms/data/room_repository.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final RoomRepository _roomRepository;
  final AuthBloc _authBloc;
  StreamSubscription? _roomSubscription;

  RoomBloc({required RoomRepository roomRepository, required AuthBloc authBloc})
    : _roomRepository = roomRepository,
      _authBloc = authBloc,
      super(const RoomState()) {
    // Corrected BLoC 8+ event handlers
    on<GetRooms>(_onGetRooms); // ADDED this handler
    on<RoomsUpdated>(_onRoomsUpdated);
    on<AddRoom>(_onAddRoom);
  }

  // NEW HANDLER for GetRooms
  void _onGetRooms(GetRooms event, Emitter<RoomState> emit) {
    emit(state.copyWith(status: RoomStatus.loading));
    _roomSubscription?.cancel();

    final userId = _authBloc.state.user.uid;
    if (userId.isEmpty) {
      emit(
        state.copyWith(
          status: RoomStatus.failure,
          errorMessage: 'User not found',
        ),
      );
      return;
    }

    _roomSubscription = _roomRepository
        .getRoomsStream(userId)
        .listen((rooms) => add(RoomsUpdated(rooms)));
  }

  void _onRoomsUpdated(RoomsUpdated event, Emitter<RoomState> emit) {
    emit(state.copyWith(status: RoomStatus.success, rooms: event.rooms));
  }

  Future<void> _onAddRoom(AddRoom event, Emitter<RoomState> emit) async {
    try {
      final user = _authBloc.state.user;
      await _roomRepository.createRoom(event.name, user);
    } catch (e) {
      emit(
        state.copyWith(status: RoomStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  @override
  Future<void> close() {
    _roomSubscription?.cancel();
    return super.close();
  }
}
