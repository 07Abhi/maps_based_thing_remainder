import 'pages/additempage.dart';
import 'pages/showlistpage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.indigo,
          accentColor: Colors.pink,
          fontFamily: 'Ubuntu'),
      initialRoute: ShowListData.id,
      routes: {
        ShowListData.id: (context) => ShowListData(),
        AddItemPage.id: (context) => AddItemPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
