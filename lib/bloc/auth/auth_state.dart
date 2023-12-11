import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {} // Aquí está el nuevo estado AuthLoading.

class AuthSuccess extends AuthState {
  final Map<String, dynamic>? userProfile;

  const AuthSuccess(this.userProfile);
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);

  @override
  List<Object> get props => [error];
}

class UserListLoadedState extends AuthState {
  final List<String> userList;

  const UserListLoadedState(this.userList);
}

class UserListLoadingState extends AuthState {
  const UserListLoadingState();
}

class AuthRegisteringState extends AuthState {
  const AuthRegisteringState();
}
