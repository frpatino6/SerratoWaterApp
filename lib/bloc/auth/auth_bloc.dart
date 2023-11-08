import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serrato_water_app/bloc/auth/auth_event.dart';
import 'package:serrato_water_app/bloc/auth/auth_state.dart';
import 'package:serrato_water_app/api/fireBaseApi.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAPI api;

  AuthBloc({required this.api}) : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginEvent) {
      try {
        final result = await api.signIn(event.email, event.password);
        if (result.containsKey('error')) {
          yield AuthFailure(result['error']['message']);
        } else {
          yield AuthSuccess();
        }
      } catch (error) {
        yield AuthFailure(error.toString());
      }
    } else if (event is RegisterEvent) {
      try {
        final result = await api.signUp(
            event.email, event.password, event.firstName, event.lastName);
        if (result.containsKey('error')) {
          yield AuthFailure(result['error']['message']);
        } else {
          yield AuthSuccess();
        }
      } catch (error) {
        yield AuthFailure(error.toString());
      }
    } else if (event is LoadUserListEvent) {
      try {
        final List<String> userList =
            await api.loadUserListFromDatabase(event.selectedUserType);
        yield UserListLoadedState(userList);
      } catch (error) {
        yield AuthFailure(error.toString());
      }
    }
    // En auth_bloc.dart, dentro de mapEventToState:
    if (event is LogoutEvent) {
      // Aquí llamarías al método que maneja el cierre de sesión en tu API

      yield AuthInitial(); // Regresa al estado inicial que representa un usuario no autenticado.
    }
  }
}
