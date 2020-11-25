import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isAvailable = false;
  bool isAuthenticated = false;
  String text = "Please Check Biometric Avaibility";
  LocalAuthentication localAuthentication = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 200,
                margin: EdgeInsets.only(bottom: 6),
                child: RaisedButton(
                    child: Text("Check Biometric"),
                    onPressed: () async {
                      isAvailable =
                          await localAuthentication.canCheckBiometrics;
                      if (isAvailable) {
                        List<BiometricType> types =
                            await localAuthentication.getAvailableBiometrics();
                        text = "Biometric Available";
                        for (var item in types) {
                          text += "\n- $item";
                        }
                        setState(() {});
                      }
                    }),
              ),
              SizedBox(
                width: 200,
                child: RaisedButton(
                    child: Text("Authenticate"),
                    onPressed: () async {
                      isAuthenticated =
                          await localAuthentication.authenticateWithBiometrics(
                              localizedReason: "Please Authenticate",
                              stickyAuth: true,
                              useErrorDialogs: true);
                      setState(() {});
                    }),
              ),
              Container(
                margin: EdgeInsets.all(20),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isAuthenticated ? Colors.green : Colors.red,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 3, spreadRadius: 2)
                    ]),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2,
                color: Colors.green[200],
                child: Center(
                    child: Text(
                  text,
                  style: TextStyle(fontSize: 15),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
