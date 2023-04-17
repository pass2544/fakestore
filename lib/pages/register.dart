import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'model/user_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  String name = '';
  String password = '';
  String password2 = '';
  bool invisible = true;
  bool invisible2 = true;
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.keyboard_arrow_left,
                                  size: 40.sp, color: Colors.white)),
                          Text("Fake Store",
                              style: TextStyle(
                                  fontSize: 40.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          SizedBox(
                            width: 35.w,
                          )
                        ],
                      ),
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
                              child: Text("Registor",
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
                              height: 20.h,
                            ),
                            passwordTextFieldAgain(),
                            SizedBox(
                              height: 60.h,
                            ),
                            SizedBox(
                              width: 150.w,
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                  onPressed: name == '' ||
                                          password == '' ||
                                          password2 == ''
                                      ? null
                                      : () {
                                          if (globalFormKey.currentState!
                                              .validate()) {
                                            globalFormKey.currentState!.save();
                                            if (userModel.password ==
                                                userModel.password2) {
                                              try {
                                                FirebaseAuth.instance
                                                    .createUserWithEmailAndPassword(
                                                        email:
                                                            userModel.username!,
                                                        password: userModel
                                                            .password!);
                                                globalFormKey.currentState!
                                                    .reset();
                                              } on FirebaseAuthException catch (e) {
                                                log("${e.message}");
                                              }
                                            }
                                          }
                                        },
                                  icon: const Icon(
                                    Icons.login,
                                    size: 26,
                                  ),
                                  label: Text(
                                    "Register",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold),
                                  )),
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

  Widget passwordTextFieldAgain() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: TextFormField(
        controller: password2Controller,
        autofocus: true,
        obscureText: invisible2,
        onChanged: (String value) {
          setState(() {
            userModel.password2 = value;
            password2 = value;
          });
        },
        onSaved: (newValue) {
          setState(() {
            userModel.password2 = newValue!;
            password2 = newValue;
          });
        },
        maxLength: 10,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: 'กรุณาระบุรหัสผ่านอีกรอบ',
          icon: const FaIcon(
            FontAwesomeIcons.lock,
            color: Color.fromARGB(255, 20, 129, 219),
          ),
          counterText: "",
          // ปุ่มเปิด / ปิด ดูรหัสผ่าน
          suffixIcon: IconButton(
            icon: invisible2 == true
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
                  if (invisible2 == true) {
                    invisible2 = false;
                  } else {
                    invisible2 = true;
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
