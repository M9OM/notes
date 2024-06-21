import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:notes/utils/constants/lang/str_extntion.dart';

import '../../screens/room_screen/components/member_list.dart';
import 'lang/translate_constat.dart';

void showMsgDialogEndOrLeave(
    {required BuildContext context,
    required String title,
    required Function leave,
    required Function end}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: AlertDialog(
          // Use AlertDialog for other platforms
          // title: Text('Permission Required'),
          content: Text(title),
          actions: <Widget>[
            IconButton(
              icon: Text(
                TranslationConstants.end.t(context),
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                end();
                Navigator.of(context).pop();
              },
            ),
            IconButton(
              icon: Text(
                TranslationConstants.leave.t(context),
              ),
              onPressed: () {
                leave();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}

void showMsgDialog(
    {required BuildContext context,
    required String title,
    required Function onTap}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: AlertDialog(
          // Use AlertDialog for other platforms
          // title: Text('Permission Required'),
          content: Text(title),
          actions: <Widget>[
            IconButton(
              icon: Text(
                TranslationConstants.yes.t(context),
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                onTap();
                Navigator.of(context).pop();
              },
            ),
            IconButton(
              icon: Text(
                TranslationConstants.no.t(context),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}

void showMsgDialogoneBun(
    {required BuildContext context,
    required String title,
    required Function onTap}) {
  showDialog(
    context: context,
    barrierDismissible:
        false, // Prevents dismissing the dialog by tapping outside

    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: AlertDialog(
          // Use AlertDialog for other platforms
          // title: Text('Permission Required'),
          content: Text(title),
          actions: <Widget>[
            IconButton(
              icon: Text(
                TranslationConstants.close.t(context),
              ),
              onPressed: () {
                Navigator.of(context).pop();

                onTap();
              },
            ),
          ],
        ),
      );
    },
  );
}

void showRoomMembersDialog(BuildContext context, MembersList membersList) {
  showDialog(
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: AlertDialog(
          backgroundColor: Color.fromARGB(239, 0, 0, 0),
          title: Text(TranslationConstants.members.t(context)),
          content: Container(
            width: double.maxFinite,
            child: membersList,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                TranslationConstants.close.t(context),
                style: TextStyle(color: primary),
              ),
            ),
          ],
        ),
      );
    },
  );
}
