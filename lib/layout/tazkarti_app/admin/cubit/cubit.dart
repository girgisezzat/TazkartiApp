import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:tazkarti_app/layout/tazkarti_app/admin/cubit/state.dart';
import 'package:tazkarti_app/models/tazkarti_app/match_model.dart';
import 'package:tazkarti_app/models/tazkarti_app/tazkarti_user_model.dart';
import 'package:tazkarti_app/modules/tazkarti_app/add_matches/add_matches_screen.dart';
import 'package:tazkarti_app/modules/tazkarti_app/home_admin/admin_home_screen.dart';
import 'package:tazkarti_app/shared/components/basics.dart';
import 'package:tazkarti_app/shared/components/components.dart';
import 'package:tazkarti_app/shared/components/constants.dart';
import 'package:tazkarti_app/shared/styles/icon_broken.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class TazkartiAdminCubit extends Cubit<TazkartiAdminState>
{

  TazkartiAdminCubit() : super(TazkartiInitialAdminState());

  //to be more easily when use this cubit in many places
  static TazkartiAdminCubit get(context)=>BlocProvider.of(context);


  List<Widget> bottomItems=
  [
    Icon(
      IconBroken.Home,
      size: 20,
    ),
    Icon(
      Icons.my_library_add_sharp,
      size: 20,
    ),
  ];

  List<Widget> screens =
  [
    AdminHomeScreen(),
    AddMatchesScreen(),
  ];

  List<String> titles =[
    'All Matches',
    'Add Matches',
  ];

  int currentIndex = 0;
  void changeBottomNavBar(int index){
      currentIndex = index;
      emit(TazkartiChangeBottomNavAdminState());
      emit(TazkartiSearchFalseByTeamAdminState());
  }

  Map<String, String> teamsData = {};
  Map<String, String> stadiumsData = {};
  String? firstTeamName;
  String? secondTeamName;
  String? stadiumName;

  void readTeamsFile ()async
  {
    emit(TazkartiAdminLoadingHomeDataState());

    List<String> allFiles =  await readTextFile(txtFileName: 'teams.txt');

    print(allFiles.length);
    for(int i =1 ; i<allFiles.length-1;i++) {
      List<String> teamLine = allFiles[i].split('\t');

      teamsData.addAll({teamLine[0]: teamLine[1]});
    }
    print(teamsData['90']);
    print(teamsData.length);
  }

  // List<String> allFile = await readTextFile(txtFileName: 'stadiums.txt');
  //
  // for (int i = 0; i < allFile.length - 1; i++) {
  // List<String> stadiumLine = allFile[i].split('\t');
  // stadiumsData.addAll({stadiumLine[0]: stadiumLine[1].substring(0, stadiumLine[1].length-1)});
  // // substring is used because the last char is ' '
  // }
  

  void readStadiumsFile ()async
  {
    List<String> allFiles =  await readTextFile(txtFileName: 'stadiums.txt');

    print(allFiles.length);
    for(int i =0 ; i<allFiles.length-1;i++) {
      List<String> stadiumLine = allFiles[i].split('\t');
      stadiumsData.addAll({stadiumLine[0]: stadiumLine[1].substring(0, stadiumLine[1].length-1)});
      // substring is used because the last char is ' '
    }
    print(stadiumsData['90']);
    print(stadiumsData.length);
  }

  void selectedTeamChanged()
  {
    emit(TazkartiSelectedTeamChangedAdminState());
  }

  void selectedStadiumChanged()
  {
    emit(TazkartiSelectedStadiumChangedAdminState());
  }

  bool isSearch = false;
  void searchByTeam()
  {
    isSearch = !isSearch;
    if(isSearch == false)
      emit(TazkartiSearchFalseByTeamAdminState());
    else
      emit(TazkartiSearchTrueByTeamAdminState());
  }

  /* get admin data from fireStore */
  TazkartiUserModel? adminModel;

  void getAdminData()
  {
    emit(TazkartiGetAdminDataLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .snapshots()
        .listen((event) {
          adminModel = null;
          adminModel = TazkartiUserModel.fromJson(event.data()!);
          emit(TazkartiGetAdminDataSuccessState());
    });
  }


  void addMatch({
    required String firstTeamName,
    required String secondTeamName,
    required String stadiumName,
    required String matchDate,
    required String matchTime,
    required String logoFirstTeam,
    required String logoSecondTeam,
    required String stadiumLogo,
    required String ticketNumbers,
    required String ticketPrice,
  })
  {
    emit(TazkartiAdminAddMatchLoadingState());

    String matchId = FirebaseFirestore.instance.collection('match').doc().id;

    DateTime date =  DateFormat('MMM dd, yyyy HH:mm a').parse('$matchDate $matchTime');

    MatchModel model = MatchModel(

      date: date,
      matchId: matchId,
      firstTeamName: firstTeamName,
      secondTeamName: secondTeamName,
      stadiumName: stadiumName,
      uId: adminModel!.uId,
      matchDate: matchDate,
      matchTime: matchTime,
      logoFirstTeam: logoFirstTeam,
      logoSecondTeam: logoSecondTeam,
      stadiumLogo: stadiumLogo,
      ticketNumbers: ticketNumbers,
      ticketPrice: ticketPrice,
      isPublished: false,
      nomOfReservedTickets: 0,
    );

    FirebaseFirestore.instance
        .collection('matches')
        .doc(matchId)
        .set(model.toMap())
        .then((value) {
          showToast(text: 'Match added successfully', state: ToastStates.SUCCESS);
          emit(TazkartiAdminAddMatchSuccessState());
          emit(TazkartiSearchFalseByTeamAdminState());
    }).catchError((error)
    {
      emit(TazkartiAdminAddMatchErrorState(error.toString()));
      print(error.toString());
    });

  }

  List<MatchModel> matches = [];
  List<MatchModel> matchSearch = [];
  List<String> matchesId = [];

  void getAdminAllMatchData()
  {

    FirebaseFirestore.instance
        .collection('matches')
        .orderBy('date',descending: false)
        .where('date',isGreaterThanOrEqualTo: DateTime.now())
        .snapshots()
        .listen((event) {
          matches = [];
          matchesId = [];

      event.docs.forEach((element) {

          matchesId.add(element.id);
          matches.add(MatchModel.fromJson(element.data()));

      });
      emit(TazkartiGetMatchSuccessAdminState());
      emit(TazkartiSearchFalseByTeamAdminState());
    });
  }


  void getAdminAllMatchesData()
  {

    FirebaseFirestore.instance
        .collection('matches')
        .orderBy('date',descending: false)
        .snapshots()
        .listen((event) {
          matchSearch = [];

      event.docs.forEach((element) {

        matchSearch.add(MatchModel.fromJson(element.data()));

      });
      emit(TazkartiGetMatchSuccessAdminState());
      emit(TazkartiSearchTrueByTeamAdminState());
    });
  }


  void getAdminPastMatchData()
  {
    matchSearch = [];

    FirebaseFirestore.instance
        .collection('matches')
        .orderBy('date',descending: false)
        .where('date',isLessThan: DateTime.now())
        .snapshots()
        .listen((event) {
          matchSearch = [];

      event.docs.forEach((element) {

        matchSearch.add(MatchModel.fromJson(element.data()));

      });
      emit(TazkartiGetMatchSuccessAdminState());
      emit(TazkartiSearchTrueByTeamAdminState());
    });

  }


  void getAdminFutureMatchData()
  {
    matchSearch = [];

    DateTime date1 =DateTime.now();
    date1 = DateFormat('yyyy-MM-dd').parse(date1.toString());

    for(int i=0; i<matches.length; i++){

      DateTime date2 = DateFormat('MMM dd, yyyy').parse(matches[i].matchDate!);
      date2 = DateFormat('yyyy-MM-dd').parse(DateFormat('yyyy-MM-dd').format(date2));

      if(date2.isAfter(date1)){
        matchSearch.add(matches[i]);
      }
    }

    emit(TazkartiGetMatchSuccessAdminState());
    emit(TazkartiSearchTrueByTeamAdminState());

  }


  void getAdminPublishedMatchData()
  {
    matchSearch = [];

    for(int i=0; i< matches.length; i++){

      if(matches[i].isPublished == true) {
        matchSearch.add(matches[i]);
      }

    }

    emit(TazkartiGetMatchSuccessAdminState());
    emit(TazkartiSearchTrueByTeamAdminState());
  }


  void getAdminNotPublishedMatchData()
  {
    matchSearch = [];

    for(int i=0; i< matches.length; i++){

      if(matches[i].isPublished == false) {
        matchSearch.add(matches[i]);
      }

    }

    emit(TazkartiGetMatchSuccessAdminState());
    emit(TazkartiSearchTrueByTeamAdminState());

  }


  void getAdminTodayMatchData()
  {
    matchSearch = [];

    DateTime date1 =DateTime.now();
    date1 = DateFormat('yyyy-MM-dd').parse(date1.toString());

    for(int i=0; i<matches.length; i++){
      DateTime date2 = DateFormat('MMM dd, yyyy').parse(matches[i].matchDate!);
      date2 = DateFormat('yyyy-MM-dd').parse(DateFormat('yyyy-MM-dd').format(date2));

      if(date2 == date1){
        matchSearch.add(matches[i]);
      }
    }

    emit(TazkartiGetMatchSuccessAdminState());
    emit(TazkartiSearchTrueByTeamAdminState());
  }


  List<MatchModel> specificMatch = [];
  late String specificMatchId = '';

  var getMatchById = FirebaseFirestore.instance.collection('matches');

  void getSpecificMatchData({
    required String matchId,
   })
   {
     getMatchById.get().then((QuerySnapshot querySnapshot){
       querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
         specificMatchId = documentSnapshot.id;
       });
     });

     getMatchById.snapshots().listen((event) {
       specificMatch = [];

          event.docs.forEach((element) {

            specificMatch.add(MatchModel.fromJson(element.data()));
          });
          emit(TazkartiGetSpecificMatchSuccessAdminState());
        });
  }



  void updateMatch({
    required String firstTeamName,
    required String secondTeamName,
    required String stadiumName,
    required String matchDate,
    required String matchTime,
    required String logoFirstTeam,
    required String logoSecondTeam,
    required String stadiumLogo,
    required String ticketNumbers,
    required String ticketPrice,
    required String matchId,
  })
  {
    emit(TazkartiAdminUpdateMatchLoadingState());

    DateTime date =  DateFormat('MMM dd, yyyy HH:mm a').parse('$matchDate $matchTime');

    MatchModel model = MatchModel(

      matchId: matchId,
      date: date,
      firstTeamName: firstTeamName,
      secondTeamName: secondTeamName,
      stadiumName: stadiumName,
      uId: adminModel!.uId,
      matchDate: matchDate,
      matchTime: matchTime,
      logoFirstTeam: logoFirstTeam,
      logoSecondTeam: logoSecondTeam,
      stadiumLogo: stadiumLogo,
      ticketNumbers: ticketNumbers,
      ticketPrice: ticketPrice,
      isPublished: false,
      nomOfReservedTickets: 0,

    );

    FirebaseFirestore.instance
        .collection('matches')
        .doc(matchId)
        .update(model.toMap())
        .then((value) {
          showToast(text: 'Match updated successfully', state: ToastStates.SUCCESS);
          emit(TazkartiAdminUpdateMatchSuccessState());
          emit(TazkartiSearchFalseByTeamAdminState());
    }).catchError((error)
    {
      emit(TazkartiAdminUpdateMatchErrorState(error.toString()));
      print(error.toString());
    });
  }


  void deleteMatch(String matchId)
  {
    FirebaseFirestore.instance
        .collection('matches')
        .doc(matchId)
        .delete()
        .then((value) {
          showToast(text: 'Match deleted successfully', state: ToastStates.SUCCESS);
          emit(TazkartiAdminDeleteMatchSuccessState());
          emit(TazkartiSearchFalseByTeamAdminState());
    }).catchError((error){
      emit(TazkartiAdminDeleteMatchErrorState(error.toString()));
      print(error.toString());
      print('error in deleting post');
    });

  }


  void searchMatch(String text)
  {
    matchSearch = [];

    emit(TazkartiAdminSearchMatchLoadingState());

    for(int i=0; i< matches.length; i++){

      if(matches[i].firstTeamName!.toLowerCase().contains(text.toLowerCase().toString())
          || matches[i].secondTeamName!.toLowerCase().contains(text.toLowerCase().toString()))
      {
        matchSearch.add(matches[i]);
      }
    }

    emit(TazkartiAdminSearchMatchSuccessState());
    emit(TazkartiSearchTrueByTeamAdminState());
  }


  Future<void> sendEmailInformingUsersWithTickets({
    required String emailSubject,
    required String emailBody,
  })
  async {
    List<String> recipients=[];
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value)   async {
          for(var element in value.docs){
            recipients.add(element.data()['email']);
          }
          print('--------==========>'+ recipients.toString());
          final Email email = Email(
            subject: emailSubject,
            body: emailBody,
            recipients: recipients,
            isHTML: false,
          );
          await FlutterEmailSender.send(email);
          emit(TazkartiSearchFalseByTeamAdminState());
    });
  }


  void releaseMatchTickets({
    required String matchId,
  })
  {
    emit(TazkartiAdminReleaseMatchTicketsLoadingState());

    FirebaseFirestore.instance
        .collection('matches')
        .doc(matchId)
        .update({'isPublished':true})
        .then((value) {
          emit(TazkartiAdminReleaseMatchTicketsSuccessState());
          emit(TazkartiSearchFalseByTeamAdminState());
    }).catchError((error){
      emit(TazkartiAdminReleaseMatchTicketsErrorState(error.toString()));
      print(error.toString());
    });
  }

}