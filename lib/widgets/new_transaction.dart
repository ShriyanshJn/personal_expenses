import 'dart:io'; // For unlocking Platform.
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/adaptive_flat_button.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx) {
    print('Constructor NewTransaction Widget');
  }

  @override
  State<NewTransaction> createState() {
    print('createState NewTransaction Widget');
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  // NewTransaction() {
  //   print('Constructor NewTransaction State');
  // }

  @override // Not by mistake we are calling initState by our own
  // Now initState() is called instead of State<NewTransaction>
  // initState is only called once, when the object is created
  // used to fetch data you need initially in your app
  void initState() {
    // recommended to call super.initstate() first inside the fx
    // super refers to the parent State and makes sure that it is also runned with initState
    super.initState();
    print('initState()');
  }

  @override
  // used when something changed in parent state and we need to re-fetch data from DB
  void didUpdateWidge(NewTransaction oldWidget) {
    // argument here is the previous widget attached to the state
    print('didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  @override
  // for cleaning up data
  void dispose() {
    print('dispose()');
    super.dispose();
  }

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    // With widget. we can access properties/methods of widget class in state class
    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    // To close modal sheet automatically after entering data rather than manually
    // pop() property of Navigator is used to close the topmost screen
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    // Future is the return type of showDatePicker()
    // Future are classes in dart that are created to give us values in future
    // Here, Future trigger when user picks the date
    // .then() is executed when user chooses a date
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            // viewInsets gives us info about anything that's lapping in our view which in this case is the softkeyboard
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            // bottom: keyboard space + extra 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                // onChanged: (val) {
                //   titleInput = val;
                // },
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
                // onChanged: (val) => amountInput = val,
                controller: _amountController,
                // (_) --> I get an argument but i don't use it
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                      ),
                    ),
                    AdaptiveFlatButton('Choose Date', _presentDatePicker),
                  ],
                ),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: _submitData,
                // textColor: Theme.of(context).textTheme.button.color,
                textColor: Colors.white,
                child: Text(
                  'Add Transaction',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
