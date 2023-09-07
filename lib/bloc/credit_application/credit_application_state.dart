abstract class CreditApplicationState {}

class CreditApplicationInitial extends CreditApplicationState {}

class CreditApplicationLoading extends CreditApplicationState {}

class CreditApplicationSuccess extends CreditApplicationState {}

class CreditApplicationFailure extends CreditApplicationState {
  final String error;

  CreditApplicationFailure(this.error);
}
