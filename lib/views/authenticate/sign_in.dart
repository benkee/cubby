import 'package:cubby/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        elevation: 0.0,
        title: const Text('Sign in to Cubby!'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: ElevatedButton(
          child:  const Text('Sign In Anon'),
          onPressed: () async {
            dynamic result = await _auth.signInAnon();
            if(result != null){
              print('Signed In');
              print(result);
            }else{
              print('Error Signing In');
            }
          },
        ),
      ),
    );
  }
}
