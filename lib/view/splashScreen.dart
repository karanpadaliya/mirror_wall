import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(
      Duration(seconds: 5),
      () {
        Navigator.pushReplacementNamed(context, "HomePage");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              "assets/images/splash_background.png",
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Made ",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                const Text(
                  " In India ",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Image.asset("assets/images/Indian_flag.png", height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
