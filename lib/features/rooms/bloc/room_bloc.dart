import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pingme/features/rooms/data/models/room_model.dart';
import 'package:pingme/features/rooms/data/room_repository.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final RoomRepository _roomRepository;
  StreamSubscription? _roomsSubscription;

  RoomBloc({required RoomRepository roomRepository})
    : _roomRepository = roomRepository,
      super(const RoomState()) {
    on<RoomsUpdated>(_onRoomsUpdated);
    on<CreateRoom>(_onCreateRoom);

    _roomsSubscription = _roomRepository.getRoomsStream().listen((rooms) {
      add(RoomsUpdated(rooms));
    });
  }

  void _onRoomsUpdated(RoomsUpdated event, Emitter<RoomState> emit) {
    emit(state.copyWith(status: RoomStatus.success, rooms: event.rooms));
  }

  Future<void> _onCreateRoom(CreateRoom event, Emitter<RoomState> emit) async {
    try {
      await _roomRepository.createRoom(event.name);
    } catch (e) {
      emit(
        state.copyWith(status: RoomStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  @override
  Future<void> close() {
    _roomsSubscription?.cancel();
    return super.close();
  }
}
