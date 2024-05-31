import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showMsgDialog({required BuildContext  context, required String title,required Function onTap}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // Use AlertDialog for other platforms
        // title: Text('Permission Required'),
        content: Text(title),
        actions: <Widget>[
          IconButton(
            icon: const Text(
              'نعم',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              onTap();

              Navigator.of(context).pop();
            },
          ),
          IconButton(
            icon: const Text(
              'لا',
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


