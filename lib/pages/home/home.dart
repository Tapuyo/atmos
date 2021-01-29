import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';
import '../drawer/drawer_page.dart';
import '../messages/messages_page.dart';
import '../profile/profile_page.dart';
import '../settings/settings_page.dart';
import 'home_page.dart';
import 'widgets/widgets.dart';
import 'dart:math' as math;
import 'package:doctor_appointment_booking/myvars.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  String choice = "";
  String codeqr = "";

  //float
  AnimationController _controller;
  static const List<IconData> icons = const [
    Icons.business,
    Icons.person
  ];
  //

  bool isDrawerOpen = false;

  int _selectedIndex = 0;

  static PageController _pageController;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _pageController = PageController(
      initialPage: _selectedIndex,
    );
  }

  Future _scan() async {
    print("QR Code Scann");
    String barcode = await scanner.scan();
    codeqr = barcode;
    print("My code is: "+ barcode);
    userLogin(barcode);


    setState(() {

    });
  }
  Future userLogin(String code) async{
    print("Logging in" + choice + " ----" + code);
    try{
      final response = await http.post(AppVar.myhost + "login.php",
          headers: {'Header': 'application/x-www/form-urlencoded', "Accept": "application/json"},
          body: {"mqr": code, "comp": choice});

      print(response.body.toString());
      if(response.statusCode == 200){
        if(response.body != "No Results Found."){

          if(choice == "YES"){
            print("na change na login company");
           setState(() {
             final result = json.decode(response.body.toString());
             AppVar.chose = "YES";
             AppVar.cid = result[0]['cid'].toString();
             AppVar.ccomp = result[0]['ccompany'].toString();
             AppVar.cadmin = result[0]['cadminname'].toString();
             AppVar.caddress = result[0]['caddress'].toString();
             AppVar.cuser = result[0]['cusername'].toString();
             AppVar.cpass = result[0]['cpassword'].toString();
             AppVar.ccontact = result[0]['ccontact'].toString();
             AppVar.cemail = result[0]['cemail'].toString();
               AppVar.xcomp = choice;
               AppVar.xcoru = true;

           });


          }else{
           setState(() {
             print("na change na login member");
             final result = json.decode(response.body.toString());
             AppVar.chose = "NO";
             AppVar.cid = result[0]['mqr'].toString();
             AppVar.ccomp = result[0]['mcompanyid'].toString();
             AppVar.cadmin = result[0]['mfname'].toString();
             AppVar.cgrp = result[0]['mgroupid'].toString();
             AppVar.cfname = result[0]['mfname'].toString();
             AppVar.cmname = result[0]['mmname'].toString();
             AppVar.clname = result[0]['mlname'].toString();
             AppVar.cpass = result[0]['mqr'].toString();
             AppVar.ccontact = result[0]['mContact'].toString();
             AppVar.cemail = result[0]['mgender'].toString();
             AppVar.caddress = result[0]['mAddress'].toString();
             AppVar.cbdate = result[0]['mbdate'].toString();
             AppVar.cage = result[0]['mage'].toString();
             AppVar.xcomp = choice;
             AppVar.xcoru = false;

           });
          }

        }else{


          print("error");
          AppVar.cid = "";
          AppVar.ccomp = "";
          AppVar.cadmin = "";
          AppVar.caddress = "";
          AppVar.cuser = "";
          AppVar.cpass = "";
          AppVar.ccontact = "";
          AppVar.cemail = "";
          showqr(context, "No result found, Please try another ID");
        }
      }else{

        print("error");
        AppVar.cid = "";
        AppVar.ccomp = "";
        AppVar.cadmin = "";
        AppVar.caddress = "";
        AppVar.cuser = "";
        AppVar.cpass = "";
        AppVar.ccontact = "";
        AppVar.cemail = "";

        showqr(context, "ID not valid to server");
      }
    }on Exception catch (_){

      showqr(context, "QR code can not identify");
    }
  }
  showqr(BuildContext context, String mess) {
    Widget cancelButton = FlatButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("AtMos"),
      content: Text(mess),
      actions: [
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _selectPage(int index) {
    if (_pageController.hasClients) _pageController.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;
    final size = MediaQuery.of(context).size;
    final _pages = [
      HomePage(),
      MessagesPage(),
      ProfilePage(),
      SettingsPage(),
    ];
    return Stack(
      children: <Widget>[
        DrawerPage(
          onTap: () {
            setState(
              () {
                xOffset = 0;
                yOffset = 0;
                scaleFactor = 1;
                isDrawerOpen = false;
              },
            );
          },
        ),
        AnimatedContainer(
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(scaleFactor)
            ..rotateY(isDrawerOpen ? -0.5 : 0),
          duration: Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0),
            child: Scaffold(
              appBar: AppBar(
                leading: isDrawerOpen
                    ? IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          setState(
                            () {
                              xOffset = 0;
                              yOffset = 0;
                              scaleFactor = 1;
                              isDrawerOpen = false;
                            },
                          );
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          setState(() {
                            xOffset = size.width - size.width / 3;
                            yOffset = size.height * 0.1;
                            scaleFactor = 0.8;
                            isDrawerOpen = true;
                          });
                        },
                      ),
                title: AppBarTitleWidget(),
                actions: <Widget>[
                  _selectedIndex == 2
                      ? IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.add,
                          ),
                        )
                      : IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.notifications_none,
                          ),
                        ),
                ],
              ),
              body: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: _pages,
              ),
             /* floatingActionButton: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x202e83f8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      print("to booking");
                      //Navigator.of(context).pushNamed(Routes.bookingStep1);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kColorBlue,
                      ),
                      child: Container(
                        child: QrImage(
                          foregroundColor: Colors.white70,
                          data: AppVar.cid,
                          version: QrVersions.auto,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,*/
              floatingActionButton: Container(

                child: Padding(
                  padding: EdgeInsets.all(15),

                  child: Container(
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: new List.generate(icons.length, (int index) {
                        Widget child = new Container(
                          height: 70.0,
                          width: 70.0,
                          alignment: FractionalOffset.topCenter,
                          child: new ScaleTransition(
                            scale: new CurvedAnimation(
                              parent: _controller,
                              curve: new Interval(
                                  0.0,
                                  1.0 - index / icons.length / 2.0,
                                  curve: Curves.easeOut
                              ),
                            ),
                            child: new FloatingActionButton(
                              heroTag: null,
                              backgroundColor: backgroundColor,
                              mini: true,
                              child: new Icon(icons[index], color: foregroundColor),
                              onPressed: () {
                                print(index);
                                if(index == 1){
                                  setState(() {
                                    AppVar.nowlog = true;
                                    AppVar.radiolog = "two";
                                    AppVar.choicelog = "NO";
                                    AppVar.chose = "";
                                    AppVar.cid = "";
                                    AppVar.ccomp = "";
                                    AppVar.cadmin = "";
                                    AppVar.caddress = "";
                                    AppVar.cuser = "";
                                    AppVar.cpass = "";
                                    AppVar.ccontact = "";
                                    AppVar.cemail = "";
                                    AppVar.cgrp = "";
                                    AppVar.cfname = "";
                                    AppVar.clname = "";
                                    AppVar.cmname = "";
                                    AppVar.cbdate = "";
                                    AppVar.cage = "";
                                  });
                                  Navigator.of(context).pushReplacementNamed(Routes.login);

                                }else{
                                  setState(() {
                                    AppVar.nowlog = true;
                                    AppVar.radiolog = "one";
                                    AppVar.choicelog = "YES";
                                    AppVar.chose = "";
                                    AppVar.cid = "";
                                    AppVar.ccomp = "";
                                    AppVar.cadmin = "";
                                    AppVar.caddress = "";
                                    AppVar.cuser = "";
                                    AppVar.cpass = "";
                                    AppVar.ccontact = "";
                                    AppVar.cemail = "";
                                    AppVar.cgrp = "";
                                    AppVar.cfname = "";
                                    AppVar.clname = "";
                                    AppVar.cmname = "";
                                    AppVar.cbdate = "";
                                    AppVar.cage = "";
                                  });
                                  Navigator.of(context).pushReplacementNamed(Routes.login);

                                }
                              },
                            ),
                          ),
                        );
                        return child;
                      }).toList()..add(
                        new FloatingActionButton(
                          heroTag: null,
                          child: new AnimatedBuilder(
                            animation: _controller,
                            builder: (BuildContext context, Widget child) {
                              return new Transform(
                                transform: new Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                                alignment: FractionalOffset.center,
                                child: new Icon(_controller.isDismissed ? Icons.code : Icons.close),
                              );
                            },
                          ),
                          onPressed: () {
                            if (_controller.isDismissed) {
                              _controller.forward();
                            } else {
                              _controller.reverse();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: BottomAppBar(
                elevation: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: NavBarItemWidget(
                        onTap: () {
                          _selectPage(0);
                        },
                        iconData: Icons.home,
                        text: 'home'.tr(),
                        color: _selectedIndex == 0 ? kColorBlue : Colors.grey,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: NavBarItemWidget(
                        onTap: () {
                          _selectPage(1);
                        },
                        iconData: Icons.person,
                        text: 'Profile',
                        color: _selectedIndex == 1 ? kColorBlue : Colors.grey,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 1,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: NavBarItemWidget(
                        onTap: () {
                          _selectPage(2);
                        },
                        iconData: Icons.calendar_today,
                        text: 'Attendance',
                        color: _selectedIndex == 2 ? kColorBlue : Colors.grey,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: NavBarItemWidget(
                        onTap: () {
                          _selectPage(3);
                        },
                        iconData: Icons.settings,
                        text: 'settings'.tr(),
                        color: _selectedIndex == 3 ? kColorBlue : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
