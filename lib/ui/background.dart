import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class Mybackground extends StatelessWidget {
  Mybackground({super.key, required this.screens});
  List<Widget> screens;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7), // Adjust the opacity here
                BlendMode.darken,
              ),
              image: AssetImage('assets/icon/bg.png'),
              fit: BoxFit.cover)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: screens,
        ),
      ),
    );
  }
}
