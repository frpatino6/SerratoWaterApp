import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serrato_water_app/api/credit_application_api.dart';
import 'package:serrato_water_app/bloc/credit_application/credit_application_event.dart';
import 'package:serrato_water_app/bloc/credit_application/credit_application_state.dart';

class CreditApplicationBloc
    extends Bloc<CreditApplicationEvent, CreditApplicationState> {
  final CreditApplicationApi api;

  CreditApplicationBloc({required this.api})
      : super(CreditApplicationInitial());

  @override
  Stream<CreditApplicationState> mapEventToState(
    CreditApplicationEvent event,
  ) async* {
    if (event is SaveCreditApplicationEvent) {
      yield CreditApplicationLoading();
      try {
        await api.postApplication(event.applicationData);
        yield CreditApplicationSuccess();
      } catch (error) {
        yield CreditApplicationFailure(error.toString());
      }
    }
  }
}
