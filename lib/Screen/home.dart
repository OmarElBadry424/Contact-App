
import 'package:contacts_app/Utilites/colors.dart';
import 'package:contacts_app/Local/contact_cubit.dart';
import 'package:contacts_app/Local/contact_state.dart';
import 'package:contacts_app/Widgets/deafult_text.dart';
import 'package:contacts_app/Widgets/default_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../Utilites/const..dart';
import '../Widgets/default_phone.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late ContactCubit cubit;

  @override
  void initState() {
    // cubit= ContactCubit.get(context).createDataBase();
    cubit = ContactCubit.get(context);
    cubit.createDataBase();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    ContactCubit cubit=ContactCubit.get(context);
    return BlocConsumer<ContactCubit, ContactState>(
      listener: (context, state) {
        if(state is InsertDataContactState){
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            title: DefaultText(
              text: cubit.screenTitles[cubit.currentIndex],
              fontWeight: FontWeight.bold,
            ),
          ),
          body: Stack(children: [
            Container(
              decoration:  BoxDecoration(
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.centerStart,
                    end: AlignmentDirectional.bottomEnd,
                    colors: [AppTheme.primaryColor,
                      AppTheme.secondColor],
                  )),
            ),
            BlocConsumer<ContactCubit, ContactState>(
                listener:(context, state){
                  if (state is GetLoadingDataContactState)  {
                    const  Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if(state is ErrorGetDataContactState ){
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 75.sp,
                          ),
                          DefaultText(
                            text: 'Error !',

                          ),
                        ],
                      ),
                    );
                  }},
                builder: (BuildContext context, state) {
                  return cubit.screen[cubit.currentIndex];
                }

            ),
          ]),

          floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () async {
              if (cubit.isBottomSheetShow) {
                if (formkey.currentState!.validate()) {
                  await cubit.insertDataBase(
                      name: contactName.text,
                      phoneNumber: phoneNumber.text);
                }
              } else {
                cubit.changeBottomSheet(
                    isShown: true, icon: Icons.add_box_outlined);
                scaffoldKey.currentState!
                    .showBottomSheet(
                      (context) =>
                      Wrap(children: [
                        Container(
                          color: AppTheme.secondColor,
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 3.w),
                          child: Form(
                            key: formkey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 1.h),
                                  child: DefaultFormField(
                                    controller: contactName,
                                    keyboardType: TextInputType.name,
                                    validator: (text) {
                                      if (text!.isEmpty) {
                                        return "Name can't be empty";
                                      }
                                      return null;
                                    },
                                    textColor: AppTheme.white,
                                    prefixIcon:
                                    const Icon(Icons.title_outlined),
                                    hintText: 'Contact Name',
                                  ),
                                ),
                                DefaultPhoneField(
                                  controller: phoneNumber,
                                  validator: (text) {
                                    if (text!.isEmpty) {
                                      return "Phone Number can't be empty";
                                    }
                                    return null;
                                  },
                                  labelText: 'Contact Phone Number',
                                  onChange: (countryCode) {
                                    myCountry = countryCode;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                ).closed
                    .then(
                      (value) =>
                      cubit.changeBottomSheet(
                          isShown: false, icon: Icons.person_add),
                );
              }
            },
            backgroundColor: AppTheme.primaryColor,
            elevation: 20,
            child: const Icon(Icons.add),


          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            shape: const CircularNotchedRectangle(),
            notchMargin: 12,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 10.sp,
              backgroundColor: Colors.transparent,
              selectedItemColor: AppTheme.primaryColor,
              unselectedItemColor: AppTheme.gray,
              elevation: 0,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeNavigatorBottom(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: const Icon(Icons.contacts), label: cubit.screenTitles[0]),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.favorite), label: cubit.screenTitles[1]),
              ],
            ),
          ),
        );
      },
    );
  }
}

