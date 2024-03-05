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
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? userType;
  final String? address;
  final String? phone;
  final String? selectedUserType;
  final String? socialSecurityNumber;
  final String? parentUser;
  final int? status;
  final String? companyName;

  const RegisterEvent({
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
    this.userType,
    this.selectedUserType,
    this.address,
    this.phone,
    this.socialSecurityNumber,
    this.parentUser,
    this.status,
    this.companyName,
  });
}

class LoadUserListEvent extends AuthEvent {
  final String selectedUserType;

  const LoadUserListEvent(this.selectedUserType);
}

class LogoutEvent extends AuthEvent {}
