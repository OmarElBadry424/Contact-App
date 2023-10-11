import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

var contactName= TextEditingController();
var phoneNumber= TextEditingController();

var myCountry =CountryCode(name:"EG",dialCode: "+20");
var scaffoldKey =GlobalKey<ScaffoldState>();
var formkey =GlobalKey<FormState>();