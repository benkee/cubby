import 'package:cubby/services/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/form_validator.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPage createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final username = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  @override
  late BuildContext context;

  checkAuthentication() async {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }

  toSignIn() async {
    Navigator.pushReplacementNamed(context, "/SignInPage");
  }

  void signUp() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: username.text, password: password.text);
      await _auth.currentUser!.updateDisplayName(firstName.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          _formAlertText = 'The password provided is too weak.';
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          _formAlertText = 'The account already exists for that email.';
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    password.dispose();
    firstName.dispose();
  }

  String _formAlertText = '';

  void _updateFormAlertText(String text) {
    setState(() {
      _formAlertText = text;
      if (_formAlertText == 'The field is required') {
        _formAlertText = 'All fields required';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() => this.context = context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.lightGreen,
        padding: const EdgeInsets.all(25),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Welcome to Cubby',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: username,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
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
              const SizedBox(height: 10),
              TextField(
                controller: firstName,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'First Name',
                ),
              ),
              const SizedBox(height: 10),
              Text(_formAlertText),
              const SizedBox(height: 30),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    String? validator = FormValidator.validateSignUp(
                        username.text, password.text, firstName.text);
                    if (validator != null) {
                      _updateFormAlertText(validator);
                    } else {
                      signUp();
                    }
                  },
                  child: const Center(
                    child: Text('Sign Up'),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text("Already have an account?"),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    toSignIn();
                  },
                  child: const Center(
                    child: Text('Sign In'),
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
