import 'package:flutter/material.dart';

@immutable
abstract class SalesEvent {}

class LoadSalesEvent extends SalesEvent {
  final String user;

  LoadSalesEvent(this.user);
}
