import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazkarti_app/models/tazkarti_app/tazkarti_user_model.dart';
import 'package:tazkarti_app/modules/tazkarti_app/register/cubit/states.dart';



class TazkartiRegisterCubit extends Cubit<TazkartiRegisterState> {

  TazkartiRegisterCubit() : super(TazkartiRegisterInitialState());

  //to be more easily when use this cubit in many places
  static TazkartiRegisterCubit get(context) => BlocProvider.of(context);


  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  })
  {
    print('hello');
    emit(TazkartiRegisterLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      userCreate(
        uId: value.user!.uid,
        phone: phone,
        email: email,
        name: name,
      );
      print(value.user!.email);
      print(value.user!.uid);
    }).catchError((error) {
      print(error.toString());
      emit(TazkartiRegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String phone,
    required String uId,
  }) {
    TazkartiUserModel model = TazkartiUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap()).then((value) {
      emit(TazkartiCreateUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(TazkartiCreateUserErrorState(error.toString()));
    });
  }


  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;

    emit(TazkartiRegisterChangePasswordVisibilityState());
  }
}