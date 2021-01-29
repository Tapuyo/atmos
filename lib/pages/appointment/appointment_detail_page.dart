import 'package:doctor_appointment_booking/myvars.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../components/custom_button.dart';
import '../../components/doctor_item1.dart';
import '../../utils/constants.dart';
import '../../data/pref_manager.dart';
import '../../model/doctor.dart';

class AppointmentDetailPage extends StatefulWidget {
  @override
  _AppointmentDetailPageState createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  final bool _isdark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  Widget dateAndTime() {
    return Container(
      width: double.infinity,
      color: _isdark ? Colors.white.withOpacity(0.12) : Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Text(
              'date_and_time'.tr(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '${'tomorrow'.tr()}, 8:30 AM',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${'in'.tr()} 13 ${'hours'.tr()}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget practiceDetail() {
    return Container(
      width: double.infinity,
      color: _isdark ? Colors.white.withOpacity(0.12) : Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Text(
              'practice_detail'.tr(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Malolos Medical Clinic',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Malolos Medical Clinic',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {},
              child: Text(
                'get_direction'.tr().toUpperCase(),
                style: TextStyle(
                  color: kColorBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget procedure() {
    return Container(
      width: double.infinity,
      color: _isdark ? Colors.white.withOpacity(0.12) : Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Text(
              'procedure'.tr(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Consultation',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget bookingDetails() {
    return Container(
      width: double.infinity,
      color: _isdark ? Colors.white.withOpacity(0.12) : Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'booked_for'.tr(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "AppVar.docname",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 80,
                child: VerticalDivider(
                  color: _isdark ? Colors.black : Colors.grey[300],
                  width: 0.5,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'appointment_id'.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '9355476',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'appointment_details'.tr(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: _isdark ? Colors.transparent : Colors.grey[300],
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[

                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                             " AppVar.docname,",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'none',
                              style: TextStyle(
                                color: Colors.grey[350],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                      Divider(
                        color: _isdark ? Colors.black : Colors.grey[300],
                        height: 0.5,
                      ),
                      dateAndTime(),
                      Divider(
                        color: _isdark ? Colors.black : Colors.grey[300],
                        height: 0.5,
                      ),
                      practiceDetail(),
                      Divider(
                        color: _isdark ? Colors.black : Colors.grey[300],
                        height: 0.5,
                      ),
                      procedure(),
                      Divider(
                        color: _isdark ? Colors.black : Colors.grey[300],
                        height: 0.5,
                      ),
                      bookingDetails(),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '${'manage_you_appointments_better'.tr()} ',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'my_appointments'.tr(),
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: CustomButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                text: 'done'.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
