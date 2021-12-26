import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:tazkarti_app/modules/tazkarti_app/add_matches/add_matches_screen.dart';
import 'package:tazkarti_app/modules/tazkarti_app/login/cubit/cubit.dart';
import 'package:tazkarti_app/modules/tazkarti_app/login/login_screen.dart';
import 'package:tazkarti_app/shared/components/basics.dart';
import 'package:tazkarti_app/shared/components/components.dart';
import 'package:tazkarti_app/shared/components/constants.dart';
import 'package:tazkarti_app/shared/network/local/cache_helper.dart';
import 'package:tazkarti_app/shared/styles/icon_broken.dart';

import 'cubit/cubit.dart';
import 'cubit/state.dart';

class TazkartiUserLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<TazkartiUserCubit, TazkartiUserState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TazkartiUserCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green[600],
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
            actions:
            [
              IconButton(
                icon: Icon(
                  IconBroken.Notification,
                ),
                onPressed: (){},
              ),
              IconButton(
                icon: Icon(
                  Icons.logout,
                ),
                onPressed: (){

                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.WARNING,
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'Logout',
                    desc: 'Are you sure that you want to Logout',
                    btnCancelOnPress: () {
                    },
                    btnOkOnPress: () {
                      String authType = CacheHelper.getData(key: 'authType');
                      logOut(authType: authType, context: context).then((value) {
                        CacheHelper.removeData(key: 'uId');
                        CacheHelper.removeData(key: 'authType');
                        navigateAndFinish(context, TazkartiLoginScreen());
                      });

                    },
                  ).show();

                },
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: CurvedNavigationBar(
            height: 60,
            backgroundColor: Colors.green.shade600,
            index: cubit.currentIndex,
            onTap: (index)
            {
              cubit.changeBottomNavBar(index);
            },
            items: cubit.bottomItems,
          ),
        );
      },
    );
  }
}
