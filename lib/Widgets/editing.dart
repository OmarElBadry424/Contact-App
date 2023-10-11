
import 'package:contacts_app/Utilites/colors.dart';
import 'package:contacts_app/Utilites/const..dart';
import 'package:contacts_app/Local/contact_cubit.dart';
import 'package:contacts_app/Widgets/deafult_text.dart';
import 'package:contacts_app/Widgets/default_formfield.dart';
import 'package:contacts_app/Widgets/default_phone.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

class EditingContact extends StatefulWidget{
  final Map contactModel ;

  const EditingContact({super.key, required this.contactModel});

  @override
  State<EditingContact> createState() => _EditingContactState();
}

class _EditingContactState extends State<EditingContact> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.gray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultFormField(
              controller: contactName,
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Name Cant be empty ";
                }
                return null;
              },
              textColor: AppTheme.white,
              prefixIcon: Icon(Icons.title),
              hintText: "Contacts Name",
            ),
            DefaultPhoneField(
              controller: phoneNumber,
              validator: (value) {
                if (value!.isEmpty) {
                  return "phone number must not be empty ";
                }
                return null;
              },
              labelText: "Phone Number",
              onChange: (countryCode) {
                myCountry = countryCode;
              },
              hintText: "Contact Phone Number",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: TextButton(
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        await ContactCubit.get(context).updateDataBase(
                            name: contactName.text,
                            phoneNumber:
                            "${myCountry.dialCode}${phoneNumber.text}",
                            id: widget.contactModel['id']);
                        Fluttertoast.showToast(
                          msg: "Contact Editing Successfully",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 3,
                          backgroundColor: AppTheme.gray,
                          textColor: AppTheme.primaryColor,
                          fontSize: 12.sp,
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: DefaultText(
                      text: "Save",
                      color: AppTheme.primaryColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                Flexible(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: DefaultText(
                      text: "Cancel",
                      color: AppTheme.primaryColor,
                      fontSize: 12.sp,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}