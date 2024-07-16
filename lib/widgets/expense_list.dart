import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseList extends StatefulWidget {
  final List<Expense> expenses;
  final Function(String) deleteExpense;

  const ExpenseList({
    Key? key,
    required this.expenses,
    required this.deleteExpense,
  }) : super(key: key);

  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  bool _isSortedByAmount = false;

  List<Expense> get sortedExpenses {
    if (_isSortedByAmount) {
      return [...widget.expenses]..sort((a, b) => b.amount.compareTo(a.amount));
    }
    return widget.expenses;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              _isSortedByAmount = !_isSortedByAmount;
            });
          },
          child: Text(
            _isSortedByAmount ? 'Sort by Date' : 'Sort by Amount',
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: sortedExpenses.length,
            itemBuilder: (ctx, index) {
              return ListTile(
                title: Text(sortedExpenses[index].title),
                subtitle: Text('₹${sortedExpenses[index].amount.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => widget.deleteExpense(sortedExpenses[index].id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
