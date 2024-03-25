// user_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serrato_water_app/api/users_api.dart';
import 'package:serrato_water_app/models/user_data.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UsersApi api;

  UserBloc({required this.api}) : super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
  }

  Future<void> _onLoadUsers(
    LoadUsers event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final List<UserData> users = await api.getUsersInstaller();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
