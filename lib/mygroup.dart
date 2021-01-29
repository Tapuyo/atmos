import 'package:doctor_appointment_booking/components/custom_button.dart';
import 'package:doctor_appointment_booking/components/my_doctor_list_item.dart';
import 'package:doctor_appointment_booking/model/doctor.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doctor_appointment_booking/myvars.dart';

class MyGroup extends StatefulWidget {
  @override
  _SelectFrom createState() => _SelectFrom();
}

class _SelectFrom extends State<MyGroup> {

  Future<List<Group>> getGroup() async{
    List<Group> group = [];
    final response = await http.post(AppVar.myhost + "group.php",
        headers: {'Header': 'application/x-www/form-urlencoded', "Accept": "application/json"},
        body: {"cid": AppVar.cid, "gid": ""});

    var jsondata = json.decode(response.body);


    print(jsondata.toString());

    for (var u in jsondata){
      String compid,gid,gname,gdesciption,gdate,gamin,gamout,gstr;


      if(u['gcompanyid'] == null){
        compid = "none";
      }else{
        compid = u['gcompanyid'];
      }
      if(u['gid']== null){
        gid = "none";
      }else{
        gid = u['gid'];
      }
      if(u['gname']== null){
        gname = "none";
      }else{
        gname = u['gname'];
      }
      if(u['gdescription']== null){
        gdesciption = "none";
      }else{
        gdesciption = u['gdescription'];
      }
      if(u['gdate']== null){
        gdate = "none";
      }else{
        gdate = u['gdate'];
      }
      if(u['gamin']== null){
        gamin = "none";
      }else{
        gamin = u['gamin'];
      }
      if(u['gamout']== null){
        gamout = "none";
      }else{
        gamout = u['gamout'];
      }
      if(u['gstr']== null){
        gstr = "none";
      }else{
        gstr = u['gstr'];
      }
      Group grp = Group(compid,gid,gname,gdesciption,gdate,gamin,gamout,gstr);

      group.add(grp);


    }

    print(group.length.toString());
    return group;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Group List',
        ),
      ),
      body:  Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
        child: FutureBuilder(
            future: getGroup(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
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
                );
              }else{
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    //scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (context, index){
                      return Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Container(

                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffEBF2F5),
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                child:  Image.asset(
                                  'assets/images/hospital.png',
                                  color: Colors.blueAccent,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data[index].gname,
                                      style: TextStyle(
                                        color: kColorPrimaryDark,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data[index].gdesciption,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              CustomButton(
                                text: 'details'.tr(),
                                textSize: 14,
                                onPressed: () {},
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 5,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                );

              }
            }

        ),
      ),
      floatingActionButton: Container(
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

            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kColorBlue,
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
    );
  }
}
class Group{
  final String compid;
  final String gid;
  final String gname;
  final String gdesciption;
  final String gdate;
  final String gamin;
  final String gamout;
  final String gstr;

  Group(this.compid, this.gid, this.gname, this.gdesciption, this.gdate, this.gamin, this.gamout, this.gstr);
}