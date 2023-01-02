// Getters are properties which are calculated dynamically, used to read class fields

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  // For knowing the amount we need to know the recent week transactions
  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions);

  // GTVals --> 7 bars as of week
  // List of Maps where we use String as Key and Object as Value
  // So that we don't have to hard code for all 7 days of the week
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(
      7,
      (index) {
        final weekDay = DateTime.now().subtract(
          // Subtracting (index 0 ==> today, index 1 ==> yesterday,..)
          Duration(days: index),
        );
        var totalSum = 0.0; //  todo tSum --> tAmt spent over the day?

        for (var i = 0; i < recentTransactions.length; i++) {
          // recentTransactions ==> week ; recentTransactions[0] ==> today's transaction
          if (recentTransactions[i].date.day == weekDay.day &&
              recentTransactions[i].date.month == weekDay.month &&
              recentTransactions[i].date.year == weekDay.year) {
            totalSum += recentTransactions[i].amount;
          }
        }

        // Returning Map for each index for length =7
        // DateFormat.E() --> Gives shortcut for weekday like M for Monday,....
        return {
          // .substring(start,end) used on string
          'day': DateFormat.E().format(weekDay).substring(0, 1),
          'amount': totalSum,
        };
      },
      // .reversed for proper order of days
    ).reversed.toList();
  }

  // getter to get the total spending amt to calc % spending as of per day
  double get totalSpending {
    // .fold() can be used to convert one type to another and also summing
    // Like here GTvals (List --> double)
    return groupedTransactionValues.fold(0.0, (sum, item) {
      // 0.0 here is initial value of sum
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      elevation: 6,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // .map() to create bars with one code set instead of seven
          children: groupedTransactionValues.map((data) {
            // Expanded widget is simply FlexFit.tight
            return Flexible(
              // flex property determines the available space
              // fit tight here keeps the child maintained in it's own space and doesn't allow it to spread
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'],
                data['amount'],
                totalSpending == 0.0
                    ? 0.0
                    : (data['amount'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
