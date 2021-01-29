import 'package:doctor_appointment_booking/components/custom_button.dart';
import 'package:doctor_appointment_booking/components/my_doctor_list_item.dart';
import 'package:doctor_appointment_booking/model/doctor.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doctor_appointment_booking/myvars.dart';

class MyDoctorListPage extends StatelessWidget {

  Future<List<Doctor>> getDoctor() async{
    print("Fetching Doctors");
    print(AppVar.token);
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/doctors/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];
    List<Doctor> doctor = [];

    print(jsondata.toString());

    for (var u in jsondata){
      String names,gender,netimage;

      if(u['profile']['full_name']== null){
        names = "none";
      }else{
        names = u['profile']['full_name'];
      }
      if(u['profile']['gender']== null){
        gender = "male";
      }else{
        gender = u['profile']['gender'];
      }
      if(u['photo_url']== null){
        netimage = "none";
      }else{
        netimage = u['photo_url'];
      }

      Doctor doctors = Doctor(names,gender,netimage);

      doctor.add(doctors);


    }

    print(doctor.length.toString());
    return doctor;
  }

  docavatar(String image, netimage){
    if(netimage == "none"){
      if(image == "female"){
        return CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage('assets/images/icon_doctor_2.png'),
        );
      }if(image == "male"){
        return CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage('assets/images/icon_doctor_1.png'),
        );
      }
    }else
    {
      return CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey,
        backgroundImage: AssetImage('assets/images/icon_doctor_3.png'),
        child: Image.network(netimage),
      );
    }

//return Image.network(netimage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'my_doctor_list'.tr(),
        ),
      ),
      body:  Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
        child: FutureBuilder(
            future: getDoctor(),
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
                            docavatar(snapshot.data[index].gender, snapshot.data[index].netimg),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data[index].name,
                                    style: TextStyle(
                                      color: kColorPrimaryDark,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'none' + '\n',
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
    );
  }
}
class Doctor{
  final String name;
  final String gender;
  final String netimg;

  Doctor(this.name, this.gender, this.netimg);
}