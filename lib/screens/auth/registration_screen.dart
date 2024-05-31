import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../../services/auth_service.dart';
import '../../ui/background.dart';
import '../../utils/constants/color.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController userNameController = TextEditingController();

    return Scaffold(
      body: Mybackground(
        screens: <Widget>[
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                FadeInUp(
                    duration: const Duration(milliseconds: 1200),
                    child: Center(
                      child: SizedBox(
                          width: 150,
                          child: Image.asset('assets/icon/flask.png')),
                    )),
                SizedBox(
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
                          child: TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "البريد الإلكتروني",
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
                          child: TextField(
                            controller: userNameController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "الاسم المستخدم",
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(),
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "كلمة المرور",
                              hintStyle: TextStyle(color: Colors.white),
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
                      final String email = emailController.text;
                      final String password = passwordController.text;
                      final String userName = userNameController.text;
                      setState(() {
                        loading = true;
                      });

                      var auth = AuthService().registerWithEmailAndPassword(
                          email, password, userName);

                      await auth == null ? null : Navigator.pop(context);

                      setState(() {
                        loading = false;
                      });
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
                            : const Text(
                                "انشاء حساب",
                                style: TextStyle(
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
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => const LoginScreen(),
                          //     )).then((_) {
                          //   Navigator.pop(context);
                          // });
                        },
                        child: const Text(
                          'لديك حساب؟',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
