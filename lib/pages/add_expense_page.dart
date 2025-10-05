import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';
import '../models/category.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final categoriesBox = Hive.box<Category>('categories');
      final categoryValue =
          _selectedCategory ??
          (categoriesBox.isNotEmpty
              ? categoriesBox.getAt(0)!.name
              : 'Uncategorized');

      final expense = Expense(
        amount: double.parse(_amountController.text),
        description: _descriptionController.text,
        date: DateTime.now(),
        categoryId: categoryValue,
      );

      final expenseBox = Hive.box<Expense>('expenses');
      expenseBox.add(expense);

      Navigator.pop(context); // go back after saving
    }
  }

  Future<void> _addNewCategoryDialog() async {
    final _newCategoryController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Add New Category"),
        content: TextField(
          controller: _newCategoryController,
          decoration: const InputDecoration(
            labelText: "Category name",
            prefixIcon: Icon(Icons.category),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_newCategoryController.text.isNotEmpty) {
                final categoryBox = Hive.box<Category>('categories');
                final newCat = Category(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _newCategoryController.text,
                );
                categoryBox.add(newCat);
                setState(() {
                  _selectedCategory = newCat.name;
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesBox = Hive.box<Category>('categories');

    return Scaffold(
      backgroundColor: const Color(0xFF1975D1),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF1975D1),
        title: const Text(
          "Add Expense",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enter expense details 💸",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Amount field
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: "Amount",
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter amount" : null,
                  ),
                  const SizedBox(height: 16),

                  // Description field
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: "Description",
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "Enter description"
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Category dropdown
                  ValueListenableBuilder(
                    valueListenable: categoriesBox.listenable(),
                    builder: (context, Box<Category> box, _) {
                      final categories = box.values.toList();

                      final items = [
                        ...categories.map(
                          (cat) => DropdownMenuItem<String>(
                            value: cat.name,
                            child: Text(cat.name),
                          ),
                        ),
                        const DropdownMenuItem<String>(
                          value: "__add_new__",
                          child: Text("+ Add New Category"),
                        ),
                      ];

                      final currentValue =
                          _selectedCategory ??
                          (categories.isNotEmpty
                              ? categories.first.name
                              : null);

                      return DropdownButtonFormField<String>(
                        value: currentValue,
                        items: items,
                        onChanged: (value) {
                          if (value == "__add_new__") {
                            _addNewCategoryDialog();
                          } else {
                            setState(() {
                              _selectedCategory = value;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Category",
                          prefixIcon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveExpense,
                      icon: const Icon(Icons.save),
                      label: const Text("Save Expense"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor: const Color(0xFF1975D1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
