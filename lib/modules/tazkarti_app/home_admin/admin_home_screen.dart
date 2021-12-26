import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stylish_dialog/stylish_dialog.dart';
import 'package:tazkarti_app/layout/tazkarti_app/admin/cubit/cubit.dart';
import 'package:tazkarti_app/layout/tazkarti_app/admin/cubit/state.dart';
import 'package:tazkarti_app/models/tazkarti_app/match_model.dart';
import 'package:tazkarti_app/modules/tazkarti_app/edit_matches/edit_matches_screen.dart';
import 'package:tazkarti_app/shared/components/components.dart';

class AdminHomeScreen extends StatelessWidget {

  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TazkartiAdminCubit,TazkartiAdminState>(
      listener: (context,state){},
      builder: (context,state){
        return Conditional.single(
          context: context,
          conditionBuilder:(context)=> TazkartiAdminCubit.get(context).matches.length > 0
              && TazkartiAdminCubit.get(context).adminModel !=null,
          widgetBuilder: (context)=> SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
                children:
                [
                  if(state is TazkartiSearchFalseByTeamAdminState)
                    Column(
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
                            buildMatchItem(TazkartiAdminCubit.get(context).matches[index],context,index),
                        separatorBuilder:(context, index) => SizedBox(height: 8.0,),
                        itemCount: TazkartiAdminCubit.get(context).matches.length,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                  if(state is TazkartiSearchTrueByTeamAdminState)
                    Column(
                      children:
                      [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:
                            [
                              Expanded(
                                child: defaultTextFormField(
                                  fieldController: searchController,
                                  inputType: TextInputType.text,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'please enter Team Name ';
                                    }
                                  },
                                  onChange: (String text){
                                    TazkartiAdminCubit.get(context).searchMatch(text);
                                  },
                                  labelText: 'Enter a team',
                                  prefixIcon: Icons.search,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.green[600],
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                  ),
                                ),
                                height: 60.0,
                                child: PopupMenuButton(
                                  icon: Icon(Icons.menu),
                                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                    const PopupMenuItem(
                                      value: 'Published',
                                      child: ListTile(
                                        title: Text('Published Matches'),
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'Not Published',
                                      child: ListTile(
                                        title: Text('Not Published Matches'),
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'Future',
                                      child: ListTile(
                                        title: Text('Future Matches'),
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'Past',
                                      child: ListTile(
                                        title: Text('Past Matches'),
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'Today',
                                      child: ListTile(
                                        title: Text('Today Matches'),
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'All',
                                      child: ListTile(
                                        title: Text('All Matches'),
                                      ),
                                    ),
                                  ],
                                  onSelected: (choice){
                                    switch(choice){
                                      case 'All':
                                        TazkartiAdminCubit.get(context).getAdminAllMatchesData();
                                        break;
                                      case 'Today':
                                        TazkartiAdminCubit.get(context).getAdminTodayMatchData();
                                        break;
                                      case 'Future':
                                        TazkartiAdminCubit.get(context).getAdminFutureMatchData();
                                        break;
                                      case 'Past':
                                        TazkartiAdminCubit.get(context).getAdminPastMatchData();
                                        break;
                                      case 'Published':
                                        TazkartiAdminCubit.get(context).getAdminPublishedMatchData();
                                        break;
                                      case 'Not Published':
                                        TazkartiAdminCubit.get(context).getAdminNotPublishedMatchData();
                                        break;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        if(state is TazkartiAdminSearchMatchLoadingState)
                          LinearProgressIndicator(),
                        SizedBox(
                          height: 10.0,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) =>
                              buildMatchItem(TazkartiAdminCubit.get(context).matchSearch[index],context,index),
                          separatorBuilder:(context, index) => SizedBox(height: 8.0,),
                          itemCount: TazkartiAdminCubit.get(context).matchSearch.length,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                      ],
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
    child: Slidable(
      key: UniqueKey(),
      startActionPane: ActionPane(
        motion: ScrollMotion(),
        extentRatio: 0.6,
        children: [
          SlidableAction(
            onPressed: (context){
              AwesomeDialog(
                context: context,
                dialogType: DialogType.WARNING,
                animType: AnimType.BOTTOMSLIDE,
                title: 'Delete Match',
                desc: 'Are you sure that you want to delete (${model.firstTeamName} & ${model.secondTeamName}) match',
                btnCancelOnPress: () {

                  TazkartiAdminCubit.get(context).getAdminAllMatchData();

                },
                btnOkOnPress: () {

                  TazkartiAdminCubit.get(context).deleteMatch(
                    TazkartiAdminCubit.get(context).matchesId[index],
                  );

                },
              ).show();
            },
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            autoClose: false,
          ),
          SlidableAction(
            onPressed: (context){
              if(model.isPublished == false)
                AwesomeDialog(
                context: context,
                dialogType: DialogType.INFO_REVERSED,
                animType: AnimType.BOTTOMSLIDE,
                title: 'Publishing Ticket',
                desc: 'Are you sure that you want to Publish (${model.firstTeamName} & ${model.secondTeamName}) match',
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  TazkartiAdminCubit.get(context).releaseMatchTickets(
                    matchId: model.matchId!,
                  );
                  TazkartiAdminCubit.get(context).sendEmailInformingUsersWithTickets(
                    emailBody: 'hurry up to get a ticket before stocks run out ',
                    emailSubject: 'Tickets for(${model.firstTeamName} & ${model.secondTeamName}) are available now',
                  );
                },
              ).show();
              else
                StylishDialog(
                  context: context,
                  alertType: StylishDialogType.INFO,
                  titleText: 'Publishing Ticket',
                  contentText: 'you Published tickets for this match before',
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
            },
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            icon: Icons.publish_outlined,
            label: 'Publish',
            autoClose: false,
          ),
        ],
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
                          onPressed: (){
                            if(model.isPublished == false)
                              navigateTo(
                                context,
                                EditMatchesScreen(model),
                              );
                            else
                              StylishDialog(
                                context: context,
                                alertType: StylishDialogType.INFO,
                                titleText: 'Publishing Ticket',
                                contentText: 'you Published tickets for this match before so you can not edit !',
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
                            },
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
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
            ),
          ],
        ),
      ),
    ),
  );
}
