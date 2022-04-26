import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class SignInPage extends StatefulWidget {
  @override
  _SignInPage createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final username = TextEditingController();
  final password = TextEditingController();
  @override
  late BuildContext context;

  checkCurrentUser() async {
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }

  void signInUser() async {
    try {
      if (username.text != "" && password.text != "") {
        await _auth.signInWithEmailAndPassword(
            email: username.text, password: password.text);
      } else {
        _updateFormAlertText('Email or password is missing');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _updateFormAlertText('No user found for that email');
      } else if (e.code == 'wrong-password') {
        _updateFormAlertText('Incorrect password');
      }
    }
  }

  signUpUser() async {
    Navigator.pushReplacementNamed(context, "/SignUpPage");
  }

  String _formAlertText = '';

  void _updateFormAlertText(String text) {
    setState(() {
      _formAlertText = text;
    });
  }

  @override
  void initState() {
    super.initState();
    checkCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    password.dispose();
  }

  @override
  Widget build(context) {
    setState(() => this.context = context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.amber[400],
        padding: const EdgeInsets.all(25),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 250,
                height: 250,
                alignment: Alignment.center,
                child: Image.asset('assets/images/CubbyLogo.png'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: username,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'E-mail',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
              Text(_formAlertText),
              const SizedBox(height: 30),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    signInUser();
                  },
                  child: const Center(
                    child: Text('Sign-in'),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text("Don't have an account?"),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    signUpUser();
                  },
                  child: const Center(
                    child: Text('Sign Up'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
