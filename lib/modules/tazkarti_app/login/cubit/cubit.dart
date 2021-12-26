import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tazkarti_app/models/tazkarti_app/tazkarti_user_model.dart';
import 'package:tazkarti_app/modules/tazkarti_app/login/cubit/states.dart';
import 'package:tazkarti_app/shared/components/components.dart';


class TazkartiLoginCubit extends Cubit<TazkartiLoginState>
{

  TazkartiLoginCubit() : super(TazkartiLoginInitialState());

  //to be more easily when use this cubit in many places
  static TazkartiLoginCubit get(context)=>BlocProvider.of(context);


  void userLogin({
    required String email,
    required String password,
  })
  {
    emit(TazkartiLoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      emit(TazkartiLoginSuccessState(value.user!.uid, "emailPassword",),
      );
    }).catchError((error)
    {
      emit(TazkartiLoginErrorState(error.toString()));
      print(error.toString());
    });
  }


  Future<User?> signInWithGoogle({
    required context
  }) async
  {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          showToast(
            text: 'account-exists-with-different-credential',
            state: ToastStates.ERROR,
          );
          // handle the error here
        }
        else if (e.code == 'invalid-credential') {
          showToast(
            text: 'invalid-credential',
            state: ToastStates.ERROR,
          );
        }
      } catch (e) {
        // handle the error here
      }
    }
    return user;
  }


  void logInWithGoogle({
    required context
  })
  {
    emit(TazkartiLoginWithGoogleLoadingState());

    signInWithGoogle(context: context).then((value){

      if(value!=null) {
        String uId = value.uid.toString();
        String userEmail = value.email.toString();

        if (FirebaseAuth.instance.currentUser!.metadata.creationTime == FirebaseAuth.instance.currentUser!.metadata.lastSignInTime) {
          String userName = value.displayName.toString();
          String phone = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
          print('phone------------------> ' + phone);
          TazkartiUserModel model = TazkartiUserModel(
            uId: uId,
            name: userName,
            email: userEmail,
            phone: phone,
            isEmailVerified: false,
          );
          FirebaseFirestore.instance
              .collection('users')
              .doc(uId)
              .set(model.toMap());
        }
        emit(TazkartiLoginWithGoogleSuccessState());
        emit(TazkartiLoginSuccessState(value.uid, "google",));
      }
    }).catchError((error){
      showToast(text: onError.toString(), state: ToastStates.ERROR);
      emit(TazkartiLoginWithGoogleErrorState(error.toString()));
      print(error.toString());
    });
  }



  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;

    emit(TazkartiChangePasswordVisibilityState());
  }

}