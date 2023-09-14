import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String userType;
  final String? selectedUserType;

  const RegisterEvent({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.userType,
    required this.selectedUserType,
  });
}

class LoadUserListEvent extends AuthEvent {
  final String selectedUserType;

  LoadUserListEvent(this.selectedUserType);
}
