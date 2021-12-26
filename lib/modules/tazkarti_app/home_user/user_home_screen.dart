import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:stylish_dialog/stylish_dialog.dart';
import 'package:tazkarti_app/layout/tazkarti_app/user/cubit/cubit.dart';
import 'package:tazkarti_app/layout/tazkarti_app/user/cubit/state.dart';
import 'package:tazkarti_app/models/tazkarti_app/match_model.dart';
import 'package:tazkarti_app/modules/tazkarti_app/reserve_ticket/reserve_ticket_screen.dart';
import 'package:tazkarti_app/shared/components/components.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TazkartiUserCubit,TazkartiUserState>(
      listener: (context,state){},
      builder: (context,state){
        return Conditional.single(
          context: context,
          conditionBuilder:(context)=> TazkartiUserCubit.get(context).matches.length > 0,
             // && TazkartiUserCubit.get(context).userModel !=null,
          widgetBuilder: (context)=> SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
                children:
                [
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 5.0,
                    margin: EdgeInsets.all(
                      8.0,
                    ),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Image(
                          image: AssetImage(
                            'assets/images/home1.png',
                          ),
                          //fit: BoxFit.cover,
                          height: 200.0,
                          width: double.infinity,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Book your ticket now',
                            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Colors.green.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        buildMatchItem(TazkartiUserCubit.get(context).matches[index],context,index),
                    separatorBuilder:(context, index) => SizedBox(height: 8.0,),
                    itemCount: TazkartiUserCubit.get(context).matches.length,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                ]
            ),
          ),
          fallbackBuilder: (context)=> Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildMatchItem(MatchModel model,context,index) => Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5.0,
    margin: EdgeInsets.symmetric(
      horizontal: 8.0,
    ),
    child: Padding(
      padding: const EdgeInsets.all(
          10.0
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
        [
          Center(
            child: Text(
              '${model.matchDate}',
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: 20.0,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Padding(
            padding:const EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Expanded(
                  child: Text(
                    '${model.firstTeamName}',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                Expanded(
                  child: Image(
                    image: NetworkImage(
                      '${model.logoFirstTeam}',
                    ),
                  ),
                ),

                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${model.matchTime}',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontSize: 13.0,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          bool isUserReserveBefore = await TazkartiUserCubit.get(context).isReserve(matchId: model.matchId!);
                          if(isUserReserveBefore){
                            StylishDialog(
                              context: context,
                              alertType: StylishDialogType.INFO,
                              titleText: 'Reserve Tickets',
                              contentText: 'you reserved tickets for this match before',
                              confirmButton: MaterialButton(
                                child: Text(
                                  'OK',
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: Colors.green,
                              ),
                            ).show();
                          }
                          else
                            navigateTo(
                              context,
                              ReserveTicketScreen(model),
                            );
                          },
                        child: Text(
                          'Reserve',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 8.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Image(
                    image: NetworkImage(
                      '${model.logoSecondTeam}',
                    ),
                  ),
                ),

                Expanded(
                  child: Text(
                    '${model.secondTeamName}',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
