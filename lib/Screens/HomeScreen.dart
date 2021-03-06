import 'package:cash_flow_app/Components/CustomDrawerHeader.dart';
import 'package:cash_flow_app/Components/ExpenseViewTable.dart';
import 'package:cash_flow_app/Components/RevenueViewTable.dart';
import 'package:cash_flow_app/Components/UserData.dart';
import 'package:cash_flow_app/DatabaseSchema.dart';
import 'package:cash_flow_app/Screens/TransactionScreen.dart';
import 'package:cash_flow_app/Screens/WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HomeScreen extends StatefulWidget {
  static const ROUTE = '/HOME';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String amount = '';
  List expensesList = [];
  List revenuesList = [];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ModalRoute.of(context)!.settings.arguments as UserData;
    void getDataFromDB() async {
      // Get device path of the database
      var path = join((await getDatabasesPath()), 'expenses.db');
      // Initialize DB UserTable static method
      Database db = await initializeDB(path);
      // Get User Net Amount
      var userAmount = await db.query(UserTable.tableName,
          columns: [UserTable.columnAmount],
          where: '${UserTable.columnEmail} = ?',
          whereArgs: [userData.email]);
      // Get Expenses Records

      List expenses = await db.query(ExpenseTable.tableName,
          columns: [
            'rowid',
            ExpenseTable.columnTitle,
            ExpenseTable.columnAmount,
            ExpenseTable.columnTimestamp,
          ],
          where: '${UserTable.columnEmail} = ?',
          whereArgs: [userData.email],
          orderBy: '${ExpenseTable.columnTimestamp} desc');
      // Get Revenue Records
      List revenues = await db.query(RevenueTable.tableName,
          columns: [
            'rowid',
            RevenueTable.columnTitle,
            RevenueTable.columnAmount,
            RevenueTable.columnTimestamp,
          ],
          where: '${UserTable.columnEmail} = ?',
          whereArgs: [userData.email],
          orderBy: '${ExpenseTable.columnTimestamp} desc');
      setState(() {
        amount = userAmount[0]['amount'].toString();
        expensesList = expenses;
        revenuesList = revenues;
      });
    }

    if (amount.length == 0) getDataFromDB();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blueAccent,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: amount.length > 0
                  ? Text(
                      '\$$amount',
                      style: TextStyle(
                          fontSize: 25,
                          color: double.parse(amount) < 0
                              ? Colors.redAccent[700]
                              : Colors.greenAccent[400],
                          fontWeight: FontWeight.bold),
                    )
                  : CircularProgressIndicator(
                      color: Colors.greenAccent[400],
                    ),
            ),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              text: 'Expenses',
            ),
            Tab(
              text: 'Revenue',
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            CustomDrawerHeader(
              userData: userData,
            ),
            ListTile(
              title: Text('Transaction Operations'),
              leading: Icon(
                Icons.edit,
                color: Colors.blueAccent,
                size: 30,
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, TransactionScreen.ROUTE,
                    arguments: userData);
              },
              dense: true,
            ),
            ListTile(
              title: Text('Sign Out'),
              leading: Icon(
                Icons.logout,
                color: Colors.blueAccent,
                size: 30,
              ),
              onTap: () {
                Navigator.popUntil(
                    context, ModalRoute.withName(WelcomeScreen.ROUTE));
              },
              dense: true,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          ExpenseViewTable(
              expensesList: expensesList,
              email: userData.email,
              userAmount: amount,
              getDataFromDB: getDataFromDB),
          RevenueViewTable(
              revenuesList: revenuesList,
              email: userData.email,
              userAmount: amount,
              getDataFromDB: getDataFromDB),
        ],
      ),
    );
  }
}
