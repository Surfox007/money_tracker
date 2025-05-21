import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/query_provider.dart';
import '../models/query_model.dart';

class AddQueryScreen extends StatefulWidget {
  const AddQueryScreen({super.key});

  @override
  State<AddQueryScreen> createState() => _AddQueryScreenState();
}

class _AddQueryScreenState extends State<AddQueryScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _amount = 0.0;
  String _type = 'Expense';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Query')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title Input
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _title = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 16),

              // Amount Input
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                    _amount = double.tryParse(value ?? '0') ?? 0,
                validator: (value) {
                  final amount = double.tryParse(value ?? '');
                  return (amount == null || amount <= 0)
                      ? 'Enter a valid amount'
                      : null;
                },
              ),
              const SizedBox(height: 16),

              // Dropdown for Type
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                value: _type,
                items: ['Expense', 'Lent Money', 'Borrowed Money']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _type = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    final newQuery = QueryModel(
                      title: _title,
                      amount: _amount,
                      type: _type,
                      createdAt: DateTime.now(),
                    );
                    Provider.of<QueryProvider>(context, listen: false)
                        .addQuery(newQuery);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Query saved!')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
