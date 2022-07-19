import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_fingerprint/home_page.dart';

class AuthPath extends StatefulWidget {
  const AuthPath({Key? key}) : super(key: key);

  @override
  _AuthPathState createState() => _AuthPathState();
}

class _AuthPathState extends State<AuthPath> {
  LocalAuthentication authentication = LocalAuthentication();
  bool biometrics_supported = false;
  bool? _canCheckBiometrics;

  List<BiometricType>? _availableBiometrics;

Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await authentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _checkBio() async {
    authentication.isDeviceSupported().then(
          (bool isSupported) =>
              setState(() => biometrics_supported = isSupported),
        );
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await authentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _getAuth() async {
    bool isAuth = false;
    try {
      isAuth = await authentication.authenticate(
        localizedReason: 'Scan your face to access the app',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (isAuth) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (builder) => HomePage()));
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkBio();
    _checkBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    String bioType = "";
    print("Supported: " + biometrics_supported.toString());
    print("Can check: " + _canCheckBiometrics.toString());
    if (_availableBiometrics != null) {
      try {
        bioType = _availableBiometrics![0].name;
      } catch (e) {
        print(e);
      }
    }
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Scan your $bioType',
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              height: 70,
              width: MediaQuery.of(context).size.width,
              child: !biometrics_supported
                  ? const SizedBox.shrink()
                  : ElevatedButton(
                      child: Text('$bioType recognition'),
                      onPressed: () {
                        _getAuth();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          primary: Colors.green))),
        ],
      ),
    );
  }
}
