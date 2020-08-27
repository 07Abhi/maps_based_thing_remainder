import 'package:flutter/material.dart';
import 'package:newnativeproject/pages/showlistpage.dart';

class SplashPage extends StatefulWidget {
  static const id = 'splashPage';

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 2, milliseconds: 500),
      () {
        Navigator.pushReplacementNamed(context, ShowListData.id);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/splashlogo.png',
                height: 200.0,
                width: 200.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                ),
                child: Text(
                  'Relocate',
                  style: TextStyle(
                      fontFamily: 'DancingScript',
                      color: Colors.white70,
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
