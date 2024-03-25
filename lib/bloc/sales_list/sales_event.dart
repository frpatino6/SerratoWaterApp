import 'package:flutter/material.dart';

@immutable
abstract class SalesEvent {}

class LoadSalesEvent extends SalesEvent {
  final String user;

  LoadSalesEvent(this.user);
}

class LoadAllSalesEvent extends SalesEvent {}

// add event updating sales status
class UpdateSalesStatusEvent extends SalesEvent {
  final String salesId;
  final String status;

  UpdateSalesStatusEvent(this.salesId, this.status);
}

class UpdateSalesStatusEmialInstalleEvent extends SalesEvent {
  final String salesId;
  final String status;
  final String emailInstalle;

  UpdateSalesStatusEmialInstalleEvent(
      this.salesId, this.status, this.emailInstalle);
}
