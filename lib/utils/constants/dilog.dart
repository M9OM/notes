import 'dart:io';
import 'dart:ui';

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


  void _showRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.7),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('انشاء غرفة'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'اسم الغرفة',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
                SizedBox(height: 20),

              ],
            ),
            actions: [
              TextButton(
                child: const Text('الغاء'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text('انشاء'),
                onPressed: () {
                  // Handle room creation logic here
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }