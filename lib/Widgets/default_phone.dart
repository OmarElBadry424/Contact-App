import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultPhoneField extends StatelessWidget{
  TextEditingController ? controller;
  String? Function(String?)? validator;
  TextInputType? keyBoardType;
  Function(CountryCode)? onChange;
  String? hintText;
  String? labelText;
  DefaultPhoneField({required this.controller,this.hintText,this.labelText,
    required this.validator, this.keyBoardType,
    this.onChange
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:controller ,
      validator: validator,
      keyboardType: keyBoardType,
      decoration: InputDecoration(
        prefixIcon: CountryCodePicker(
          onChanged:onChange ,
          initialSelection: 'EG',
          favorite: ['+20','EG'],
        ),
        hintText: hintText,
        labelText: labelText,
      ),

    );
  }

}