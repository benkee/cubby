import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInAnon() async {
    try{
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e){
      print(e.toString());
      return null;
    }
  }

  // Future signIn() async {
  //   try{
  //     AuthResult authResult =  _auth.signInWithEmailAndPassword(
  //         email: '',
  //         password: ''
  //     );
  //     FirebaseUser firebaseUser = authResult.user;
  //     return firebaseUser;
  //   } catch (e){
  //     print(e.toString());
  //     return null;
  //   }
  // }

}