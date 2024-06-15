import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notes/route/route_screen.dart';
import 'package:notes/screens/auth/login_screen.dart';
import 'package:notes/screens/home/home_screen.dart';
import 'package:notes/utils/constants/assets_constants.dart';
import 'package:notes/utils/constants/lang/str_extntion.dart';
import 'package:notes/utils/constants/lang/translate_constat.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/auth_service.dart';
import '../../ui/background.dart';
import '../../utils/constants/color.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // GlobalKey for form validation
  bool loading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Mybackground(
        mainAxisAlignment: MainAxisAlignment.center,
        screens: <Widget>[
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey, // Use the key here
              child: Column(
                children: <Widget>[
                  FadeInUp(
                    duration: const Duration(milliseconds: 1200),
                    child: Center(
                      child: SizedBox(
                        width: 150,
                        child: SvgPicture.asset(
                          AssetsConstants.logoSvg,
                          width: 100,
                          color: primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1800),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: GetThemeData(context).theme.highlightColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(168, 252, 210, 0.123),
                            blurRadius: 20.0,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: primary,
                                ),
                              ),
                            ),
                            child: TextFormField(
                              controller: emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return TranslationConstants.email_required
                                      .t(context);
                                }
                                if (!isValidEmail(value)) {
                                  return TranslationConstants.email_format_error
                                      .t(context);
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: TranslationConstants.email.t(context),
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: primary,
                                ),
                              ),
                            ),
                            child: TextFormField(
                              controller: userNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return TranslationConstants.username_required
                                      .t(context);
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: TranslationConstants.name.t(context),
                                hintStyle: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(),
                            child: TextFormField(
                              controller: passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return TranslationConstants.password_required
                                      .t(context);
                                }
                                if (value.length < 8) {
                                  return TranslationConstants.password_length
                                      .t(context);
                                }
                                return null;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: TranslationConstants.password
                                    .t(context),
                                hintStyle: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 2100),
                    child: InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          // Validate form fields
                          final String email = emailController.text;
                          final String password = passwordController.text;
                          final String userName = userNameController.text;
                          setState(() {
                            loading = true;
                          });

                          var auth = await AuthService()
                              .registerWithEmailAndPassword(
                                  email, password, userName);
                          if (auth == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                content: Row(
                                  children: [
                                    const Icon(Icons.error_outline),
                                    const SizedBox(width: 10),
                                    Text(
                                      TranslationConstants.email_already_used
                                          .t(context),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            await AuthService().registerWithEmailAndPassword(
                                email, password, userName);
                            navigateScreenWithoutGoBack(
                                context, const HomeScreen());
                          }

                          setState(() {
                            loading = false;
                          });
                        }
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: primary,
                        ),
                        child: Center(
                          child: loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 4,
                                  ))
                              : Text(
                                  TranslationConstants.create_account
                                      .t(context),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 2100),
                    child: InkWell(
                      onTap: () {
                        navigateScreenWithoutGoBack(
                            context, const LoginScreen());
                      },
                      child: Text(
                        TranslationConstants.do_you_have_account.t(context),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 2100),
                    child: Text(
                      "By registering, you agree to our Privacy Policy.",
                      style: TextStyle(
                        color: primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 2100),
                    child: InkWell(
                      onTap: () {
                        // Navigate to privacy policy link
                        launch('https://docs.google.com/document/d/e/2PACX-1vSTUxTjlvlSp5w-pf6ZvVuYw5ieHloRSTt0JHjE73nmxXWHOULngB0CFXe6wXIKieye0O0ZBaxJmfBB/pub');
                      },
                      child: Text(
                        "Privacy Policy",
                        style: TextStyle(
                          color: primary,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

// Checks if the email is valid
  bool isValidEmail(String email) {
    // Regular expression for email validation
    final RegExp regex =
        RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');
    return regex.hasMatch(email);
  }
}
