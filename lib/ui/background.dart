import 'dart:ui';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Mybackground extends StatelessWidget {
  Mybackground({super.key, required this.screens});
  List<Widget> screens;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
          Positioned.fill(
            child: Image.asset(
              'assets/icon/12.png',
              fit: BoxFit.cover,
            ),
          ),
          // Blur effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 200.0, sigmaY: 200.0),
              child: Container(
                color: Colors.black.withOpacity(0.4), // Optional: Add a slight tint
              ),
            ),
          ),

        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: screens,
          ),
        ),
      ],
    );
  }
}
