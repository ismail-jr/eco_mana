import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';
import 'add_expense_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<Expense> expenseBox;

  @override
  void initState() {
    super.initState();
    expenseBox = Hive.box<Expense>('expenses');
  }

  void _deleteExpense(int index) {
    expenseBox.deleteAt(index);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Expense deleted")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expense Tracker")),
      body: ValueListenableBuilder(
        valueListenable: expenseBox.listenable(),
        builder: (context, Box<Expense> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("No expenses yet."));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final expense = box.getAt(index);
              if (expense == null) return const SizedBox.shrink();

              return Dismissible(
                key: ValueKey(expense.key),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => _deleteExpense(index),
                child: ListTile(
                  title: Text(expense.description),
                  subtitle: Text(
                    "${expense.amount.toStringAsFixed(2)} • ${expense.date.toLocal().toString().split(' ')[0]}",
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpensePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
