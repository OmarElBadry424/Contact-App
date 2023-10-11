import 'package:contacts_app/Utilites/colors.dart';
import 'package:contacts_app/Local/contact_cubit.dart';
import 'package:contacts_app/Widgets/deafult_text.dart';
import 'package:contacts_app/Widgets/editing.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
class ContactsCard extends StatelessWidget {
  final Map contactModel;

  const ContactsCard({Key? key, required this.contactModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) async {

        await ContactCubit.get(context).deleteContact(id: contactModel['id']);
        Fluttertoast.showToast(
            msg: "Contact Deleted Successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: AppTheme.gray,
            fontSize: 14.sp);
      },
      child: InkWell(
        onTap: (){
          Fluttertoast.showToast(
              msg: "Long touch for contact editing, Swipe left or right to delete,"
                  " and double touch for calling Contact.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: AppTheme.gray,
              textColor: AppTheme.white,
              fontSize: 14.sp);
        },
        onLongPress: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => EditingContact(contactModel: contactModel),
          );
        },
        onDoubleTap: () async{
          final Uri launchUri = Uri(
              scheme: 'tel',
              path: contactModel['phoneNumber']
          );
          await launchUrl(launchUri);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.sp),
              color: AppTheme.primaryColor
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(start: 2.w),
                      child: DefaultText(
                        text: contactModel['name'],
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        color: AppTheme.white,
                      ),
                    ),
                  ),
                  Flexible(
                    child: DefaultText(
                      text: contactModel['phoneNumber'],
                      fontSize: 14.sp,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: AppTheme.white,
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: contactModel['type'] == 'favorite',
                replacement: IconButton(
                  onPressed: () => ContactCubit.get(context).addOrRemoveFavorite(
                      type: 'favorite', id: contactModel['id']),
                  icon: const Icon(
                    Icons.favorite_border_outlined,
                    color: Colors.red,
                  ),
                ),
                child: IconButton(
                  onPressed: () => ContactCubit.get(context)
                      .addOrRemoveFavorite(type: 'all', id: contactModel['id']),
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

