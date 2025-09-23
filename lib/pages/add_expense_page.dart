// lib/pages/add_expense_page.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';
import '../models/category.dart';
import 'category_page.dart'; // make sure this exists

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  // make nullable so we can set it only when categories exist
  String? _selectedCategory;

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      // fallback: if user never selected a category, use the first category if available
      final categoriesBox = Hive.box<Category>('categories');
      final categoryValue =
          _selectedCategory ??
          (categoriesBox.isNotEmpty
              ? categoriesBox.getAt(0)!.name
              : 'uncategorized');

      final expense = Expense(
        amount: double.parse(_amountController.text),
        description: _descriptionController.text,
        date: DateTime.now(),
        categoryId: categoryValue,
      );

      final expenseBox = Hive.box<Expense>('expenses');
      expenseBox.add(expense);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesBox = Hive.box<Category>('categories');

    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: "Amount"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter amount" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter description" : null,
              ),

              // ----- CATEGORY DROPDOWN (dynamic) -----
              const SizedBox(height: 12),
              ValueListenableBuilder(
                valueListenable: categoriesBox.listenable(),
                builder: (context, Box<Category> box, _) {
                  if (box.isEmpty) {
                    // If no categories exist, prompt user to add some
                    return Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'No categories found. Add categories first.',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CategoryPage(),
                              ),
                            );
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    );
                  }

                  // build items from categories
                  final categories = box.values.toList();
                  final items = categories
                      .map(
                        (cat) => DropdownMenuItem<String>(
                          value: cat.name,
                          child: Text(cat.name),
                        ),
                      )
                      .toList();

                  // use the currently selected value, or default to the first category
                  final currentValue =
                      _selectedCategory ?? categories.first.name;

                  return DropdownButtonFormField<String>(
                    value: currentValue,
                    items: items,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    decoration: const InputDecoration(labelText: "Category"),
                  );
                },
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveExpense,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
