import 'package:equatable/equatable.dart';
import 'package:serrato_water_app/models/user_type_data.dart';

abstract class UserTypeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserTypeInitial extends UserTypeState {}

class UserTypeLoading extends UserTypeState {}

class UserTypeLoaded extends UserTypeState {
  final List<UserTypeData> userTypes;

  UserTypeLoaded(this.userTypes);

  @override
  List<Object?> get props => [userTypes];
}

class UserTypeError extends UserTypeState {
  final String message;

  UserTypeError(this.message);

  @override
  List<Object> get props => [message];
}
