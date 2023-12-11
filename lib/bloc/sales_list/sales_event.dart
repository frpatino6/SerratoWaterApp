import 'package:flutter/material.dart';

@immutable
abstract class SalesEvent {}

class LoadSalesEvent extends SalesEvent {
  final String user;

  LoadSalesEvent(this.user);
}

// add event updating sales status
class UpdateSalesStatusEvent extends SalesEvent {
  final String salesId;
  final String status;

  UpdateSalesStatusEvent(this.salesId, this.status);
}
