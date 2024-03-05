import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serrato_water_app/bloc/auth/auth_event.dart';
import 'package:serrato_water_app/bloc/auth/auth_state.dart';
import 'package:serrato_water_app/api/fireBaseApi.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAPI api;

  AuthBloc({required this.api}) : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<RegisterEvent>(_onRegisterEvent);
    on<LoadUserListEvent>(_onLoadUserListEvent);
    on<LogoutEvent>(_onLogoutEvent);
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      final result = await api.signIn(event.email, event.password);

      emit(AuthSuccess(result));
    } catch (error) {
      emit(AuthFailure(error.toString()));
    }
  }

  Future<void> _onRegisterEvent(
      RegisterEvent event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthRegisteringState());
      final result = await api.signUp(
          event.email,
          event.password,
          event.userType,
          event.firstName,
          event.lastName,
          event.address,
          event.parentUser,
          event.phone,
          event.status,
          event.companyName);
      if (result.containsKey('error')) {
        emit(AuthFailure(result['error']['message']));
      } else {
        emit(AuthSuccess(result));
      }
    } catch (error) {
      emit(AuthFailure(error.toString()));
    }
  }

  Future<void> _onLoadUserListEvent(
      LoadUserListEvent event, Emitter<AuthState> emit) async {
    try {
      emit(const UserListLoadingState());

      final List<String> userList =
          await api.loadUserListFromDatabase(event.selectedUserType);
      emit(UserListLoadedState(userList));
    } catch (error) {
      emit(AuthFailure(error.toString()));
    }
  }

  void _onLogoutEvent(LogoutEvent event, Emitter<AuthState> emit) {
    // Aquí llamarías al método que maneja el cierre de sesión en tu API
    emit(
        AuthInitial()); // Regresa al estado inicial que representa un usuario no autenticado.
  }
}
