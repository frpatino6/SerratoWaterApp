import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serrato_water_app/api/credit_application_api.dart';
import 'package:serrato_water_app/bloc/sales_list/sales_event.dart';
import 'package:serrato_water_app/bloc/sales_list/sales_state.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  final CreditApplicationApi api;

  SalesBloc({required this.api}) : super(SalesInitial());

  @override
  Stream<SalesState> mapEventToState(SalesEvent event) async* {
    if (event is LoadSalesEvent) {
      yield SalesLoading();

      try {
        final salesData = await api.getSalesData(event.user);
        yield SalesLoaded(salesData);
      } catch (error) {
        yield SalesError('Error loading sales data');
      }
    }
  }
}
