import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tazkarti_app/layout/tazkarti_app/user/cubit/cubit.dart';
import 'package:tazkarti_app/layout/tazkarti_app/user/cubit/state.dart';
import 'package:tazkarti_app/models/tazkarti_app/match_model.dart';
import 'package:tazkarti_app/models/tazkarti_app/reservation_model.dart';
import 'package:tazkarti_app/modules/tazkarti_app/maps/maps_screen.dart';
import 'package:tazkarti_app/shared/components/components.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TazkartiUserCubit,TazkartiUserState>(
      listener: (context,state){},
      builder: (context,state){
        return Conditional.single(
          context: context,
          conditionBuilder:(context)=> TazkartiUserCubit.get(context).tickets.length > 0,
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
                    child: Image(
                      image: AssetImage(
                        'assets/images/fans.png',
                      ),
                      //fit: BoxFit.cover,
                      height: 250.0,
                      width: double.infinity,
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        buildMatchItem(TazkartiUserCubit.get(context).tickets[index],context,index),
                    separatorBuilder:(context, index) => SizedBox(height: 8.0,),
                    itemCount: TazkartiUserCubit.get(context).tickets.length,
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


  Widget buildMatchItem(ReservationModel reservationModel,context,index) => Card(
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
              '${reservationModel.matchModel!.matchDate!}',
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
                    '${reservationModel.matchModel!.firstTeamName}',
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
                      '${reservationModel.matchModel!.logoFirstTeam}',
                    ),
                  ),
                ),

                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${reservationModel.matchModel!.matchTime}',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Image(
                    image: NetworkImage(
                      '${reservationModel.matchModel!.logoSecondTeam}',
                    ),
                  ),
                ),

                Expanded(
                  child: Text(
                    '${reservationModel.matchModel!.secondTeamName}',
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
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5.0,
            margin: EdgeInsets.all(
              8.0,
            ),
            child: Column(
              children:
              [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children:
                      [
                        Icon(
                          Icons.money,
                          //color: Colors.white,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'total ticket price :',
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          reservationModel.totalPrice!.toString()+''+'\$',
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontSize: 20.0,
                            color: Colors.green[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children:
                  [
                    SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[300],
                        height: 1.0,
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),

                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Row(
                    children:
                    [
                      Icon(
                        Icons.confirmation_number,
                        //color: Colors.white,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Numbers Of Reserved Tickets:',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text(
                          reservationModel.numOfTickets!.toString(),
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontSize: 20.0,
                          color: Colors.green[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Center(
            child: InkWell(
              onTap: () async {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.INFO,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Stadium Location',
                  desc: 'Do you want to see(${reservationModel.matchModel!.stadiumName}) Location',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () async {
                    List<Location> locations = await TazkartiUserCubit.get(context).getLatAndLngOfAddress(address: reservationModel.matchModel!.stadiumName!);

                    navigateTo(
                      context,
                      StadiumLocationScreen(
                        latitude: locations[0].latitude,
                        longitude: locations[0].longitude,
                      ),
                    );
                  },
                ).show();
              },
              child: Text(
                'Stadium Location',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontSize: 20.0,
                  color: Colors.green[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
