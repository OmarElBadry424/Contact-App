import 'package:bloc/bloc.dart';
import 'package:contacts_app/Local/contact_state.dart';
import 'package:contacts_app/Screen/contacts_screen.dart';
import 'package:contacts_app/Screen/favorite_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class ContactCubit extends Cubit<ContactState> {
  ContactCubit() :super(InitialContactState());

  static ContactCubit get(context) => BlocProvider.of(context);

  List<String> screenTitles = ["Contacts", "Favorites"];

  List<Widget>screen=[
    const  ContactsScreen(),
    const  FavoritesScreen()
  ];

  bool isBottomSheetShow= false;
  IconData icons = Icons.add;
  void changeBottomSheet({required IconData icon,required bool isShown}){
    isBottomSheetShow=isShown;
    icons= icon;
    emit(ChangeBottomSheetContactState());
  }

  int currentIndex = 0;
  void changeNavigatorBottom(int index){
    currentIndex= index;
    emit(ChangeBottomNavigatorContactState());
  }

  late Database database;
  //CRUD
  createDataBase() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    print(databasesPath);
    String path = join(databasesPath, 'contact.db');
    // open the database
    database = await openDatabase(path, version: 1,
        onCreate: (db, version) {
          db.execute(
              'CREATE TABLE Contact (id INTEGER PRIMARY KEY, name TEXT, phoneNumber TEXT, type TEXT )')
              .then
            ((value) {
            print("table created ");
            emit(TableContactState());
          }).catchError((error) {
            print(error);
          });},
        onOpen: (db) {
          getContacts(db);
        });
  }

  insertDataBase({ required String name, required String phoneNumber}) async {
    await database.transaction((txn) {
      return txn.rawInsert(
          'INSERT INTO Contact(name, phoneNumber,type) VALUES("$name", "$phoneNumber","all")').
      then((value)async {
        print(" $value successfully inserted ");
        emit(InsertDataContactState());
        getContacts(database);
      }).
      catchError((error) {
        print(" error is $error ");
      });
    });
  }

  List <Map> contacts = [];
  List<Map> favorites = [];

// 3 state
//   1- loading
//   2- success
//   3- error

  getContacts(Database database) async {
    emit(GetLoadingDataContactState());
    contacts.clear();
    favorites.clear();
    await database.rawQuery('SELECT * FROM Contact').then((value) {
      for (Map<String, Object?> element in value) {
        contacts.add(element);
        if (element['type'] == "favorite") {
          favorites.add(element);
        }
      }
      emit(GetSuccessDataContactState());
    }).catchError((error){
      print(error);
      emit(ErrorGetDataContactState());
    });

  }

  updateDataBase(
      {required  int id, required String name,
        required String phoneNumber}) async {

    await  database.rawUpdate(
        'UPDATE Contact SET name = ?, phoneNumber = ?  WHERE id = ? ',
        [name, phoneNumber, id]).then((value) {
      emit(UpdateContactsDataContactState());

      getContacts(database);
      print(value);
    }).catchError((error) {
      print(error);
    });
  }

// update type
  addOrRemoveFavorite({required String type, required int id }) async{
    await database.rawUpdate('UPDATE Contact SET type = ? WHERE id = ?',[type, id])
        .then((value) {
      print("update type ");
      getContacts(database);
      emit(UpdateFavoriteDataContactState());
    }).catchError((error){
      print(error);
      emit(ErrorUpdateFavoriteDataContactState());
    });
  }
  Future<void> deleteContact({
    required int id,
  }) async {
    await database
        .rawDelete('DELETE FROM Contact WHERE id = ?', [id]).then((value)
    {
      getContacts(database);
      emit(AppDeleteContactState());
    });

  }}