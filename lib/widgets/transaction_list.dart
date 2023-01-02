// ListView(children: []) --> Loads/Render everything even if it's not visible
//                        --> Slow Performance and Lags
// ListView.builder() --> Only renders what's visible on the screen

// MediaQuery helps us to :--
//     --> Know about user's preferences
//     --> The portrait/landscape orientation
//     --> Also used for app usage in different devices
//     --> Overall it's related to the physical/virtual device connected

import 'package:flutter/material.dart';
import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;
  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   // height: 430,
    //   // Here, we are giving the container 60% of the overall device height irrespective of the device we are using to load the app
    //   height: MediaQuery.of(context).size.height * 0.6,
    //   // Defining height so that Column/ListView knows its limit
    //   // And we can apply SingleChildScrollView
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  // One of SizedBox's use case is to provide spacing
                  height: 20,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/fonts/images/waiting.png',
                    // Fitting image to the provided 200 height
                    // BoxFit takes height of its parent and squeeze the img in it
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        // accept key when our widget is stateful and topmost item in a list
        : ListView(
            children: transactions
                .map((tx) => TransactionItem(
                      // UniqueKey keeps on changing again & again as the state changes
                      // In ValueKey we can pass the unique identifier (Not changing like UniqueKey)
                      key: ValueKey(tx.id),
                      transaction: tx,
                      deleteTx: deleteTx,
                    ))
                .toList(),
          );

    // : ListView.builder(
    //     // Build/Render new item at index
    //     itemBuilder: (ctx, index) {
    //       return TransactionItem(
    //         transaction: transactions[index],
    //         deleteTx: deleteTx,
    //       );
    //     }, // Must've argument
    //     itemCount: transactions.length, // Number of items to be built

    // ListView = Column + SingleChildScrollView
    //  Column takes all available height whereas ListView takes infinte height

    // We don't know how much transactions a user will add
    // So, we don't know about how many cards require
    // Hence, .map((){}) is used to make it dynamic
    // );
  }
}
