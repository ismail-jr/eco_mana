import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';
import '../models/category.dart';

class ChartSection extends StatelessWidget {
  const ChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseBox = Hive.box<Expense>('expenses');
    final categoryBox = Hive.box<Category>('categories');

    return ValueListenableBuilder(
      valueListenable: expenseBox.listenable(),
      builder: (context, Box<Expense> eBox, _) {
        final expenses = eBox.values.toList();

        if (expenses.isEmpty) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'No data for chart 📊',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          );
        }

        // Aggregate totals by category name (safe lookups)
        final Map<String, double> totals = {};
        for (final e in expenses) {
          final catId = e.categoryId ?? '';
          String catName = 'Uncategorized';

          if (catId.isNotEmpty) {
            final byKey = categoryBox.get(catId);
            if (byKey != null) {
              catName = byKey.name;
            } else {
              try {
                final found = categoryBox.values.firstWhere(
                  (c) => (c.id != null && c.id == catId) || (c.name == catId),
                );
                catName = found.name;
              } catch (_) {
                // keep 'Uncategorized'
              }
            }
          }

          totals[catName] = (totals[catName] ?? 0.0) + e.amount;
        }

        if (totals.isEmpty) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'No categorized data to show.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          );
        }

        // Build pie sections
        final entries = totals.entries.toList();
        final sections = <PieChartSectionData>[];
        for (var i = 0; i < entries.length; i++) {
          final entry = entries[i];
          final color = Colors.primaries[i % Colors.primaries.length];
          final textColor = color.computeLuminance() > 0.7
              ? Colors.black
              : Colors.white;

          sections.add(
            PieChartSectionData(
              value: entry.value,
              title: '${entry.key}\n\$${entry.value.toStringAsFixed(0)}',
              radius: 60,
              color: color,
              titleStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          );
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 12),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Expenses by Category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      borderData: FlBorderData(show: false),
                      pieTouchData: PieTouchData(enabled: true),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
