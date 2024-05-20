import 'package:flutter/material.dart';
import 'package:mirror_wall/view/splashScreen.dart';
import 'package:provider/provider.dart';

import 'Controller/HomePageProvider.dart';
import 'Controller/LoginProvider.dart';
import 'view/HomePage.dart';
import 'view/loginPage/loginPage.dart';
import 'view/loginPage/signUpPage.dart';

void main() {
  runApp(MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomePageProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/": (context) => SplashScreen(),
          "HomePage": (context) => HomePage(),
          "LoginPage": (context) => LoginPage(),
          "SignUpPage": (context) => SignUpPage(),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: Text(
                  "onUnknownRoute",
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
