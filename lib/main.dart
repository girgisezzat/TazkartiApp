 import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazkarti_app/models/tazkarti_app/google_login_model.dart';
import 'package:tazkarti_app/shared/bloc_observer.dart';
import 'package:tazkarti_app/shared/components/components.dart';
import 'package:tazkarti_app/shared/components/constants.dart';
import 'package:tazkarti_app/shared/network/local/cache_helper.dart';
import 'package:tazkarti_app/shared/network/remote/dio_helper.dart';
import 'package:tazkarti_app/shared/styles/themes.dart';
import 'layout/tazkarti_app/admin/cubit/cubit.dart';
import 'layout/tazkarti_app/user/cubit/cubit.dart';
import 'modules/tazkarti_app/on_boarding/OnBoardingScreen.dart';

 Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async
 {
   print('on background message');
   print(message.data.toString());

   showToast(
     text: 'on background message',
     state: ToastStates.SUCCESS,
   );
 }


void main() async{

  //بيتاكد ان كل حاججة هنا ف الميثود خلصت وبعدين يفتح الابليكاشن
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  var token = await FirebaseMessaging.instance.getToken();
  print(token);

  // foreground fcm
  FirebaseMessaging.onMessage.listen((event)
  {
    print('on message');
    print(event.data.toString());
    showToast(
      text: 'on message',
      state: ToastStates.SUCCESS,
    );
  });

  // when click on notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('on message opened app');
    print(event.data.toString());
    showToast(
      text: 'on message opened app',
      state: ToastStates.SUCCESS,
    );
  });

  // background fcm
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

   uId = CacheHelper.getData(key: 'uId');
   print(uId);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
        providers:
        [
          BlocProvider(
            create: (BuildContext context) => TazkartiAdminCubit()
              ..readTeamsFile()
              ..readStadiumsFile()
              ..getAdminData()
              ..getAdminAllMatchData()
          ),
          BlocProvider(
              create: (BuildContext context) => TazkartiUserCubit()
                ..readTeamsFile()
                ..readStadiumsFile()
                ..getUserData()
                ..getUserMatchData()
                ..getUserReservedTickets()
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.light,
          home: OnBoardingScreen(),
        )
    );
  }
}
