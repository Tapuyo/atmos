import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../components/day_slot_item.dart';
import '../../../components/doctor_item1.dart';
import '../../../components/time_slot_item.dart';
import '../../../model/doctor.dart';
import '../../../routes/routes.dart';
import 'package:doctor_appointment_booking/myvars.dart';
import '../../../components/custom_button.dart';

class TimeSlotPage extends StatefulWidget {
  @override
  _TimeSlotPageState createState() => _TimeSlotPageState();
}

class _TimeSlotPageState extends State<TimeSlotPage> {

  List scheddata = [];
  List mylist =  [];
  int _selectedIndex = -1;
  bool selected;

  mydays(String dy){
    if(dy == '0'){
      return Text(
        "Monday",
        style: Theme.of(context).textTheme.subtitle2.copyWith(
            fontWeight: FontWeight.w600),
      );
    }
    if(dy == '1'){
      return Text(
        "Tuesday",
        style: Theme.of(context).textTheme.subtitle2.copyWith(
            fontWeight: FontWeight.w600),
      );
    }
    if(dy == '2'){
      return Text(
        "Wednesday",
        style: Theme.of(context).textTheme.subtitle2.copyWith(
            fontWeight: FontWeight.w600),
      );
    }
    if(dy == '3'){
      return Text(
        "Thursday",
        style: Theme.of(context).textTheme.subtitle2.copyWith(
            fontWeight: FontWeight.w600),
      );
    }
    if(dy == '4'){
      return Text(
        "Friday",
        style: Theme.of(context).textTheme.subtitle2.copyWith(
            fontWeight: FontWeight.w600),
      );
    }
    if(dy == '5'){
      return Text(
        "Saturday",
        style: Theme.of(context).textTheme.subtitle2.copyWith(
            fontWeight: FontWeight.w600),
      );
    }
    if(dy == '6'){
      return Text(
        "Sunday",
        style: Theme.of(context).textTheme.subtitle2.copyWith(
            fontWeight: FontWeight.w600),
      );
    }

  }


  Future<List<Sched>> getSched(String sh) async{
    print("Fetching Schedule");
    print(AppVar.token);
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/clinics/" + sh + "/schedule/slots/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];
    print(jsondata.toString());

    List<Sched> sched = [];

    print(jsondata.toString());

    for (var u in jsondata){
      String id,schedid,start;

      if(u['id'].toString() == null){
        id = "none";
      }else{
        id = u['id'].toString();
      }
      if(u['start_time'].toString() == null){
        schedid = "male";
      }else{
        schedid = u['start_time'].toString();
      }
      if(u['day'].toString() == null){
        start = "none";
      }else{
        start = u['day'].toString();
      }

      Sched sch = Sched(id,schedid,start);

      sched.add(sch);
    }

    print(sched.length.toString());
    return sched;
  }





  Widget _slot(String time, int slots, String hour) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: RichText(
            text: TextSpan(
              children: [

                TextSpan(
                  text: '$time ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '$slots ${'slots'.tr().toLowerCase()}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: '$time ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        /*ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
            width: 10,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return DaySlotItem(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              selected: _selectedIndex == index,
            );
          },
        ),*/
        SizedBox(
          height: 15,
        ),
        StaggeredGridView.countBuilder(
          padding: EdgeInsets.symmetric(horizontal: 10),
          crossAxisCount: 4,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: slots,
          staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemBuilder: (context, index) {
            return TimeSlotItem(
              time: hour,
              onTap: () {
                Navigator.of(context).pushNamed(Routes.bookingStep4);
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("AppVar.docname"),
      ),
      body: Container(
        //scrollDirection: Axis.vertical,

      ),
    );
  }
}


class Doctor{
  final String name;
  final String desc;
  final String clinicid;

  Doctor(this.name, this.desc, this.clinicid);
}

class Sched{
  final String id;
  final String schedule_id;
  final String start_time;

  Sched(this.id, this.schedule_id, this.start_time);
}