
import 'package:contacts_app/Local/contact_cubit.dart';
import 'package:contacts_app/Local/contact_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Widgets/contactlistbuilder.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Map> contactsList=[];
  @override
  void initState() {
    contactsList = ContactCubit.get(context).contacts;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactCubit, ContactState>(
      builder: (context, state) {
        return ContactListBuilder(
          contacts: contactsList,
          noContactText: "No CONTACTS",
          contactType: "all",
        );
      },
    );
  }
}
