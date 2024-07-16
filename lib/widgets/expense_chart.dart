import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

class ExpenseChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseChart({Key? key, required this.expenses}) : super(key: key);

  List<Map<String, Object>> get groupedExpenseValues {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return List.generate(7, (index) {
      final weekDay = startOfWeek.add(Duration(days: index));
      var totalSum = 0.0;

      for (var i = 0; i < expenses.length; i++) {
        if (expenses[i].date.day == weekDay.day &&
            expenses[i].date.month == weekDay.month &&
            expenses[i].date.year == weekDay.year) {
          totalSum += expenses[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 3), // Ensures day is abbreviated to 3 characters
        'amount': totalSum,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalSpending = groupedExpenseValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });

    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedExpenseValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: Column(
                children: [
                  FittedBox(
                    child: Text(
                      '₹${(data['amount'] as double).toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 60,
                    width: 10,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1.0),
                            color: const Color.fromRGBO(220, 220, 220, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        FractionallySizedBox(
                          heightFactor: totalSpending == 0 ? 0 : (data['amount'] as double) / totalSpending,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['day'] as String,
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
