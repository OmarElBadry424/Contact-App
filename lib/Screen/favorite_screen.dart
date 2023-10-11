import 'package:contacts_app/Local/contact_cubit.dart';
import 'package:contacts_app/Local/contact_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../Widgets/contactlistbuilder.dart';


class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map>favList=[];
  @override
  void initState() {
    favList= ContactCubit.get(context).favorites;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<ContactCubit, ContactState>(
      builder: (context, state) {
        return ContactListBuilder(
          contacts: favList,
          noContactText: "No Favorites",
          contactType: "favorite",
        );
      },
    );
  }
}

