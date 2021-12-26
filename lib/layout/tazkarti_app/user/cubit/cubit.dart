import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tazkarti_app/layout/tazkarti_app/user/cubit/state.dart';
import 'package:tazkarti_app/models/tazkarti_app/match_model.dart';
import 'package:tazkarti_app/models/tazkarti_app/reservation_model.dart';
import 'package:tazkarti_app/models/tazkarti_app/tazkarti_user_model.dart';
import 'package:tazkarti_app/modules/tazkarti_app/add_matches/add_matches_screen.dart';
import 'package:tazkarti_app/modules/tazkarti_app/home_user/user_home_screen.dart';
import 'package:tazkarti_app/modules/tazkarti_app/payment/payment_screen.dart';
import 'package:tazkarti_app/modules/tazkarti_app/profile/profile_screen.dart';
import 'package:tazkarti_app/shared/components/basics.dart';
import 'package:tazkarti_app/shared/components/components.dart';
import 'package:tazkarti_app/shared/components/constants.dart';
import 'package:tazkarti_app/shared/styles/icon_broken.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class TazkartiUserCubit extends Cubit<TazkartiUserState>
{

  int counter = 1;

  TazkartiUserCubit() : super(TazkartiInitialUserState());

  //to be more easily when use this cubit in many places
  static TazkartiUserCubit get(context)=>BlocProvider.of(context);


  List<Widget> bottomItems=
  [
    Icon(
      IconBroken.Home,
      size: 20,
    ),
    Icon(
      IconBroken.Profile,
      size: 20,
    ),
  ];

  List<Widget> screens =
  [
    UserHomeScreen(),
    ProfileScreen(),
  ];

  List<String> titles =[
    'All Matches',
    'Profile',
  ];

  int currentIndex = 0;
  void changeBottomNavBar(int index){
    currentIndex = index;
    emit(TazkartiChangeBottomNavUserState());
  }

  Map<String, String> teamsData = {};
  Map<String, String> stadiumsData = {};
  String? firstTeamName;
  String? secondTeamName;

  void readTeamsFile ()async
  {
    List<String> allFiles =  await readTextFile(txtFileName: 'teams.txt');

    print(allFiles.length);
    for(int i =1 ; i<allFiles.length-1;i++) {
      List<String> teamLine = allFiles[i].split('\t');

      teamsData.addAll({teamLine[0]: teamLine[1]});
    }
    print(teamsData['90']);
    print(teamsData.length);
  }

  void readStadiumsFile ()async
  {
    List<String> allFiles =  await readTextFile(txtFileName: 'stadiums.txt');

    print(allFiles.length);
    for(int i =1 ; i<allFiles.length-1;i++) {
      List<String> stadiumLine = allFiles[i].split('\t');

      stadiumsData.addAll({stadiumLine[0]: stadiumLine[1]});
    }
    print(stadiumsData['90']);
    print(stadiumsData.length);
  }

  void selectedTeamChanged()
  {
    emit(TazkartiSelectedTeamChangedUserState());
  }

  /* get User data from fireStore */
  TazkartiUserModel? userModel;

  void getUserData()
  {
    emit(TazkartiGetUserDataLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .snapshots()
        .listen((event) {
          userModel = null;
          userModel = TazkartiUserModel.fromJson(event.data()!);
          emit(TazkartiGetUserDataSuccessState());
    });
  }


  List<MatchModel> matches = [];
  List<ReservationModel> tickets = [];
  List<String> matchesId = [];


  void getUserMatchData()
  {
    FirebaseFirestore.instance
        .collection('matches')
        .orderBy('date',descending: false)
        .where('date',isGreaterThanOrEqualTo: DateTime.now())
        .where('isPublished',isEqualTo: true)
        .snapshots()
        .listen((event) {
          matches = [];
          matchesId = [];

      event.docs.forEach((element) {
          matchesId.add(element.id);
          matches.add(MatchModel.fromJson(element.data()));
      });
      emit(TazkartiGetMatchSuccessUserState());
    });
  }


  void getUserReservedTickets()
  {
    FirebaseFirestore.instance
        .collection('reservation')
        .doc(uId)
        .collection('ticketReserved')
        .snapshots()
        .listen((event) {
          tickets = [];
          event.docs.forEach((element) {

           ReservationModel reserveModel = ReservationModel.fromJson(element.data());

            FirebaseFirestore.instance
                .collection('matches')
                .doc(element.data()['matchId'])
                .get()
                .then((value) {
                  reserveModel.matchModel = MatchModel.fromJson(value.data()!);
                  tickets.add(reserveModel);
                  emit(TazkartiGetUserReserveTicketSuccessState());
            }).catchError((error){
              emit(TazkartiGetUserReserveTicketErrorState(error.toString()));
              print(error.toString());
            });
          });
    });
  }

  void minus()
  {
    counter--;
    emit(CounterMinusState(counter));
  }

  void plus()
  {
    counter++;
    emit(CounterPlusState(counter));
  }


  void userReserveTicket({
    required String matchId,
    required int numOfTickets,
    required double totalPrice,
    required int newNumOfTickets,
  })
  {
    emit(TazkartiUserReserveTicketLoadingState());

    ReservationModel reservationModel = ReservationModel(
      matchId: matchId,
      numOfTickets: numOfTickets,
      totalPrice: totalPrice,
      userID: uId,
    );

    FirebaseFirestore.instance
        .collection('reservation')
        .doc(uId)
        .collection('ticketReserved')
        .doc(matchId)
        .set(reservationModel.toMap())
        .then((value) {
          FirebaseFirestore.instance
              .collection('matches')
              .doc(matchId)
              .update({'nomOfReservedTickets':newNumOfTickets}).then((value){
                showToast(text: 'Ticket Reserved successfully', state: ToastStates.SUCCESS);
                emit(TazkartiUserReserveTicketSuccessState());
          });
        }).catchError((error) {
          emit(TazkartiUserReserveTicketErrorState(error.toString()));
          print(error.toString());
    });

  }


  //---start check if user reserved in this match before
  Future<bool> isReserve({required String matchId})async
  {
    var doc = await FirebaseFirestore.instance
        .collection('reservation')
        .doc(uId)
        .collection('ticketReserved')
        .doc(matchId)
        .get();
    return doc.exists;
  }
  //---end check if user reserved in this match before You sent


  Future<List<Location>> getLatAndLngOfAddress({required String address}) async {
    List<Location> locations = await locationFromAddress(address);

    print('Lat--------------> '+locations[0].latitude.toString());
    print('lng--------------> '+locations[0].longitude.toString());
    return locations;
  }
}