import 'package:flutter/material.dart';

class ProductsDialog extends StatefulWidget {
  final Function(List<String>, String) onSubmit;

  ProductsDialog({required this.onSubmit});

  @override
  _ProductsDialogState createState() => _ProductsDialogState();
}

class _ProductsDialogState extends State<ProductsDialog> {
  final List<String> _products = [
    "Hydronex 30C",
    "Well Water System",
    "MM7000",
    "Alkaline Stage",
    "5 Years soaps"
  ];
  final Map<String, bool> _selectedProducts = {};
  final TextEditingController _costController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Inicializa el mapa de productos seleccionados, todos falsos al inicio
    for (var product in _products) {
      _selectedProducts[product] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Products and Enter Cost'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Hace que el AlertDialog sea envolvente
          children: <Widget>[
            // Mapea la lista de productos a una lista de CheckboxListTile
            ..._products.map((product) {
              return CheckboxListTile(
                title: Text(product),
                value: _selectedProducts[product],
                onChanged: (bool? value) {
                  setState(() {
                    _selectedProducts[product] = value!;
                  });
                },
              );
            }).toList(),
            TextFormField(
              controller: _costController,
              decoration: const InputDecoration(labelText: 'Cost (\$)'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the cost';
                }
                // Puedes añadir más validaciones para el costo aquí
                return null;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Submit'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Filtra los productos seleccionados y pasa la lista y el costo al manejador onSubmit
              List<String> selectedProductsList = _selectedProducts.entries
                  .where((entry) => entry.value)
                  .map((entry) => entry.key)
                  .toList();
              widget.onSubmit(selectedProductsList, _costController.text);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _costController.dispose();
    super.dispose();
  }
}
