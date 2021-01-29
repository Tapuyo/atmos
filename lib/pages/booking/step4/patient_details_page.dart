import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:doctor_appointment_booking/myvars.dart';
import '../../../components/custom_button.dart';
import '../../../components/doctor_item1.dart';
import '../../../components/text_form_field.dart';
import '../../../data/pref_manager.dart';
import '../../../model/doctor.dart';
import '../../../routes/routes.dart';
import '../../../utils/constants.dart';

class PatientDetailsPage extends StatefulWidget {
  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  bool _isdark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  bool _patient = true;
  var _nameController = TextEditingController();
  var _phoneController = TextEditingController();
  var _patientPhoneController = TextEditingController();
  var _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = AppVar.userfullname;
    _phoneController.text = '+63';
  }

  Widget _patientDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          _patient
              ? '${'please_provide_following_information_about'.tr()}' + AppVar.fname +':'
              : 'please_provide_following_patient_details_dot'.tr(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 35,
        ),
        Text(
          _patient ? '${AppVar.userfullname.tr()}*' : '${AppVar.userfullname.tr()}*',
          style: kInputTextStyle,
        ),
        CustomTextFormField(
          controller: _nameController,
          hintText: _patient ? '' : AppVar.userfullname,
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          '${'mobile'.tr()}*',
          style: kInputTextStyle,
        ),
        CustomTextFormField(
          controller: _phoneController,
          hintText: '+213781348677',
          enabled: false,
        ),
        _patient ? Container() : _patientsMobile(),
        SizedBox(
          height: 15,
        ),
        Text(
          _patient ? '${'your_email'.tr()}*' : '${'patient_email'.tr()}*',
          style: kInputTextStyle,
        ),
        CustomTextFormField(
          controller: _emailController,
          hintText: _patient
              ? 'enter_your_email_id'.tr()
              : 'enter_patient_email_id'.tr(),
        ),
      ],
    );
  }

  Widget _patientsMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        Text(
          'Patient\'s Mobile*',
          style: kInputTextStyle,
        ),
        CustomTextFormField(
          controller: _patientPhoneController,
          hintText: 'Enter Patient\'s Mobile Number',
        ),
      ],
    );
  }

  docavatar() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'patient_details'.tr(),
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
                        color: _isdark ? Colors.transparent : Colors.white,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: <Widget>[
                              docavatar(),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "AppVar.docname",
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
                        )
                      ),
                      Divider(
                        color: _isdark ? Colors.black : Colors.grey[300],
                        height: 0.5,
                      ),
                      Container(
                        width: double.infinity,
                        color: _isdark
                            ? Colors.white.withOpacity(0.12)
                            : Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'purpose_of_visit'.tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'consultation'.tr(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: _isdark ? Colors.black : Colors.grey[300],
                        height: 0.5,
                      ),
                      Container(
                        width: double.infinity,
                        color: _isdark
                            ? Colors.white.withOpacity(0.12)
                            : Colors.white,
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
                              Text(
                                '${'tomorrow'.tr()}, 8:30 AM',
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
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        color: _isdark
                            ? Colors.white.withOpacity(0.12)
                            : Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'this_appointment_for_dot'.tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Material(
                                color: _isdark
                                    ? Colors.white.withOpacity(0.12)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: _isdark
                                            ? Colors.black
                                            : Colors.grey,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      RadioListTile(
                                        value: true,
                                        onChanged: (value) {
                                          setState(() {
                                            _nameController.text =
                                                AppVar.userfullname;
                                            _patient = true;
                                          });
                                        },
                                        groupValue: _patient,
                                        title: Text(AppVar.userfullname),
                                      ),
                                      Divider(
                                        color: _isdark
                                            ? Colors.black
                                            : Colors.grey,
                                        height: 1,
                                      ),
                                      RadioListTile(
                                        value: false,
                                        onChanged: (value) {
                                          setState(() {
                                            _nameController.clear();
                                            _patient = false;
                                          });
                                        },
                                        groupValue: _patient,
                                        title: Text('someone_else'.tr()),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              _patientDetails(),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${'booking_agreement'.tr()} ',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 't_and_c'.tr(),
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
              //color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: CustomButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.bookingStep5);
                },
                text: 'confirm'.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
