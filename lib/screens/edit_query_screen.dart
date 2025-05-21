import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/query_provider.dart';
import '../models/query_model.dart';

class EditQueryScreen extends StatefulWidget {
  final QueryModel query;
  final int index;

  const EditQueryScreen({
    super.key,
    required this.query,
    required this.index,
  });

  @override
  State<EditQueryScreen> createState() => _EditQueryScreenState();
}

class _EditQueryScreenState extends State<EditQueryScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late double _amount;
  late String _type;
  final TextEditingController _amountController = TextEditingController();

  String _calculatorDisplay = '0';
  double _firstOperand = 0;
  String _operator = '';
  bool _isNewNumber = true;
  String _expressionHistory = '';

  @override
  void initState() {
    super.initState();
    _title = widget.query.title;
    _amount = widget.query.amount;
    _type = widget.query.type;
    _amountController.text = _amount.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showCalculator() {
    // Reset calculator state when showing it
    setState(() {
      _calculatorDisplay = _amountController.text;
      if (_calculatorDisplay == '0.00') {
        _calculatorDisplay = '0';
      }
      _firstOperand = double.tryParse(_calculatorDisplay) ?? 0;
      _operator = '';
      _isNewNumber = true;
      _expressionHistory = _calculatorDisplay;
    });

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          void updateCalculator(String buttonText) {
            setDialogState(() {
              if (buttonText == 'C') {
                _calculatorDisplay = '0';
                _firstOperand = 0;
                _operator = '';
                _isNewNumber = true;
                _expressionHistory = '';
              } else if (buttonText == '+' ||
                  buttonText == '-' ||
                  buttonText == '×' ||
                  buttonText == '÷') {
                if (!_isNewNumber && _operator.isNotEmpty) {
                  _calculateResult(setDialogState);
                }
                _firstOperand = double.tryParse(_calculatorDisplay) ?? 0;
                _operator = buttonText;
                _isNewNumber = true;
                _expressionHistory = '${_firstOperand.toStringAsFixed(2)} $_operator';
              } else if (buttonText == '=') {
                if (_operator.isNotEmpty && !_isNewNumber) {
                  _calculateResult(setDialogState);
                  _operator = '';
                }
              } else if (buttonText == '.') {
                if (_isNewNumber) {
                  _calculatorDisplay = '0.';
                  _isNewNumber = false;
                } else if (!_calculatorDisplay.contains('.')) {
                  _calculatorDisplay += '.';
                }
              } else {
                // Number input
                if (_isNewNumber) {
                  _calculatorDisplay = buttonText;
                  _isNewNumber = false;
                } else {
                  if (_calculatorDisplay == '0') {
                    _calculatorDisplay = buttonText;
                  } else {
                    _calculatorDisplay += buttonText;
                  }
                }
              }

              // Update expression history
              if (_operator.isEmpty) {
                _expressionHistory = _calculatorDisplay;
              } else {
                _expressionHistory = '${_firstOperand.toStringAsFixed(2)} $_operator ${_calculatorDisplay}';
              }
            });
          }

          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Expression display
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _expressionHistory,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _calculatorDisplay,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      Row(
                        children: [
                          _buildCalculatorButton('7', updateCalculator),
                          _buildCalculatorButton('8', updateCalculator),
                          _buildCalculatorButton('9', updateCalculator),
                          _buildCalculatorButton('÷', updateCalculator, isOperator: true),
                        ],
                      ),
                      Row(
                        children: [
                          _buildCalculatorButton('4', updateCalculator),
                          _buildCalculatorButton('5', updateCalculator),
                          _buildCalculatorButton('6', updateCalculator),
                          _buildCalculatorButton('×', updateCalculator, isOperator: true),
                        ],
                      ),
                      Row(
                        children: [
                          _buildCalculatorButton('1', updateCalculator),
                          _buildCalculatorButton('2', updateCalculator),
                          _buildCalculatorButton('3', updateCalculator),
                          _buildCalculatorButton('-', updateCalculator, isOperator: true),
                        ],
                      ),
                      Row(
                        children: [
                          _buildCalculatorButton('C', updateCalculator, isClear: true),
                          _buildCalculatorButton('0', updateCalculator),
                          _buildCalculatorButton('.', updateCalculator, isDecimal: true),
                          _buildCalculatorButton('+', updateCalculator, isOperator: true),
                        ],
                      ),
                      Row(
                        children: [
                          _buildCalculatorButton('=', updateCalculator, isEquals: true),
                          _buildCalculatorButton('Done', updateCalculator, isDone: true),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalculatorButton(
    String buttonText,
    Function(String) onPressed, {
    bool isOperator = false,
    bool isClear = false,
    bool isEquals = false,
    bool isDecimal = false,
    bool isDone = false,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () {
            if (isDone) {
              Navigator.pop(context);
              _amountController.text = _calculatorDisplay;
              _amount = double.tryParse(_calculatorDisplay) ?? 0;
            } else {
              onPressed(buttonText);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isOperator
                ? Colors.blue[700]
                : isEquals
                    ? Colors.green[700]
                    : isClear
                        ? Colors.orange[700]
                        : isDone
                            ? Colors.blue[700]
                            : Colors.grey[200],
            foregroundColor: isOperator || isEquals || isClear || isDone
                ? Colors.white
                : Colors.black87,
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: isDone ? 16 : 20,
              fontWeight: isDone ? FontWeight.w500 : FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _calculateResult(Function setDialogState) {
    double secondOperand = double.parse(_calculatorDisplay);
    double result = 0;

    switch (_operator) {
      case '+':
        result = _firstOperand + secondOperand;
        break;
      case '-':
        result = _firstOperand - secondOperand;
        break;
      case '×':
        result = _firstOperand * secondOperand;
        break;
      case '÷':
        if (secondOperand != 0) {
          result = _firstOperand / secondOperand;
        } else {
          _calculatorDisplay = 'Error';
          _expressionHistory = '';
          _firstOperand = 0;
          _operator = '';
          _isNewNumber = true;
          return;
        }
        break;
    }

    _calculatorDisplay = result.toStringAsFixed(2);
    _expressionHistory = '${_firstOperand.toStringAsFixed(2)} $_operator ${secondOperand.toStringAsFixed(2)} = $_calculatorDisplay';
    _firstOperand = result;
    _isNewNumber = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Query'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title Input
              TextFormField(
                initialValue: _title,
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
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calculate),
                    onPressed: _showCalculator,
                  ),
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

              // Update Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    final updatedQuery = QueryModel(
                      title: _title,
                      amount: _amount,
                      type: _type,
                      createdAt: widget.query.createdAt,
                    );
                    Provider.of<QueryProvider>(context, listen: false)
                        .updateQuery(widget.query, updatedQuery);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Query updated!')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}