import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInController with ChangeNotifier{

  var googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;

  logIn()async{
    this.googleSignInAccount = await googleSignIn.signIn();
    notifyListeners();
  }

  logOut()async{
    this.googleSignInAccount = await googleSignIn.signOut();
    notifyListeners();
  }
}