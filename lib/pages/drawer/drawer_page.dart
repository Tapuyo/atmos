import 'package:doctor_appointment_booking/Member.dart';
import 'package:doctor_appointment_booking/myvars.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:doctor_appointment_booking/pages/profile/profile_page.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';
import 'package:doctor_appointment_booking/mygroup.dart';
import 'package:doctor_appointment_booking/attend.dart';


class DrawerPage extends StatelessWidget {
  final Function onTap;

  userimage(){

    if(AppVar.photo == ""){
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey,
        backgroundImage: AssetImage(
          'assets/images/icon_man.png',
        ),

      );
    }else{
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.blue,
        child: Image.network(AppVar.photo),
      );
    }
  }

  const DrawerPage({Key key, @required this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Scaffold(
        backgroundColor: kColorPrimary,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 35,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      userimage(),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppVar.cadmin,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),

                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Visibility(
                  visible: AppVar.xcoru,
                  child: _drawerItem(
                    image: 'hospital',
                    text: 'Group',
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyGroup(),
                        ),
                      );
                    }
                  ),
                ),
                Visibility(
                  visible: AppVar.xcoru,
                  child: _drawerItem(
                    image: 'person',
                    text: 'Members',
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Member(),
                        ),
                      );
                    }
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell _drawerItem({
    @required String image,
    @required String text,
    @required Function onTap,
  }) {
    return InkWell(
      onTap: () {
        onTap();
        //this.onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 58,
        child: Row(
          children: <Widget>[
            Image.asset(
              'assets/images/$image.png',
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              text.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
