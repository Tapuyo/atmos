import 'dart:ffi';
import 'dart:math';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:doctor_appointment_booking/pages/profile/Group.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:doctor_appointment_booking/myvars.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../components/round_icon_button.dart';
import '../../data/pref_manager.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';
import 'dart:convert';
import 'dart:async';
import 'package:table_calendar/table_calendar.dart';
import 'package:doctor_appointment_booking/selectfrom.dart';
import 'package:doctor_appointment_booking/selectTo.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  AdmobInterstitial interstitialAd;
  List<Atten> attend = [];
  CalendarController calendarController = CalendarController();
  final _emailController = TextEditingController();
  List<DateTime> markedDates = [];
  String tothour = "0";
  String totday = "0";
  String late = "0";
  String intime = "";
  String outime = "";
  String tostr = "";
  String memid = "";


  @override
  void initState() {
    super.initState();
    attend.clear();
    _emailController.text = "";
    DateTime dtme = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    AppVar.dtfrom = dtme.year.toString() + "-" + dtme.month.toString() + "-" +dtme.day.toString();
    AppVar.dtto =  dtme.year.toString() + "-" + dtme.month.toString() + "-" +dtme.day.toString();
    calendarController = CalendarController();
    //getAtten();
    setState(() {
      _counter.value += 1;
      print(_counter.value.toString());
    });
   if(AppVar.chose != "YES"){
     memid =  AppVar.cid;
     checkstandard();
     calcul();
   }else{

   }

    interstitialAd = AdmobInterstitial(
      adUnitId: "ca-app-pub-1156390496952979/8973827185",
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );
  }
  interstitialshow()async {
    if (await interstitialAd.isLoaded) {
      interstitialAd.show();
    } else {
      /* showSnackBar(
          'Interstitial ad is still loading...');*/
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
  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        showDialog(
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
        );
        break;
      default:
    }
  }

  _launchURL(String mlat,mlong) async {
   if(mlat == ""){
     showerror(context);
   }else{
     String url = "https://www.google.com/maps/search/?api=1&query=" +  mlat + "," + mlong;
     //String url = "https://www.google.com/";
     if (await canLaunch(url)) {
       await launch(url);
     } else {
       throw 'Could not launch $url';
     }
   }
  }
  showerror(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          Text("AtMos GPS Location "),
          Icon(Icons.location_on, color: Colors.redAccent,)
        ],
      ),
      content: Text("No location registered. Please tell your member to turn ON their location when using the application."),
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

  checkstandard(){
    DateTime dtmen = DateFormat("hh:mm").parse(AppVar.gamin);
    DateTime dtmeno = DateFormat("hh:mm").parse(AppVar.gamout);
    DateTime dtmens = DateFormat("hh:mm").parse(AppVar.gstr);

    tostr = dtmens.hour.toString() + ":" + dtmens.minute.toString();

    if(dtmen.hour > 12){
      int hr = dtmen.hour - 12;
      intime = hr.toString() + ":" + dtmen.minute.toString() + "pm";
    }else{
      intime = dtmen.hour.toString() + ":" + dtmen.minute.toString() + "am";
    }
    if(dtmeno.hour > 12){
      int hr = dtmeno.hour - 12;
      outime = hr.toString() + ":" + dtmeno.minute.toString() + "pm";
    }else{
      outime = dtmeno.hour.toString() + ":" + dtmeno.minute.toString() + "am";
    }
  }

  deleteatt(BuildContext context, String aids) {

    // set up the buttons
    Widget okButton = FlatButton(
      child: Text("Delete", style: TextStyle(color: Colors.redAccent),),
      onPressed:  () {
        deleteattend(aids);
        Navigator.pop(context);
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Container(
        child: Row(
          children: [
            Text("Delete Attendance "),
            Icon(Icons.restore_from_trash, color: Colors.redAccent)
          ],
        ),
      ),
      content: Text("Are you sure, you want to delete this attendance?"),
      actions: [
        cancelButton,
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  fromcal(BuildContext context) {
    Widget selectButton = FlatButton(
      child: Text("Select"),
      onPressed:  () {
        print(calendarController.toString());
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Text("Select Date"),
            Icon(Icons.calendar_today, color: Colors.blueAccent)
          ],
        ),
      ),
      content: Container(
        child: TableCalendar(

          initialSelectedDay: DateTime.now(),
          calendarStyle: CalendarStyle(
              canEventMarkersOverflow: true,
              todayColor: Colors.orange,
              selectedColor: Theme.of(context).primaryColor,
              todayStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.white)),
          initialCalendarFormat: CalendarFormat.week,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          calendarController: calendarController,
          onDaySelected: (date, events) {
            setState(() {
              print(date.toString());
            });
          },
        ),
      ),
      actions: [
        selectButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  editattend(String aids)async{
    print("asdasdas asdasdasdasd asd");
    print(aids);
    String mynotes = _emailController.text;
    final response = await http.post(AppVar.myhost + "editattendance.php",
        headers: {'Header': 'application/x-www/form-urlencoded', "Accept": "application/json"},
        body: {"aid": aids, "note": mynotes});

    print(response.body.toString());
    if(response.statusCode == 200){
      final result = json.decode(response.body.toString());
      print(result[0]['title'].toString().toString());
      if(result[0]['title'].toString().toString() == "success"){
        refreshme();
      }else{

      }
    }else{

    }

  }
  deleteattend(String aids)async{
    final response = await http.post(AppVar.myhost + "deleteattendance.php",
        headers: {'Header': 'application/x-www/form-urlencoded', "Accept": "application/json"},
        body: {"aid": aids});

    print(response.body.toString());
    if(response.statusCode == 200){
      final result = json.decode(response.body.toString());
      print(result[0]['title'].toString().toString());
      if(result[0]['title'].toString().toString() == "success"){
        refreshme();
      }else{

      }
    }else{

    }

  }



  calcul() async{
    if(AppVar.chose != "YES"){
      memid = AppVar.cid;
    }else{
      memid = AppVar.seid;
    }
    print("Calculating dates and times");
    markedDates.clear();
    final response = await http.post(AppVar.myhost + "showatten.php",
        headers: {'Header': 'application/x-www/form-urlencoded', "Accept": "application/json"},
        body: {"text": memid, "dfrom": AppVar.dtfrom, "dto": AppVar.dtto});

    var jsondata = json.decode(response.body);
    print(response.body);

    dynamic foc = 0.00;
    dynamic lateinhr = 0;
    dynamic lateinmin = 0;
    dynamic lateoutmin = 0;
    for (var u in jsondata){
      String ain,aout,adate;

      if(u['adate']== null){
        adate = "none";
      }else{
        adate = u['adate'];

      }

      print(adate.toString());
      DateTime dtme = DateFormat("yyyy-MM-dd").parse(adate);
      markedDates.add(dtme);
      int x = 0;

      for (int i = 0; i < markedDates.length; i++) {
        DateTime dtmen = DateFormat("yyyy-MM-dd").parse(markedDates[i].toString());
         if (dtmen.toString() == dtme.toString()) {
           print(dtmen.toString() + " - " + dtme.toString());
           x = x + 1;
         }
      }
      if(x > 1){
        markedDates.remove(dtme);
      }




      if(u['ain'] == null){
        ain = "00:00:00";
      }else{
        ain = u['ain'];
      }
      if(u['aout']== null){
        aout = "00:00:00";
      }else{
        aout = u['aout'];
      }

      DateFormat dateFormat = new DateFormat.Hm();
      DateTime open = dateFormat.parse(ain);
      DateTime close = dateFormat.parse(aout);
      int foca = close.difference(open).inSeconds;

      var tot = foca/3600;
      foc = tot + foc;

      DateTime dtmen = DateFormat("hh:mm").parse(AppVar.gamin);
      DateTime dtmeno = DateFormat("hh:mm").parse(AppVar.gamout);

      DateTime jptimeins = DateFormat("yyyy-MM-dd hh:mm:ss").parse("0000-00-00 " + dtmen.hour.toString() + ":" + dtmen.minute.toString() + ":00");
      DateTime jptimeous = DateFormat("yyyy-MM-dd hh:mm:ss").parse("0000-00-00 " + dtmeno.hour.toString() + ":" + dtmeno.minute.toString() + ":00");
      print("Group IN " + jptimeins.toString() + "Group Out " + jptimeous.toString());

      DateTime agstimeins = DateFormat("yyyy-MM-dd hh:mm:ss").parse("0000-00-00 " + ain);
      DateTime agstimeous = DateFormat("yyyy-MM-dd hh:mm:ss").parse("0000-00-00 " + aout);
      print("User IN " + agstimeins.toString() + "User Out " + agstimeous.toString());




      //lateinhr = agstimeins.difference(jptimeins).inHours + lateinhr;
      int newin = agstimeins.difference(jptimeins).inMinutes;
      if(newin > 0){
        lateinmin += agstimeins.difference(jptimeins).inMinutes;
      }


      int newout = jptimeous.difference(agstimeous).inMinutes;
      if(newout > 0){
        lateoutmin += jptimeous.difference(agstimeous).inMinutes;
      }
      print("lataminadvance "+agstimeous.toString());




    }
    if(lateinmin > 0 && lateoutmin > 0){
      print("aslkdjalksjdlkasjdlkjsaldkjas"+lateoutmin.toString());
      lateinhr = lateinmin + lateoutmin;
    }
    if(lateinmin > 0 && lateoutmin <= 0){
      lateinhr = lateinmin;
    }
    if(lateinmin <= 0 && lateoutmin > 0){
      lateinhr = lateoutmin;
    }

    dynamic totlate = 0;
    if(lateinhr > 60){
      int nl = lateinhr ~/ 60;
      int nr = lateinhr % 60;
      print("total late"+nr.toString());
      totlate = nl.toString() + ":" + nr.toString();
    }else{
      totlate = "00:" + lateinhr.toString();
    }



    String nf = foc.toStringAsFixed(2);
    String lt = totlate.toString();
    setState(() {
      totday = markedDates.length.toString();
      tothour = nf.toString();
      late = lt.toString();
    });

  }

  Future<List<Atten>> getAtten() async{
    if(AppVar.chose != "YES"){
      memid = AppVar.cid;
    }else{
      memid = AppVar.seid;
    }
    attend.clear();

    final response = await http.post(AppVar.myhost + "showatten.php",
        headers: {'Header': 'application/x-www/form-urlencoded', "Accept": "application/json"},
        body: {"text": memid, "dfrom": AppVar.dtfrom, "dto": AppVar.dtto});

    var jsondata = json.decode(response.body);
    print(jsondata.toString());

    dynamic foc = 0.00;
    for (var u in jsondata){
      String aid,adate,ain,aout,alatitude,alongitude,note,stat;

      if(u['adate']== null){
        adate = "none";
      }else{
        adate = u['adate'];
      }
      if(u['ain'] == null){
        ain = "male";
      }else{
        ain = u['ain'];
      }
      if(u['aout']== null){
        aout = "none";
      }else{
        aout = u['aout'];
      }
      if(u['alatitude']== null){
        alatitude = "male";
      }else{
        alatitude = u['alatitude'];
      }
      if(u['alongitude']== null){
        alongitude = "none";
      }else{
        alongitude = u['alongitude'];
      }
      if(u['anote']== null){
        note = "none";
      }else{
        note = u['anote'];
      }
      if(u['astatus']== null){
        stat = "";
      }else{
        stat = u['astatus'];
      }
      if(u['aid']== null){
        aid = "";
      }else{
        aid = u['aid'];
      }



      Atten att = Atten(aid,adate,ain,aout,alatitude,alongitude,note,stat);

      attend.add(att);


    }

    print(attend.length.toString());
    return attend;
  }
  refreshme(){

    setState(() {
      _counter.value += 1;
      calcul();
    });
  }
  @override
  Widget build(BuildContext context) => Scaffold(


    body:  Stack(
        children: [
          Container(
            height: 220,
            child: Column(
              children: <Widget>[
                Container(
                    color: Colors.green,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text("Group:"+ AppVar.gname,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
                Container(
                    color: Colors.green,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text("Start Time:" + intime + " End Time:" + outime,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
                Container(
                    color: Colors.green,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text("Total Time: " + tostr + " hour:min",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ]
                    )
                ),

                Container(
                  padding: EdgeInsets.all(10),
                  //color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      AppvarIconwid(),

                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppVar.cadmin,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              AppVar.clname,
                              style: TextStyle(
                                color: Colors.grey[350],
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              calcul();
                            },
                            child: Icon(
                              Icons.restore,color: Colors.blueAccent,
                            ),
                          ),
                          Column(
                            children: [
                              Text("Late ", style: TextStyle(color: Colors.black),),
                              Text(late, style: TextStyle(color: Colors.blueAccent, fontSize: 20),),
                            ],
                          ),
                          /* Container(
                           width: 20,
                         ),
                         Column(
                           children: [
                             Text("Time ", style: TextStyle(color: Colors.black),),
                             Text(tothour, style: TextStyle(color: Colors.blueAccent, fontSize: 20),),
                           ],
                         ),*/
                          Container(
                            width: 20,
                          ),
                          Column(
                            children: [
                              Text("Days ", style: TextStyle(color: Colors.black),),
                              Text(totday, style: TextStyle(color: Colors.blueAccent, fontSize: 20),),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),


                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    children: [
                      Text("From: "),
                      GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SelectFrom(),
                              ),
                            );
                          },
                          child: Text(AppVar.dtfrom, style: TextStyle(color: Colors.blueAccent),)),
                      Container(
                        width: 20,
                      ),
                      Text("To: "),
                      GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SelectTo(),
                              ),
                            );
                          },
                          child: Text(AppVar.dtto, style: TextStyle(color: Colors.blueAccent),)),
                      Container(
                        width: 30,
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            _counter.value += 1;
                          });
                        },
                        child: Icon(
                          Icons.arrow_forward,color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),



              ],
            ),
          ),
          myattendance(),
          SafeArea(child: Align(
              alignment: Alignment.bottomLeft,
              child: AdmobBanner(adUnitId: 'ca-app-pub-1156390496952979/1733346008', adSize: AdmobBannerSize.FULL_BANNER)),)

        ],
      )
  );



  @override
  bool get wantKeepAlive => true;

  AppvarIconwid(){
    if(AppVar.chose == "YES") {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupdSearch(),
            ),
          );
        },
        child: CircleAvatar(
          radius: 32,
          backgroundColor: Colors.blueAccent,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                  left: 0,
                  child: Icon(Icons.person, color: Colors.white, size: 40,)),
              Positioned(
                top: 10,
                  left: 10,
                  child: Icon(Icons.search, color: Colors.white, size: 60,)),
            ],
          )
        ),
      );
    }else {
      return GestureDetector(
        onTap: () {
          calcul();
          setState(() {

            _counter.value += 1;
            print(_counter.value.toString());
          });
        },
        child: CircleAvatar(
          radius: 32,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage(
            'assets/images/icon_man.png',
          ),
        ),
      );
    }
  }
  myattendance(){
    if(AppVar.chose == "YES"){
      return ValueListenableBuilder(
        builder: (BuildContext context, int value, Widget child){
          return Container(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 10),
            child: FutureBuilder(
                future: getAtten(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {

                  if (snapshot.data == null) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(0, 180, 0, 0),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text("Loading"),
                            ),
                            Container(
                              height: 10,
                            ),
                            CircularProgressIndicator()
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
                      child: ListView.builder(
                          shrinkWrap: false,
                          itemCount: snapshot.data.length,
                          //scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Container(

                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffEBF2F5),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>[
                                          Dateword(snapshot.data[index].adate),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Dateyer(snapshot.data[index].adate),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Loca(snapshot.data[index].alatitude,snapshot.data[index].alongitude),


                                        ],
                                      ),
                                    ),

                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        widtimein(snapshot.data[index].ain),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        widtimeout(snapshot.data[index].aout),
                                        //Text(snapshot.data[index].aout),

                                      ],
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    //Text(snapshot.data[index].aid),
                                    statnote(snapshot.data[index].aid,snapshot.data[index].stat,snapshot.data[index].note),
                                    SizedBox(
                                      width: 20,
                                    ),

                                    GestureDetector(
                                      onTap: (){
                                        deleteatt(context,snapshot.data[index].aid);
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Icon(
                                              Icons.restore_from_trash,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                          Text("Delete",
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,

                                          )
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            );
                          }
                      ),
                    );
                  }
                }

            ),
          );
        },
        valueListenable: _counter,

      );
    }else {
      return ValueListenableBuilder(
        builder: (BuildContext context, int value, Widget child){
          return Container(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 10),
            child: FutureBuilder(
                future: getAtten(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {

                  if (snapshot.data == null) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(0, 180, 0, 0),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text("Loading"),
                            ),
                            Container(
                              height: 10,
                            ),
                            CircularProgressIndicator()
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
                      child: ListView.builder(
                          shrinkWrap: false,
                          itemCount: snapshot.data.length,
                          //scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Container(

                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffEBF2F5),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>[
                                          Dateword(snapshot.data[index].adate),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Dateyer(snapshot.data[index].adate),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Loca(snapshot.data[index].alatitude,snapshot.data[index].alongitude),


                                        ],
                                      ),
                                    ),

                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        widtimein(snapshot.data[index].ain),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        widtimeout(snapshot.data[index].aout),
                                        //Text(snapshot.data[index].aout),

                                      ],
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    //Text(snapshot.data[index].aid),
                                    statnote(snapshot.data[index].aid,snapshot.data[index].stat,snapshot.data[index].note),
                                    SizedBox(
                                      width: 20,
                                    ),

                                    GestureDetector(
                                      onTap: (){
                                        deleteatt(context,snapshot.data[index].aid);
                                        interstitialshow();
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Icon(
                                              Icons.restore_from_trash,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                          Text("Delete",
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,

                                          )
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            );
                          }
                      ),
                    );
                  }
                }

            ),
          );
        },
        valueListenable: _counter,

      );
    }
  }



  Loca(String lati,longi){
    return  GestureDetector(
      onTap: (){
        _launchURL(lati,longi);
      },
        child: Icon(Icons.location_on, color: Colors.blueAccent));
  }

  Dateyer(String dtn){
    DateTime dtme = DateFormat("yyyy-MM-dd").parse(dtn);
    int dtmo = dtme.year;
    return  Row(
      children: [

        Text(
          dtmo.toString(),
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        )
      ],
    );
  }

  Dateword(String dtn){
    DateTime dtme = DateFormat("yyyy-MM-dd").parse(dtn);
    int dtmo = dtme.month;
    String mo = "";
    if(dtmo == 1){
      mo = "January";
    }
    if(dtmo == 2){
      mo = "February";
    }
    if(dtmo == 3){
      mo = "March";
    }
    if(dtmo == 4){
      mo = "April";
    }
    if(dtmo == 5){
      mo = "May";
    }
    if(dtmo == 6){
      mo = "June";
    }
    if(dtmo == 7){
      mo = "July";
    }
    if(dtmo == 8){
      mo = "August";
    }
    if(dtmo == 9){
      mo = "September";
    }
    if(dtmo == 10){
      mo = "October";
    }
    if(dtmo == 11){
      mo = "November";
    }
    if(dtmo == 12){
      mo = "December";
    }
    return Text(
      mo + " " + dtme.day.toString(),
      style: TextStyle(
        color: kColorPrimaryDark,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  statnote(String aid,stat,notes){
    print("ID: " + aid);
    if(stat == "Confirmed"){
      return GestureDetector(
        onTap: (){
          viewnotes(notes);
          interstitialshow();
        },
        child: Container(
          child: Column(
            children: [
              Container(
                child: Icon(
                    Icons.check, color: Colors.green,
                ),
              ),
              Text("Check",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,

              )
            ],
          ),
        ),
      );
    }else {
      return GestureDetector(
        onTap: (){
          print("update na ko padong");

          addnotes(aid);
          interstitialshow();
        },
        child: Container(
          child: Column(
            children: [
              Container(
                child: Icon(
                    Icons.edit
                ),
              ),
              Text("Edit",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,

              )
            ],
          ),
        ),
      );
    }
  }
  widtimein(String tmin){
    DateTime dtme = DateFormat("hh:mm:ss").parse(tmin);
    int newhours = 0;
    String newtime = "";
    if(dtme.hour > 12){
      newhours = dtme.hour - 12;
      newtime = newhours.toString() + ":" + dtme.minute.toString() + " pm";
      return Text(
        'Time In: ' + newtime,
        style: TextStyle(
          color: kColorPrimaryDark,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }else{
      newhours = dtme.hour;
      newtime = newhours.toString() + ":" + dtme.minute.toString() + " am";
      return Text(
        'Time In: ' + newtime,
        style: TextStyle(
          color: kColorPrimaryDark,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }
  }
  widtimeout(String tmin){
    DateTime dtme = DateFormat("hh:mm:ss").parse(tmin);
    int newhours = 0;
    String newtime = "";
    if(dtme.hour > 12){
      newhours = dtme.hour - 12;
      newtime = newhours.toString() + ":" + dtme.minute.toString() + " pm";
      return Text(
        'Time Out: ' + newtime,
        style: TextStyle(
          color: kColorPrimaryDark,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }else{
      newhours = dtme.hour;
      newtime = newhours.toString() + ":" + dtme.minute.toString() + " am";
      return Text(
        'Time Out: ' + newtime,
        style: TextStyle(
          color: kColorPrimaryDark,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }
  }




  addnotes(String aid) {
    print("dialog open edit: " + aid);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Row(
                children: [
                  Text('Note/Accomplishment ' , style: TextStyle(fontSize: 18),),
                  Icon(Icons.event_note, color: Colors.blueAccent,)
                ],
              ),
              content: Container(
                height: 200,
                child: Column(
                    children: <Widget>[
                      Container(

                          padding: const EdgeInsets.fromLTRB(0,5,0,0),
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 2,
                            autocorrect: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(10,10,10,10),
                              border: new OutlineInputBorder(

                                  borderSide: new BorderSide(color: Colors.white)
                              ),


                            ),
                          )
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width-10,
                        color: Colors.grey,
                        child: FlatButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel", style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      Container(
                        height: 5,
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width-10,
                        color: Colors.blueAccent,
                        child: FlatButton(
                          onPressed: (){
                            editattend(aid);
                            Navigator.of(context).pop();
                          },
                          child: Text("Confirmed", style: TextStyle(color: Colors.white),),
                        ),
                      ),

                    ]
                ),
              )
          );
        }
    );

  }
  viewnotes(String notes) {
    _emailController.text = notes;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Add Note'),
              content: Container(
                height: 180,
                child: Column(
                    children: <Widget>[
                      Container(

                          padding: const EdgeInsets.fromLTRB(0,5,0,0),
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            autocorrect: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(10,10,10,10),
                              border: new OutlineInputBorder(

                                  borderSide: new BorderSide(color: Colors.white)
                              ),


                            ),
                          )
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width-10,
                        color: Colors.grey,
                        child: FlatButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: Text("Close", style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      Container(
                        height: 5,
                      ),


                    ]
                ),
              )
          );
        }
    );

  }

}
class Atten{
  final String aid;
  final String adate;
  final String ain;
  final String aout;
  final String alatitude;
  final String alongitude;
  final String note;
  final String stat;

  Atten(this.aid,this.adate, this.ain, this.aout, this.alatitude, this.alongitude,this.note,this.stat);
}