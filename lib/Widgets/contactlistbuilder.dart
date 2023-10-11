import 'package:contacts_app/Widgets/contact_card.dart';
import 'package:contacts_app/Widgets/deafult_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ContactListBuilder extends StatelessWidget{
  final List<Map>contacts;
  final String noContactText;
  final String contactType;

  ContactListBuilder({super.key ,required this.contacts,
    required this.noContactText,
    required this.contactType

  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible:contacts.isNotEmpty,
      replacement: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.no_accounts),
            SizedBox(height: 1.h,),
            DefaultText(
              text: noContactText,
            )
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index)=> SizedBox(height: 2.h,) ,
          itemCount: contacts.length,
          itemBuilder: (context, index)=> ContactsCard(contactModel:
          contacts[index],),
        ),
      ),
    );
  }

}