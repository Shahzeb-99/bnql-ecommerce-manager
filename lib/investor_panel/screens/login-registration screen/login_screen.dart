import 'package:ecommerce_bnql/investor_panel/pageview_screen.dart';
import 'package:ecommerce_bnql/investor_panel/screens/login-registration%20screen/registration_screen.dart';
import 'package:ecommerce_bnql/investor_panel/view_model/viewmodel_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_bnql/investor_panel/screens/login-registration screen/decorations.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final auth = FirebaseAuth.instance;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/dart.png',
              scale: 3,
            ),
            TextField(
              autofocus: true,
              decoration: kDecoration.inputBox('Email'),
              controller: email,
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              decoration: kDecoration.inputBox('Password'),
              obscureText: true,
              controller: password,
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    auth
                        .signInWithEmailAndPassword(
                            email: email.text, password: password.text)
                        .then((value) async {
                      Provider.of<UserViewModel>(context,listen: false)
                          .checkPermissions()
                          .whenComplete(() => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainScreen())));
                    });
                  } on Exception catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
                child: const Text('Login')),
            Row(
              children: [
                const Text('Don\'t have an account?'),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationScreen()));
                  },
                  child: const Text(
                    '  Sign up',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
