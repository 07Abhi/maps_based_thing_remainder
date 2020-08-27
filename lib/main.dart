import 'package:newnativeproject/pages/splashpage.dart';
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
          primaryColor: Color(0xff264e86),
          accentColor: Color(0xff74dbef),
          fontFamily: 'Ubuntu'),
      initialRoute: SplashPage.id,
      routes: {
        ShowListData.id: (context) => ShowListData(),
        AddItemPage.id: (context) => AddItemPage(),
        SplashPage.id: (context) => SplashPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
