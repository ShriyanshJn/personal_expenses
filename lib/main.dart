// One use case of textScaleProperty is that user can dynamically change fontsize from default using settings in device
//  final curScaleProperty = MediaQuery.of(context).textScaleFactor;
//  Eg:- Text('Size changes',style: TextStyle(fontSize: 20 * curScaleProperty,),),

// NB --> We don't use curly braces {} in if statement when if is inside a list

// open -a Simulator.app in terminal can be used in mac to open ios simulator
// Eg: Instead of Switch we use Switch.adaptive to get different looks on android and ios device

// Dart imports
import 'dart:io';

// Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';

//Own imports
import './widgets/chart.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';

void main() {
  // // Removing landscape mode from the app
  // WidgetsFlutterBinding.ensureInitialized();
  // // SystemChrome allows us to set some app like or sys like settings
  // SystemChrome.setPreferredOrientations(
  //   [
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ],
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // We can see title in BG like in Task Manager
      title: 'Expenses',
      theme: ThemeData(
        // PColor --> One single color; PSwatch --> Different shades of the color
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        // errorColor: Colors.red,
        fontFamily: 'QuickSand',
        // textTheme: ThemeData.light().textTheme.copyWith(
        //       headline6: TextStyle(
        //         fontFamily: 'OpenSans',
        //         fontWeight: FontWeight.bold,
        //         fontSize: 18,
        //       ),
        //     ),
        // appBarTheme: AppBarTheme(
        //   textTheme: ThemeData.light().textTheme.copyWith(
        //         // headline6 --> title
        //         // for text marked as title by flutter
        //         headline6: TextStyle(
        //           fontFamily: 'OpenSans',
        //           fontSize: 20,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        // ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// TextField I/P values are by default String
class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  // with here means not completely inheriting from the class
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 16.53,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTransactions {
    // .where() allows us to run test and return values for true ones
    // _userT is the total tx from which we are deriving only tx of the last week
    return _userTransactions.where((tx) {
      // returning last week tx as _recenttx
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    // showModalBottomSheet-->
    // 1. Needs context
    // 2. Builder gives context as well as returns the widget we require
    // bCtx --> _ ie I know that i get it but i don't care or use it
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          child: NewTransaction(_addNewTransaction),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    // Using id as it will be unique for each tx
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  bool _showChart = false;

  // APP LIFE CYCLE
  // Scenario
  // App currently open in mobile
  // We click home button
  // Lifecycle State becomes inactive and.then paused (App can be seen as through task manager button)
  // 1.Now we re-open App from task manager & the LifeCycle state of the App becomes resumed
  // 2.Or if we remove app from the task manager the LifeCycle State becomes suspended

  // Setting up listener object
  // Whenever life cycle state changes, go to a certain observer and call didChangeAppLifecycleState method for it
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  //? Listerner Function
  @override
  // function using after WidgetBindingObserver
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Here, we can react to changes in our app life cycle
    print(state);
  }

  // Removing listener object
  // clear our object so as to avoid memory leaks
  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.headline6,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(
                () {
                  _showChart = val;
                },
              );
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              // width: double.infinity,
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height - // Appbar height
                      mediaQuery.padding.top) * // Top status bar height
                  0.7,
              child: Chart(_recentTransactions),
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
        // width: double.infinity,
        height: (mediaQuery.size.height -
                appBar.preferredSize.height - // Appbar height
                mediaQuery.padding.top) * // Top status bar height
            0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  Widget _buildCupertinoNavigationBar() {
    return CupertinoNavigationBar(
      middle: Text('Expenses'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _startAddNewTransaction(context),
            child: Icon(CupertinoIcons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () => _startAddNewTransaction(context),
          icon: Icon(Icons.add),
        ),
      ],
      title: Text('Expenses'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // We stored the appbar in variable so that it becomes an AppBar obj
    // and we can access info about it such as height
    final PreferredSizeWidget appBar =
        Platform.isIOS ? _buildCupertinoNavigationBar() : _buildAppBar();

    final _isLandscape = mediaQuery.orientation == Orientation.landscape;

    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    // SafeArea for avoiding content being clipped by sys intrutions like nodge
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isLandscape)
              ..._buildLandscapeContent(
                mediaQuery,
                appBar,
                txListWidget,
              ),
            if (!_isLandscape)
              // Column holds list of widget inside which unfortunately
              //   we've another list of widget _buildPortraitContent (List inside list) so
              //     to overcome this error we use ... (spread operator) in front of list
              // ... allows us to put list inside list
              // ... pulls all the elements out of the list and merge them as single
              //    element in the parent list
              ..._buildPortraitContent(
                mediaQuery,
                appBar,
                txListWidget,
              ),
          ],
        ),
      ),
    );

    return Platform
            .isIOS // child = body  // middle = title  // trailing = actions
        // placeholder = labeltext
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS // To check platform
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
