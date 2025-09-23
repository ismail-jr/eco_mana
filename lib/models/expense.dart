import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'expense.g.dart'; // generated file

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String categoryId; // link to category

  Expense({
    String? id,
    required this.amount,
    required this.description,
    required this.date,
    required this.categoryId,
  }) : id = id ?? const Uuid().v4();
}
