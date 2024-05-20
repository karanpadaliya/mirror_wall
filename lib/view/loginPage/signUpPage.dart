import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
            _supportState = isSupported;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SignUp Page")),
      body: Column(
        children: <Widget>[
          if (_supportState)
            Text("This Device is Supported")
          else
            Text("This Device is Supported"),
          Divider(
            height: 100,
          ),
          ElevatedButton(
            onPressed: _getAvailableBiometrics,
            child: Text("Get available biometrics"),
          ),
          ElevatedButton(onPressed: _authenticate, child: Text("Authenticate")),
        ],
      ),
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Subscribe or you ',
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      print("Authenticated: $authenticated");
    } on PlatformException catch (e) {
      print("e=============>>>>> $e");
    }
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availablebiometrics =
        await auth.getAvailableBiometrics();
    print("List of availablebiometrics: $availablebiometrics");

    if (!mounted) {
      return;
    }
  }
}
