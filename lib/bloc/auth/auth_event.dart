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
  final String address;
  final String phone;
  final String? selectedUserType;
  final String? socialSecurityNumber;
  final String parentUser;

  const RegisterEvent({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.userType,
    required this.selectedUserType,
    required this.address,
    required this.phone,
    this.socialSecurityNumber,
    required this.parentUser,
  });
}

class LoadUserListEvent extends AuthEvent {
  final String selectedUserType;

  const LoadUserListEvent(this.selectedUserType);
}

class LogoutEvent extends AuthEvent {}
