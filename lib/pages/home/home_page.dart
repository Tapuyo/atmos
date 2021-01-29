import 'package:doctor_appointment_booking/myvars.dart';
import 'package:doctor_appointment_booking/services/admob_service.dart';


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:admob_flutter/admob_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'dart:async';
import 'package:geolocation/geolocation.dart';
import 'package:app_settings/app_settings.dart';
import 'package:doctor_appointment_booking/mygroup.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomePage> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAd;
  AdmobReward rewardAd;


  final bool _noAppoints = false;
  String choice = "";
  String codeqr = "";
  bool visible = false ;
  AnimationController controllerin;
  AnimationController controllerout;
  AnimationController bcontrollerin;
  AnimationController bcontrollerout;
  String datenow = "";
  String timenow = "";
  bool timestat = true;
  bool timebreak = true;
  String timein = "";
  String timeout = "";
  String _timeString;
  bool timebreakin = true;
  bool statreat = false;

  //location variables
  LocationResult locations = null;
  StreamSubscription<LocationResult> streamSubscription;
  bool trackLocation = false;

  void _getCurrentTime()  {
    setState(() {
      int dth = DateTime.now().hour;
      int newh = 0;
     if(AppVar.xcoru == false){
       if(DateTime.now().minute == 1 && DateTime.now().second == 1){
         interstitialshow();
       }
       if(DateTime.now().minute == 5 && DateTime.now().second == 1){
         interstitialshow();
       }
       if(DateTime.now().minute == 10 && DateTime.now().second == 1){
         interstitialshow();
       }
       if(DateTime.now().minute == 15 && DateTime.now().second == 1){
         interstitialshow();
       }
       if(DateTime.now().minute == 20 && DateTime.now().second == 1){
         interstitialshow();
       }
       if(DateTime.now().minute == 25 && DateTime.now().second == 1){
         interstitialshow();
       }
       if(DateTime.now().minute == 30 && DateTime.now().second == 1){
         interstitialshow();
       }
       if(DateTime.now().minute == 35 && DateTime.now().second == 1){
         interstitialshow();
       }
       if(DateTime.now().minute == 40 && DateTime.now().second == 1){
         interstitialshow();
       }
       if(DateTime.now().minute == 45 && DateTime.now().second == 1){
         interstitialshow();
       }
       if(DateTime.now().minute == 50 && DateTime.now().second == 1){
         interstitialshow();
       }
       if(DateTime.now().minute == 55 && DateTime.now().second == 1){
         interstitialshow();
       }
       if(DateTime.now().minute == 59 && DateTime.now().second == 1){
         interstitialshow();
       }
     }
      if(dth > 12){
        newh = dth - 12;
        _timeString = "${newh.toString()}:${DateTime.now().minute}:${DateTime.now().second}" + " pm";
      }else{
        newh = dth;
        _timeString = "${newh.toString()}:${DateTime.now().minute}:${DateTime.now().second}" + " am";
      }

    });
  }

  @override
  void initState() {
    Admob.initialize();
    int dth = DateTime.now().hour;
    int newh = 0;
    if(dth > 12){
      newh = dth - 12;
      _timeString = "${newh.toString()}:${DateTime.now().minute}:${DateTime.now().second}" + " pm";
    }else{
      newh = dth;
      _timeString = "${newh.toString()}:${DateTime.now().minute}:${DateTime.now().second}" + " am";
    }
    Timer.periodic(Duration(seconds:1), (Timer t)=>_getCurrentTime());
    super.initState();

    bannerSize = AdmobBannerSize.BANNER;

    interstitialAd = AdmobInterstitial(
      adUnitId: "ca-app-pub-1156390496952979/8973827185",
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );

    rewardAd = AdmobReward(
      adUnitId: "ca-app-pub-1156390496952979/1980817421",
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) rewardAd.load();
        handleEvent(event, args, 'Reward');
      },
    );

    rewardAd.load();
    interstitialAd.load();


    timein = "";
    timeout = "";
    timestat = true;
    timebreak = true;
    getdate();
    gettime();



    controllerin =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    controllerin.addListener(() {

      setState(() {


        print(controllerin.status);
        if(controllerin.status == AnimationStatus.completed){

          timeinempl("In","Regular");
        }
      });
    });
    controllerout =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    controllerout.addListener(() {

      setState(() {
        print(controllerout.status);
        if(controllerout.status == AnimationStatus.completed){


          timeinempl("Out","Regular");
        }
      });
    });
    bcontrollerin =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    bcontrollerin.addListener(() {

      setState(() {
        if(bcontrollerin.status == AnimationStatus.completed){
          bcontrollerin.reset();
          bcontrollerout.reset();
          timebreakin = false;
        }


      });
    });
    bcontrollerout =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    bcontrollerout.addListener(() {

      setState(() {
        if(bcontrollerout.status == AnimationStatus.completed){
          bcontrollerin.reset();
          bcontrollerout.reset();
          timebreakin = true;
        }

      });
    });
    checkGps();
    if(AppVar.chose != "YES"){
      checkattennow();
      usergroup();
    }


  }

  //admob inter
  interstitialshow()async {
    if (await interstitialAd.isLoaded) {
      interstitialAd.show();
    } else {
     /* showSnackBar(
          'Interstitial ad is still loading...');*/
    }
  }
  rewardshow()async {
    if (await interstitialAd.isLoaded) {
      rewardAd.show();
    } else {
      /* showSnackBar(
          'Interstitial ad is still loading...');*/
    }
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        //showSnackBar('Welcome to AtMos!');
        break;
      case AdmobAdEvent.opened:
        //showSnackBar('Welcome to AtMos!');
        break;
      case AdmobAdEvent.closed:
        //showSnackBar('Welcome to AtMos!');
        break;
      case AdmobAdEvent.failedToLoad:
        //showSnackBar('Welcome to AtMos!');
        break;
      case AdmobAdEvent.rewarded:
        /*showDialog(
          context: scaffoldState.currentContext,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
              onWillPop: () async {
                scaffoldState.currentState.hideCurrentSnackBar();
                return true;
              },
            );
          },
        );*/
        break;
      default:
    }
  }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }
  //
  showerror(BuildContext context, String mess) {
    Widget cancelButton = FlatButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.of(context).pop();
        AppSettings.openLocationSettings();
      },
    );
    AlertDialog alert = AlertDialog(
      title:  Row(
        children: [
          Text("AtMos GPS Location "),
          Icon(Icons.location_on, color: Colors.redAccent,)
        ],
      ),
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

  checkGps() async {
    final GeolocationResult result = await Geolocation.isLocationOperational();
    if (result.isSuccessful) {
      try {
        getLocations();
      } on Exception catch (_) {
        print("throwing new error");
      }
    } else {
      trackLocation = false;
      locations = null;
      showerror(context, "Please turn on your location and restart the application");
    }
  }
  getLocations() {
    if (trackLocation) {
      setState(() => trackLocation = false);
      streamSubscription.cancel();
      streamSubscription = null;
      locations = null;
    } else {
      setState(() => trackLocation = true);
//location
      streamSubscription = Geolocation
          .locationUpdates(
        accuracy: LocationAccuracy.best,
        displacementFilter: 0.0,
        inBackground: true,
      )
          .listen((result) {
        final location = result;
        setState(() {
          locations = location;
          AppVar.lati = locations.location.latitude.toString();
          AppVar.longi = locations.location.longitude.toString();
          //notcontroller.text = "Longitude: " + locations.location.longitude.toString() + ", Latitude: " + locations.location.longitude.toString();
          print("Longitude: " + locations.location.longitude.toString() + ", Latitude: " + locations.location.longitude.toString());
        });
      });
    }

  }


  @override
  void dispose() {
    setState(() => trackLocation = false);
    streamSubscription.cancel();
    streamSubscription = null;
    locations = null;
    interstitialAd.dispose();
    rewardAd.dispose();
  }

  usergroup() async{
    final response = await http.post(AppVar.myhost + "group.php",
        headers: {'Header': 'application/x-www/form-urlencoded', "Accept": "application/json"},
        body: {"cid": AppVar.ccomp, "gid": AppVar.cgrp});

    print(response.body.toString());
    if(response.statusCode == 200){
      if(response.body != "No Results Found."){
        final result = json.decode(response.body.toString());
     setState(() {
       print(result[0]['gid'].toString());


       DateFormat dateFormat = new DateFormat.Hm();
       DateTime ami = dateFormat.parse(result[0]['gamin'].toString());
       DateTime amo = dateFormat.parse(result[0]['gamout'].toString());

       AppVar.gname = result[0]['gname'].toString();
       AppVar.gstr = result[0]['gstr'].toString();
       AppVar.gamin = ami.hour.toString() + ":" + ami.minute.toString();
       AppVar.gamout = amo.hour.toString() + ":" + amo.minute.toString();
     });

      }else{

      }
    }else{

    }
  }

  checkattennow()async{
    final response = await http.post(AppVar.myhost + "attennow.php",
        headers: {'Header': 'application/x-www/form-urlencoded', "Accept": "application/json"},
        body: {"text": AppVar.cid, "mod": "Regular"});

    print(response.body.toString());
    if(response.statusCode == 200){
      if(response.body != "No Results Found."){
        final result = json.decode(response.body.toString());
        print(result[0]['ain'].toString());
        setState(() {
          String tt = result[0]['ain'].toString();
          DateTime dtme = DateFormat("hh:mm:ss").parse(tt);
          int newhours = 0;
          String newtime = "";
          if(dtme.hour > 12){
            newhours = dtme.hour - 12;
            newtime = newhours.toString() + ":" + dtme.minute.toString() + " pm";
          }else{
            newhours = dtme.hour;
            newtime = newhours.toString() + ":" + dtme.minute.toString() + " am";
          }
          print(newtime);
          timein = newtime;
          timestat = false;
        });
        statreat = true;
      }else{
        statreat = false;
      }
    }else{
      statreat = false;
    }

  }



  getdate()async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };
    String url = AppVar.myhost + "attedate.php";
    final response = await http.get(url, headers: headers);
    print(response.body.toString());
    if (response.statusCode == 200) {
      setState(() {
        datenow = response.body.toString();
      });
    }
  }
  gettime()async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };
    String url = AppVar.myhost + "attetime.php";
    final response = await http.get(url, headers: headers);
    print(response.body.toString());
    if (response.statusCode == 200) {
      setState(() {
        timenow = response.body.toString();
      });
    }
  }

  Future timeinempl(String typetime, mod) async{
    print(typetime + mod);
    if(AppVar.lati != ""){

      final response = await http.post(AppVar.myhost + "addattendance.php",
          headers: {'Header': 'application/x-www/form-urlencoded', "Accept": "application/json"},
          body: {"mqr": AppVar.cid, "comp": AppVar.ccomp, "grp": AppVar.cgrp, "mod": mod, "type": typetime, "lati": AppVar.lati, "longi": AppVar.longi});

      print(response.body.toString());

      if(response.statusCode == 200){
        try{
          final result = json.decode(response.body.toString());
          print(result[0]['title'].toString().toString());
          if(result[0]['title'].toString().toString() == "success"){
            //result success
            if(typetime == "In"){
              setState(() {
                timein = "";
                timeout = "";
                timestat = false;
                controllerin.reset();
                controllerout.reset();
                timein = result[0]['message'].toString().toString();
              });
            }
            if(typetime == "Out"){
              setState(() {
                timestat = true;
                controllerin.reset();
                controllerout.reset();
                timeout = result[0]['message'].toString().toString();
              });
            }
          }else{
            if(typetime == "In"){
              setState(() {
                timestat = true;
                controllerin.reset();
                controllerout.reset();
              });
            }
            if(typetime == "Out"){
              setState(() {
                timein = "";
                timeout = "";
                timestat = false;
                controllerin.reset();
                controllerout.reset();
              });
            }
          }
        }on Exception catch (_){
          setState(() {
            timestat = true;
            timein = "";
            timeout = "";
            controllerout.reset();
            controllerin.reset();
          });
        }

      }else{
        setState(() {
          timestat = true;
          timein = "";
          timeout = "";
          controllerout.reset();
          controllerin.reset();
        });
      }

    }else{
      showerror(context, "Please turn on your location and restart the application");
    }
    rewardshow();
  }


  qrshow() {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Center(child: Text('Scan QR',style: TextStyle(fontSize:25),),),
              content: Container(
                height: 250,
                child: Column(
                    children: <Widget>[
                      Flexible(
                        child: Container(

                          child:  QrImage(
                            foregroundColor: Colors.blue,
                            data: "1234567890",
                            version: QrVersions.auto,
                            size: 200.0,
                          ),


                        ),
                      )


                    ]
                ),
              )
          );
        }
    );

  }




  warninglocation(){
    if(AppVar.chose != "YES"){
      if(AppVar.lati == ""){
        return  Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          color: Colors.redAccent,
          child: GestureDetector(
            onTap: (){
              showerror(context, "Please turn on your location and restart the application");
            },
            child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Please turn on your location. ", style: TextStyle(color: Colors.white),),
                    Icon(Icons.location_on, color: Colors.white,)
                  ],
                )
            ),
          ),
        );
      }else{
        return Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child:  AdmobBanner(adUnitId: 'ca-app-pub-1156390496952979/1733346008', adSize: AdmobBannerSize.FULL_BANNER),
        );
      }
    }else{
      return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child:  SizedBox(
          height: 10,
        ),
      );
    }
  }

  compchoose(){
    if(AppVar.chose != "YES"){
      return Text(
        AppVar.gname,
        style: TextStyle(
          color: Colors.grey,fontSize: 14,
        ),
      );
    }else{
      return Text(
        AppVar.ccomp,
        style: TextStyle(
          color: Colors.grey,fontSize: 14,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) => Scaffold(
    key: scaffoldState,
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            warninglocation(),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Image.asset('assets/images/hand.png'),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Hello ' + AppVar.cadmin,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      compchoose(),

                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),

            Center(
              child: Column(
                children: [
                  Text(_timeString, style: TextStyle(fontSize: 50, ),),
                  Divider(),
                  Text(datenow, style: TextStyle(fontSize: 16, ),),
                  Divider(),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),

            mybodydiget(),

            AdmobBanner(adUnitId: 'ca-app-pub-1156390496952979/5403507014', adSize: AdmobBannerSize.LARGE_BANNER),
          ],
        ),
      ),
    ),
  );
   // print('Enter home page');

    //super.build(context);



  mybodydiget(){
    if(AppVar.chose == "NO") {
      return Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Center(
                      child: GestureDetector(
                        onTapDown: (_) {
                          if (timestat == true) {
                            controllerin.forward();
                          }
                        },
                        onTapUp: (_) {
                          if (controllerin.status == AnimationStatus.forward) {
                            controllerin.reverse();
                          }
                        },
                        child: Stack(

                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              width: 130,
                              height: 130,
                              child: CircularProgressIndicator(
                                value: 1.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.grey),
                              ),
                            ),
                            Container(
                              width: 135,
                              height: 135,
                              child: CircularProgressIndicator(

                                value: controllerin.value,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blue),
                              ),
                            ),
                            Icon(Icons.play_arrow, size: 60,
                              color: timestat ? Colors.blue : Colors.grey,),
                          ],
                        ),
                      )
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Center(
                      child: GestureDetector(
                        onTapDown: (_) {
                          if (timestat == false) {
                            controllerout.forward();
                          }
                        },
                        onTapUp: (_) {
                          if (controllerout.status == AnimationStatus.forward) {
                            controllerout.reverse();
                          }
                        },
                        child: Stack(

                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              width: 130,
                              height: 130,
                              child: CircularProgressIndicator(
                                value: 1.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.grey),
                              ),
                            ),
                            Container(
                              width: 135,
                              height: 135,
                              child: CircularProgressIndicator(

                                value: controllerout.value,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.red),
                              ),
                            ),
                            Icon(Icons.stop, size: 60, color: timestat ? Colors
                                .grey : Colors.red,),
                          ],
                        ),
                      )
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            //set time in and out
            Divider(),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Start "),
                  Text(timein),
                  Text("  |  "),
                  Text("End "),
                  Text(timeout),
                ],
              ),
            ),
            Divider(),
            //set break time here

            //breakvis(),

         /*   Container(
              color: Colors.white,
              height: 500,

            )*/
          ],
        ),
      );
    }else{
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyGroup(),
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.blueAccent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/hospital.png',
                            color: Colors.white,
                          ),
                          Text("Group", style: TextStyle(color: Colors.white),)
                        ],
                      )
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Card(
                  child: GestureDetector(
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.blueAccent,
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/person.png',
                            color: Colors.white,
                          ),
                          Text("Member", style: TextStyle(color: Colors.white),)
                        ],
                      )
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Card(
                  child: GestureDetector(
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.blueAccent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/calendar.png',
                            color: Colors.white,
                          ),
                          Text("Attendance", style: TextStyle(color: Colors.white),)
                        ],
                      )
                    ),
                  ),
                ),
              ],
            ),

            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Card(
                child: Container(
                  color: Colors.white12,

                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info),
                            SizedBox(
                              width: 10,
                            ),
                            Text("What I am to you ?",style: TextStyle(fontSize: 15, color: Colors.black)),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Text("AtMos Application will help your work easier by monitoring your member or employee in their attendance, late, accomplishment report and location of where they are working at a real time checking using latest technology and programming.", textAlign: TextAlign.justify,
                                style: TextStyle(fontSize: 13, color: Colors.grey))),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      );
    }
  }

  breakvis(){
    if(timestat == false){
      if(timebreakin == true){
        return Column(
          children: [
            Center(
              child: Text("Add Break"),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Center(
                        child: GestureDetector(
                          onTapDown: (_) {
                            if(timebreak == true){
                              bcontrollerin.forward();
                            }
                          },
                          onTapUp: (_) {
                            if (bcontrollerin.status == AnimationStatus.forward) {
                              bcontrollerin.reverse();

                            }
                          },
                          child: Stack(

                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                width: 70,
                                height: 70,
                                child: CircularProgressIndicator(
                                  value: 1.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                                ),
                              ),
                              Container(
                                width: 75,
                                height: 75,
                                child: CircularProgressIndicator(

                                  value: bcontrollerin.value,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                ),
                              ),
                              Icon(Icons.pause, size: 40, color: timebreak ? Colors.blue: Colors.grey,),
                            ],
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }else{
        return Column(
          children: [
            Center(
              child: Text("Add Break"),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Center(
                        child: GestureDetector(
                          onTapDown: (_) {
                            if(timebreak == true){
                              bcontrollerout.forward();
                            }
                          },
                          onTapUp: (_) {
                            if (bcontrollerout.status == AnimationStatus.forward) {
                              bcontrollerout.reverse();

                            }
                          },
                          child: Stack(

                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                width: 70,
                                height: 70,
                                child: CircularProgressIndicator(
                                  value: 1.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                                ),
                              ),
                              Container(
                                width: 75,
                                height: 75,
                                child: CircularProgressIndicator(

                                  value: bcontrollerout.value,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                ),
                              ),
                              Icon(Icons.replay, size: 40, color: timebreak ? Colors.blue: Colors.grey,),
                            ],
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }

    }else{
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

          ],
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;


}

