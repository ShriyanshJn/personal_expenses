// In stateless widgets we can use const frequently as in stateless widget we don't set
//    state and hence have final properties.
// For immutable widget we can use const to avoid unnecessary re-build

import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label; // Text weekday
  final double spendingAmount;
  final double spendingPctOfTotal; // To color BG of bar

  // all final to constructor --> const 
  // As it is const we don't need to build the instance of 7 chart bars differently
  const ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal);

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder is used when we don't know of how much space we have
    // Like if we don't know how much space will our widget take
    // constraints in LayoutBuilder controls the rendering of widget on the screen
    //      on basis of height and width
    return LayoutBuilder(builder: (ctx, constraints) {
      // We can calculate height and width of the Column widget based on the constraints
      return Column(
        children: [
          // Wrapping Text with FittedBox --> Making text shrink if we are running out of space
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // FractionallySizedBox() allows to create a sizedBox as a fraction of something else
                // heightfactor 0 to 1 where 1 means 100% of the parent height (60 in this case)
                FractionallySizedBox(
                  heightFactor: spendingPctOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text(label),
            ),
          ),
        ],
      );
    });
  }
}
