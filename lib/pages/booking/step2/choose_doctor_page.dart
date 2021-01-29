import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../components/doctor_item.dart';
import '../../../components/round_icon_button.dart';

import '../../../model/doctor.dart';
import '../../../routes/routes.dart';
import '../../../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:doctor_appointment_booking/myvars.dart';


class ChooseDoctorPage extends StatelessWidget {

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
      String docid,names,gender,netimage;

      if(u['profile']['profilable_id']== null){
        docid = "none";
      }else{
        docid = u['profile']['profilable_id'];
      }

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

      Doctor doctors = Doctor(docid,names,gender,netimage);

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
        centerTitle: true,
        title: Text(
          'doctor'.tr(),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.filter);
            },
            icon: Icon(
              Icons.filter_list,
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        //scrollDirection: Axis.vertical,
        child: Container(
          child: FutureBuilder(
              future: getDoctor(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
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
                      padding: EdgeInsets.symmetric(horizontal: 20),

                      itemBuilder: (context, index){
                        return Card(
                          child: GestureDetector(
                            onTap: (){


                                Navigator.of(context).pushNamed(Routes.bookingStep3);

                            },
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(20),
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
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  snapshot.data[index].name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2
                                                      .copyWith(fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: kColorBlue,
                                                size: 18,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                '0',
                                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            "none",
                                            style: TextStyle(
                                              color: Colors.grey[350],
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Start from Php 0.00',
                                            style: Theme.of(context).textTheme.subtitle2.copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Divider(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
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
      ),
    );
  }
}
class Doctor{
  final String docid;
  final String name;
  final String gender;
  final String netimg;

  Doctor(this.docid,this.name, this.gender, this.netimg);
}

//Navigator.of(context).pushNamed(Routes.bookingStep3);