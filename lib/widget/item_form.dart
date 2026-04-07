import 'package:flutter/material.dart';
import '../model/item.dart';

class ItemForm extends StatefulWidget {
  final Item? item;
  final Function(Item) onSubmit;
  const ItemForm({super.key, this.item, required this.onSubmit});

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();

    _nameController =
        TextEditingController(text: widget.item?.name ?? '');
    _quantityController = TextEditingController(
        text: widget.item?.quantity.toString() ?? '');
    _priceController = TextEditingController(
        text: widget.item?.price.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final newItem = Item(
      id: widget.item?.id, // keep id if editing
      name: _nameController.text.trim(),
      quantity: int.parse(_quantityController.text),
      price: double.parse(_priceController.text),
    );
    widget.onSubmit(newItem);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets, // keyboard safe
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.item == null ? 'Add Item' : 'Edit Item',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter a name'
                        : null,
              ),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.item == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}