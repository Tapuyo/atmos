import 'package:admob_flutter/admob_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:doctor_appointment_booking/myvars.dart';
import 'profile_info_tile.dart';

class InfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return mybody(context);
  }
  mybody(BuildContext context){
    if(AppVar.chose == "YES"){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(
              AppVar.cadmin,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            subtitle: Text(
              AppVar.cemail,
              style: Theme.of(context).textTheme.subtitle2,
            ),

          ),
          Divider(
            height: 0.5,
            color: Colors.grey[200],
            indent: 15,
            endIndent: 15,
          ),

          ProfileInfoTile(
            title: 'Admin User',
            trailing: AppVar.cemail,
            hint: 'add age',
          ),

          ProfileInfoTile(
            title: 'Company',
            trailing: AppVar.ccomp,
            hint: 'first name',
          ),


          ProfileInfoTile(
            title: '',
            trailing: AppVar.caddress,
            hint: 'add_location'.tr(),
          ),
        ],
      );
    }else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(
              AppVar.cadmin,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            subtitle: Text(
              AppVar.clname,
              style: Theme.of(context).textTheme.subtitle2,
            ),

          ),
          Divider(
            height: 0.5,
            color: Colors.grey[200],
            indent: 15,
            endIndent: 15,
          ),
          ProfileInfoTile(
            title: 'First Name',
            trailing: AppVar.cfname,
            hint: 'first name',
          ),
          ProfileInfoTile(
            title: 'Middle Name',
            trailing: AppVar.cmname,
            hint: 'middle name',
          ),
          ProfileInfoTile(
            title: 'Last Name',
            trailing: AppVar.clname,
            hint: 'last name',
          ),
          ProfileInfoTile(
            title: 'contact_number'.tr(),
            trailing: AppVar.ccontact,
            hint: 'Add phone number',
          ),

          ProfileInfoTile(
            title: 'gender'.tr(),
            trailing: AppVar.cemail,
            hint: 'add_gender'.tr(),
          ),
          ProfileInfoTile(
            title: 'date_of_birth'.tr(),
            trailing: AppVar.cbdate,
            hint: 'yyyy mm dd',
          ),

          ProfileInfoTile(
            title: 'Age',
            trailing: AppVar.cage,
            hint: 'add age',
          ),

          ProfileInfoTile(
            title: '',
            trailing: AppVar.caddress,
            hint: 'add_location'.tr(),
          ),
          AdmobBanner(adUnitId: 'ca-app-pub-1156390496952979/1733346008', adSize: AdmobBannerSize.LARGE_BANNER),
        ],
      );
    }
  }
}
