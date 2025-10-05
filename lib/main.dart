import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/expense.dart';
import 'models/category.dart';
import 'pages/home_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/add_expense_page.dart';
import 'pages/expenses_page.dart';
import 'pages/category_page.dart';
import 'pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(CategoryAdapter());

  await Hive.openBox<Expense>('expenses');
  await Hive.openBox<Category>('categories');

  runApp(const ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/dashboard': (context) => const DashboardPage(),
        '/expenses': (context) => const ExpensesPage(),
        '/add': (context) => const AddExpensePage(),
        '/categories': (context) => const CategoryPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
