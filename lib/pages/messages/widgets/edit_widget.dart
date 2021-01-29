import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../components/text_form_field.dart';
import '../../../utils/constants.dart';
import 'package:doctor_appointment_booking/myvars.dart';

class EditWidget extends StatefulWidget {
  @override
  _EditWidgetState createState() => _EditWidgetState();
}

class _EditWidgetState extends State<EditWidget> {
  final editfname = TextEditingController();
  final editlname = TextEditingController();
  final editmname = TextEditingController();
  final editcontact = TextEditingController();
  final editgender = TextEditingController();
  final editage = TextEditingController();
  final editaddress = TextEditingController();
  var _selectedGender = AppVar.cemail;

  var _selectedBloodGroup = 'O+';
  var _selectedMarital = 'single'.tr();
  var _genderItems = <String>['male'.tr(), 'female'.tr()];


  var _birthDate = "";

  List<DropdownMenuItem<String>> _dropDownGender;
  List<DropdownMenuItem<String>> _dropDownMarital;


  File _image;

  Future _getImage(ImageSource imageSource) async {
    var image = await ImagePicker.pickImage(source: imageSource);
    setState(() {
      _image = image;
    });
    //uploadPic();
  }
  _initDropDowns() {
    _dropDownGender = _genderItems
        .map((String value) => DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    ))
        .toList();

  }



  @override
  void initState() {
    super.initState();
    _initDropDowns();
    editfname.text = AppVar.cfname;
    editlname.text = AppVar.clname;
    editmname.text = AppVar.cmname;
    editcontact.text = AppVar.ccontact;
    editgender.text = AppVar.cemail;
    editage.text = AppVar.cage;
    editaddress.text = AppVar.caddress;
    _selectedGender = AppVar.cemail;
   ;
    _birthDate = AppVar.cbdate;

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[


            SizedBox(
              height: 25,
            ),
            Text(
              'First name',
              style: kInputTextStyle,
            ),
            TextFormField(
              controller: editfname,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontFamily: 'NunitoSans',
              ),
            ),
            SizedBox(height: 15),
            Text(
              'last_name_dot'.tr(),
              style: kInputTextStyle,
            ),
            TextFormField(
              controller: editlname,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontFamily: 'NunitoSans',
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Middle name',
              style: kInputTextStyle,
            ),
            TextFormField(
              controller: editmname,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontFamily: 'NunitoSans',
              ),
            ),
            SizedBox(height: 15),
            Text(
              'contact_number_dot'.tr(),
              style: kInputTextStyle,
            ),
            TextFormField(
              controller: editcontact,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontFamily: 'NunitoSans',
              ),
            ),

            SizedBox(height: 15),
            Text(
              'gender_dot'.tr(),
              style: kInputTextStyle,
            ),
            DropdownButton(
              isExpanded: true,
              value: _selectedGender,
              //hint: ,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
              items: _dropDownGender,
            ),
            SizedBox(height: 15),
            Text(
              'date_of_birth_dot'.tr(),
              style: kInputTextStyle,
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(_birthDate),
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                ).then((DateTime value) {
                  if (value != null) {
                    setState(() {
                      _birthDate = value.year.toString() + "-" + value.month.toString() + "-" + value.day.toString();
                    });
                  }
                });
              },
            ),
            SizedBox(height: 15),
            Text(
              'Age',
              style: kInputTextStyle,
            ),
            TextFormField(
              controller: editage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontFamily: 'NunitoSans',
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Address',
              style: kInputTextStyle,
            ),
            TextFormField(
              controller: editaddress,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontFamily: 'NunitoSans',
              ),
            ),
          ],
        ),
      ),
    );
  }

  _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.camera,
                  size: 20,
                ),
                title: Text(
                  'take_a_photo'.tr(),
                  style: TextStyle(
                    color: Color(0xff4a4a4a),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  size: 20,
                ),
                title: Text(
                  'choose_a_photo'.tr(),
                  style: TextStyle(
                    color: Color(0xff4a4a4a),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.gallery);
                },
              ),
            ],
          );
        });
  }
}
