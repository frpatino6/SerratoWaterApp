import 'package:equatable/equatable.dart';

abstract class UserTypeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadUserType extends UserTypeEvent {
  final String email;

  LoadUserType(this.email);

  @override
  List<Object> get props => [email];
}
