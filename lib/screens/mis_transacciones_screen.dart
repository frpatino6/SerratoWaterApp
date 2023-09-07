// lib/screens/mis_transacciones_screen.dart

import 'package:flutter/material.dart';

class MisTransaccionesScreen extends StatelessWidget {
  const MisTransaccionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Transacciones'),
      ),
      body: const Center(
        child: Text('Aquí van los detalles de las transacciones'),
      ),
    );
  }
}
