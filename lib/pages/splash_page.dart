import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/pref_manager.dart';
import '../routes/routes.dart';
import '../utils/app_themes.dart';
import '../utils/constants.dart';
import '../utils/themebloc/theme_bloc.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => {_loadScreen()});
  }

  _loadScreen() async {
    await Prefs.load();
    context.bloc<ThemeBloc>().add(ThemeChanged(
        theme: Prefs.getBool(Prefs.DARKTHEME, def: false)
            ? AppTheme.DarkTheme
            : AppTheme.LightTheme));
    Navigator.of(context).pushReplacementNamed(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: kColorBlue,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //Container(child: Image.asset('assets/images/logo_light.png'),),
                      Container(child: Text("AtMoS", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),),),
                      Container(child: Text("Attendance and Monitoring System", style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),),),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 150,
              height: 2,
              child: LinearProgressIndicator(
                backgroundColor: kColorBlue,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            )
          ],
        ),
      ),
    );
  }
}
