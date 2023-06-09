import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/pages/homepage.dart';
import 'package:project/pages/register.dart';

import 'model/user_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String name = '';
  String password = '';
  bool invisible = true;
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  UserModel userModel = UserModel();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(child: Text("${snapshot.error}")),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              backgroundColor: Colors.blue,
              body: SafeArea(
                  child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: Column(
                  children: [
                    Center(
                      child: Text("Fake Store",
                          style: TextStyle(
                              fontSize: 40.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50.sp),
                              topRight: Radius.circular(50.sp))),
                      child: Form(
                        key: globalFormKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50.h,
                              child: Text("Login",
                                  style: TextStyle(
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ),
                            userTextField(),
                            SizedBox(
                              height: 20.h,
                            ),
                            passwordTextField(),
                            SizedBox(
                              height: 60.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 150.w,
                                  child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue),
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterPage(),
                                          )),
                                      icon: const FaIcon(
                                        FontAwesomeIcons.registered,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        size: 20,
                                      ),
                                      label: Text(
                                        "Registor",
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                                SizedBox(
                                  width: 150.w,
                                  child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green),
                                      onPressed: name == '' || password == ''
                                          ? null
                                          : () async {
                                              if (globalFormKey.currentState!
                                                  .validate()) {
                                                globalFormKey.currentState!
                                                    .save();

                                                try {
                                                  await FirebaseAuth.instance
                                                      .signInWithEmailAndPassword(
                                                          email: userModel
                                                              .username!,
                                                          password: userModel
                                                              .password!)
                                                      .then((value) {
                                                    globalFormKey.currentState!
                                                        .reset();
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const HomePage(),
                                                        ));
                                                  });
                                                } on FirebaseAuthException catch (e) {
                                                  log("error");
                                                }
                                              }
                                            },
                                      icon: const Icon(
                                        Icons.login,
                                        size: 26,
                                      ),
                                      label: Text(
                                        "Login",
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ))
                  ],
                ),
              )),
            );
          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        });
  }

  Widget passwordTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: TextFormField(
        controller: passwordController,
        autofocus: true,
        obscureText: invisible,
        onChanged: (String value) {
          setState(() {
            userModel.password = value;
            password = value;
          });
        },
        onSaved: (newValue) {
          setState(() {
            userModel.password = newValue!;
            password = newValue;
          });
        },
        maxLength: 10,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: 'กรุณาระบุรหัสผ่าน',
          icon: const FaIcon(
            FontAwesomeIcons.lock,
            color: Color.fromARGB(255, 20, 129, 219),
          ),
          counterText: "",
          // ปุ่มเปิด / ปิด ดูรหัสผ่าน
          suffixIcon: IconButton(
            icon: invisible == true
                ? const FaIcon(
                    FontAwesomeIcons.eyeSlash,
                    color: Color.fromARGB(255, 20, 129, 219),
                    size: 20,
                  )
                : const FaIcon(
                    FontAwesomeIcons.eye,
                    color: Color.fromARGB(255, 20, 129, 219),
                    size: 20,
                  ),
            onPressed: () {
              setState(
                () {
                  if (invisible == true) {
                    invisible = false;
                  } else {
                    invisible = true;
                  }
                },
              );
            },
          ),

          /* */
        ),
      ),
    );
  }

  Widget userTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: TextFormField(
        controller: userController,
        autofocus: true,
        obscureText: false,
        onChanged: (String value) {
          setState(() {
            name = value;
            userModel.username = value;
          });
        },
        onSaved: (newValue) {
          setState(() {
            userModel.username = newValue!;
            name = newValue;
          });
        },
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'กรุณาระบุชื่อผู้ใช้',
          icon: FaIcon(
            FontAwesomeIcons.solidUser,
            color: Color.fromARGB(255, 20, 129, 219),
          ),
        ),
      ),
    );
  }
}
