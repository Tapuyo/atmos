import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../components/custom_button.dart';
import '../../components/custom_icons.dart';
import '../../components/social_icon.dart';
import '../../components/text_form_field.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';
import 'dart:convert';
import 'package:doctor_appointment_booking/myvars.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height: 80,
                        ),
                      ),
                      Text(
                        'sign_in'.tr(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      WidgetSignin(),

                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Divider(
                              color: Colors.grey,
                              endIndent: 20,
                            ),
                          ),

                          Expanded(
                            child: Divider(
                              color: Colors.grey,
                              indent: 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Expanded(
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                      SafeArea(
                        child: Center(
                          child: Wrap(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  'dont_have_an_account'.tr(),
                                  style: TextStyle(
                                    color: Color(0xffbcbcbc),
                                    fontSize: 12,
                                    fontFamily: 'NunitoSans',
                                  ),
                                ),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(2),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(Routes.signup);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'register_now'.tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        .copyWith(fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class WidgetSignin extends StatefulWidget {
  @override
  _WidgetSigninState createState() => _WidgetSigninState();
}

class _WidgetSigninState extends State<WidgetSignin> with SingleTickerProviderStateMixin{
  String codeqr = "";
  bool visible = false ;
  String _radioValue; //Initial definition of radio button value
  String choice;
  AnimationController controller;



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
            Navigator.of(context).popAndPushNamed(Routes.home);
            setState(() {
              AppVar.xcomp = choice;
              AppVar.xcoru = true;
              controller.reset();
              visible = false;
            });
          }else{
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
            Navigator.of(context).popAndPushNamed(Routes.home);
            setState(() {
              AppVar.xcomp = choice;
              AppVar.xcoru = false;
              controller.reset();
              visible = false;
            });
          }

        }else{

          setState(() {
            controller.reset();
            visible = false;
          });
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
        setState(() {
          controller.reset();
          visible = false;
        });
        showqr(context, "ID not valid to server");
      }
    }on Exception catch (_){

      print("done");
      setState(() {
        controller.reset();
        visible = false ;
      });
      showqr(context, "QR code can not identify");
    }
  }

  void initState() {
    if(AppVar.nowlog == true){
      setState(() {
        choice = AppVar.choicelog;
        _radioValue = AppVar.radiolog;
        _scan();
      });
    }else{
      setState(() {
        choice = "NO";
        _radioValue = "two";
      });
    }

    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    controller.addListener(() {
      setState(() {
        print(controller.status);
        if(controller.status == AnimationStatus.completed){
          setState(() {
            visible = true;
          });
          _scan();
          //userLogin("LDCX6QB0");
          controller.reset();

        }
      });
    });
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

  void radioButtonChanges(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'one':
          choice = "YES";
          setState(() {
            visible = false;
            controller.reset();
          });
          break;
        case 'two':
          choice = "NO";
          setState(() {
            visible = false;
            controller.reset();
          });
          break;
        default:
          choice = "NO";
      }
      debugPrint(choice); //Debug the choice in console
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            width: MediaQuery.of(context).size.width,
            child: Center(
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Radio(
                    value: 'two',
                    groupValue: _radioValue,
                    onChanged: radioButtonChanges,
                  ),
                  Text(
                    "Member",style: TextStyle(fontSize: 20),
                  ),
                  Radio(
                    value: 'one',
                    groupValue: _radioValue,
                    onChanged: radioButtonChanges,
                  ),
                  Text(
                    "Admin",style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            )
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Center(
            child: GestureDetector(
              onTapDown: (_) => controller.forward(),
              onTapUp: (_) {
                if (controller.status == AnimationStatus.forward) {
                  controller.reverse();

                }
              },
              child: Stack(

                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                  ),
                  Container(
                    width: 155,
                    height: 155,
                    child: CircularProgressIndicator(

                      value: controller.value,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                  iconwid(),
                ],
              ),
            )
          ),
        ),



      ],
    );
  }

  iconwid(){
    if(visible == false){
      return Icon(Icons.lock, size: 70,);
    }else{
      return Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.lock_open, size: 70),
          Visibility(
              visible: visible,
              child: Container(

                  child: Container(
                      width: 155,
                      height: 155,
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            visible = false;
                            controller.reset();
                          });
                        },
                          child: CircularProgressIndicator())
                  )
              )
          ),
        ],
      );
    }
  }
}
