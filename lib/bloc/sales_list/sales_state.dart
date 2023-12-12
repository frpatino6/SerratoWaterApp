import 'package:flutter/material.dart';
import 'package:serrato_water_app/models/sales_data.dart';

@immutable
abstract class SalesState {}

class SalesInitial extends SalesState {}

class SalesLoading extends SalesState {}

class SalesLoaded extends SalesState {
  final List<SaleData> salesData;

  SalesLoaded(this.salesData);
}

class SalesError extends SalesState {
  final String message;

  SalesError(this.message);
}

// add state updating sales status
class SalesStatusUpdated extends SalesState {
  final String message;

  SalesStatusUpdated(this.message);
}
