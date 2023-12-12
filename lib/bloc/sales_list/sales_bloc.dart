import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serrato_water_app/api/credit_application_api.dart';
import 'package:serrato_water_app/bloc/sales_list/sales_event.dart';
import 'package:serrato_water_app/bloc/sales_list/sales_state.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  final CreditApplicationApi api;

  SalesBloc({required this.api}) : super(SalesInitial()) {
    on<LoadSalesEvent>(_onLoadSalesEvent);
    on<UpdateSalesStatusEvent>(_onUpdateSalesStatusEvent);
  }

  Future<void> _onLoadSalesEvent(
      LoadSalesEvent event, Emitter<SalesState> emit) async {
    emit(SalesLoading());

    try {
      final salesData = await api.getSalesData(event.user);
      emit(SalesLoaded(salesData));
    } catch (error) {
      emit(SalesError('Error loading sales data'));
    }
  }

  Future<void> _onUpdateSalesStatusEvent(
      UpdateSalesStatusEvent event, Emitter<SalesState> emit) async {
    emit(SalesLoading());

    try {
      final message = await api.updateSalesStatus(event.salesId, event.status);
      emit(SalesStatusUpdated(message));
    } catch (error) {
      emit(SalesError('Error updating sales status'));
    }
  }
}
