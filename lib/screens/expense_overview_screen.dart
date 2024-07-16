import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expenses.dart';
import '../widgets/expense_list.dart';
import '../widgets/expense_chart.dart';
import '../widgets/new_expense.dart';
import '../widgets/category_chart.dart';

class ExpenseOverviewScreen extends StatefulWidget {
  @override
  _ExpenseOverviewScreenState createState() => _ExpenseOverviewScreenState();
}

class _ExpenseOverviewScreenState extends State<ExpenseOverviewScreen> {
  void _startAddNewExpense(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewExpense(Provider.of<Expenses>(ctx, listen: false).addExpense);
      },
    );
  }

  String _searchQuery = '';
  bool _isSortedByAmount = false;

  @override
  Widget build(BuildContext context) {
    final expenseData = Provider.of<Expenses>(context);
    final filteredExpenses = expenseData.expenses.where((expense) {
      return expense.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (_isSortedByAmount) {
      filteredExpenses.sort((a, b) => b.amount.compareTo(a.amount));
    } else {
      filteredExpenses.sort((a, b) => b.date.compareTo(a.date));
    }

    final totalExpenses = filteredExpenses.fold(0.0, (sum, item) => sum + item.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _startAddNewExpense(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Search'),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Container(
            height: 200,
            child: ExpenseChart(expenses: expenseData.recentExpenses),
          ),
          Container(
            height: 200,
            child: CategoryChart(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total Expenses: ₹${totalExpenses.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _isSortedByAmount = !_isSortedByAmount;
                  });
                },
                child: Text(_isSortedByAmount ? 'Sort by Date' : 'Sort by Amount'),
              ),
            ],
          ),
          Expanded(
            child: ExpenseList(
              expenses: filteredExpenses,
              deleteExpense: expenseData.deleteExpense,
            ),
          ),
        ],
      ),
    );
  }
}
