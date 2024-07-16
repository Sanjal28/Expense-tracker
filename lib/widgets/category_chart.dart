import 'package:flutter/material.dart';
import '../providers/expenses.dart';
import '../models/expense.dart';
import 'package:provider/provider.dart';

class CategoryChart extends StatelessWidget {
  const CategoryChart({super.key});

  @override
  Widget build(BuildContext context) {
    final expensesData = Provider.of<Expenses>(context);
    final categoryTotals = expensesData.expenses.fold<Map<Category, double>>({}, (map, expense) {
      map.update(expense.category, (value) => value + expense.amount, ifAbsent: () => expense.amount);
      return map;
    });

    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categoryTotals.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.key.toString().split('.').last), // Display category name
                  Text('₹${entry.value.toStringAsFixed(2)}'),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
