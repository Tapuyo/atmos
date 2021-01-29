import 'package:doctor_appointment_booking/components/custom_button.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doctor_appointment_booking/myvars.dart';

class MemberSearch extends StatefulWidget {
  String something;

  MemberSearch(this.something);
  @override
  _GroupdSearchState createState() => _GroupdSearchState(this.something);
}

class _GroupdSearchState extends State<MemberSearch> {
  String something;

  _GroupdSearchState(this.something);

  Future<List<Group>> getGroup() async{
    print("Calling member"+ AppVar.cid);
    List<Group> group = [];
    final response = await http.post(AppVar.myhost + "member.php",
        headers: {'Header': 'application/x-www/form-urlencoded', "Accept": "application/json"},
        body: {"comp": AppVar.cid, "grp": something, "mem":""});

    var jsondata = json.decode(response.body);


    print("Result member" + response.body.toString());

    for (var u in jsondata){
      String compid,gid,gname,gdesciption,gdate;


      if(u['mqr'] == null){
        compid = "none";
      }else{
        compid = u['mqr'];
      }
      if(u['mgroupid']== null){
        gid = "none";
      }else{
        gid = u['mgroupid'];
      }
      if(u['mfname']== null){
        gname = "none";
      }else{
        gname = u['mfname'];
      }
      if(u['mmname']== null){
        gdesciption = "none";
      }else{
        gdesciption = u['mmname'];
      }
      if(u['mlname']== null){
        gdate = "none";
      }else{
        gdate = u['mlname'];
      }

      Group grp = Group(compid,gid,gname,gdesciption,gdate);

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
          'My Members List',
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
                      return GestureDetector(
                        onTap: (){
                           setState(() {
                             AppVar.seid =  snapshot.data[index].mqr;
                             AppVar.cadmin = snapshot.data[index].mfname;
                           });
                            Navigator.pop(context);
                            Navigator.pop(context);
                        },
                        child: Container(
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
                                    'assets/images/person.png',
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
                                        snapshot.data[index].mfname,
                                        style: TextStyle(
                                          color: kColorPrimaryDark,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data[index].mlname,
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



                              ],
                            ),
                          ),
                        ),
                      );
                    }
                );

              }
            }

        ),
      ),

    );
  }
}
class Group{
  final String mqr;
  final String mgroupid;
  final String mfname;
  final String mmname;
  final String mlname;


  Group(this.mqr, this.mgroupid, this.mfname, this.mmname, this.mlname);
}