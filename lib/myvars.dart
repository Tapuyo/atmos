import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';

class AppVar{
  static String myhost = "https://eassatt.000webhostapp.com/atmos/";
  static String token;

  //company or member
  static String xcomp;
  static bool xcoru;

  //location
  static String lati = "";
  static String longi = "";

  //login
  static bool nowlog = false;
  static String radiolog = "two";
  static String choicelog = "";

  //userinfo atmos
  static String chose = "";
  static String cid = "";
  static String ccomp = "";
  static String cadmin = "";
  static String caddress = "";
  static String cuser = "";
  static String cpass = "";
  static String ccontact = "";
  static String cemail = "";
  static String cgrp = "";
  static String cfname = "";
  static String clname = "";
  static String cmname = "";
  static String cbdate = "";
  static String cage = "";

  //group
  static String gname = "";
  static String gdescription = "";
  static String gdate = "";
  static String gamin = "";
  static String gamout = "";
  static String gstr = "";

  static DateTime dtme = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
  static String dtfrom = dtme.year.toString() + "-" + dtme.month.toString() + "-" +dtme.day.toString();
  static String dtto = dtme.year.toString() + "-" + dtme.month.toString() + "-" +dtme.day.toString();


  //user
  static String userfullname = "";
  static String fname = "";
  static String photo = "";

  static String seid = "";



}