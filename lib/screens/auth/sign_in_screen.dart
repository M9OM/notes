import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '/screens/auth/registration_screen.dart';
import '/utils/constants/color.dart';
import '/utils/constants/screenSize.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../controllers/loading_controller.dart';
import '../../ui/background.dart';
import 'components/welcomeMsgCard.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingController>(
        builder: (context, authController, child) {
      return ModalProgressHUD(
        inAsyncCall: authController.isloading,
        child: Scaffold(
          body: Mybackground(
            
            mainAxisAlignment  : MainAxisAlignment.center,
            screens: [
            FadeInUp(
              duration: const Duration(milliseconds: 1500),
              child: GradientText(
                gradientDirection: GradientDirection.ttb,
                'مرحبا بك هنا 💣',
                style: const TextStyle(
                    fontSize: 80.0, fontWeight: FontWeight.w700),
                colors: [
                  const Color.fromARGB(255, 255, 145, 111),
                  primary,
                ],
              ),
            ),
            const WelcomeMsg(),
            const SizedBox(height: 20),
            SizedBox(
              width: ScreenSizeExtension(context).screenWidth * 0.8,
              child: ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.all(25.0),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    primary,
                  ),
                ),
                onPressed: () async {
                  // authController.loading(true);
                  // await AuthService().signInAnonymously();
                  //                   authController.loading(false);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistrationScreen(),
                      ));
                },
                child: const Text(
                  'ابدأ الآن 💣 ',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 18),
                ),
              ),
            ),
          ]),
        ),
      );
    });
  }
}
