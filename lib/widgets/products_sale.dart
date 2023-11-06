import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class ProductsDialog extends StatefulWidget {
  final Function(List<String>, String) onSubmit;

  const ProductsDialog({super.key, required this.onSubmit});

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
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    for (var product in _products) {
      _selectedProducts[product] = false;
    }

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _scrollToTextField();
      }
    });
  }

  void _scrollToTextField() {
    Future.delayed(const Duration(milliseconds: 300)).then((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: const [GestureType.onVerticalDragDown],
      child: AlertDialog(
        title: const Text('Select Products and Enter Cost'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
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
                  focusNode: _focusNode,
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
      ),
    );
  }

  @override
  void dispose() {
    _costController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
