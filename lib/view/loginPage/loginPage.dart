import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controller/LoginProvider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //For Password Visible
  bool isPassword = true;

  void isPasswordVisibility() {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SharedPreferences.getInstance().then((pref) {
      var isLogin = pref.getBool("isLogin");
      if (isLogin ?? false) {
        Navigator.pushReplacementNamed(context, "HomePage");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> fKey = GlobalKey<FormState>();
    TextEditingController MobileController = TextEditingController();
    TextEditingController PinController = TextEditingController();

    bool isInvalidCredentials = false;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Center(
            child: Container(
              height: 400,
              width: 330,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CupertinoColors.link.withOpacity(0.05),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 50,
                    color: CupertinoColors.systemGrey.withOpacity(0.5),
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              child: Form(
                key: fKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "LogIn",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    TextFormField(
                      controller: MobileController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      maxLength: 10,
                      // maxLengthEnforcement: MaxLengthEnforcement.none,
                      decoration: InputDecoration(
                        label: Text("Mobile No"),
                        counterText: '',
                        // use is not visible maxLength in UI
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: CupertinoColors.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isInvalidCredentials
                                  ? Colors.red
                                  : CupertinoColors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: PinController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      maxLength: 4,
                      obscureText: isPassword,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isPassword = !isPassword;
                            });
                          },
                          child: Icon(isPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        label: Text("Pin"),
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: CupertinoColors.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isInvalidCredentials
                                  ? Colors.red
                                  : CupertinoColors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Consumer<LoginProvider>(
                      builder: (BuildContext context, value, Widget? child) {
                        return FilledButton(
                          style: ButtonStyle(
                            elevation: MaterialStatePropertyAll(10),
                            backgroundColor:
                            MaterialStatePropertyAll(CupertinoColors.link),
                          ),
                          onPressed: () async {
                            var isValidate =
                                fKey.currentState?.validate() ?? false;
                            String mobile = MobileController.text;
                            String pin = PinController.text;

                            if (mobile.isEmpty || pin.isEmpty) {
                              // Show error message if any field is empty
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('All fields are required'),
                                ),
                              );
                            } else if (isValidate) {
                              if (value.userMobileNo == mobile &&
                                  value.userPin == pin) {
                                var sharedPreference =
                                await SharedPreferences.getInstance();
                                await sharedPreference.setBool("isLogin", true);
                                Navigator.pushReplacementNamed(context, "HomePage");
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Invalid credentials'),
                                  ),
                                );
                                // print("Invalid credentials");
                              }
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "LogIn",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Icon(Icons.login),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(),
                    Row(
                      children: [
                        Text("Create Account"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "SignUpPage");
                          },
                          child: Text("SignUp"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 1, right: 10),
                          child: Container(
                            height: 30,
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        Text("Need Help"),
                        Icon(Icons.info_outline),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}