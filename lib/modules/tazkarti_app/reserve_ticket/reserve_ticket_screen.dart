import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:tazkarti_app/layout/tazkarti_app/admin/cubit/state.dart';
import 'package:tazkarti_app/layout/tazkarti_app/user/cubit/cubit.dart';
import 'package:tazkarti_app/layout/tazkarti_app/user/cubit/state.dart';
import 'package:tazkarti_app/models/tazkarti_app/match_model.dart';
import 'package:tazkarti_app/modules/tazkarti_app/maps/maps_screen.dart';
import 'package:tazkarti_app/shared/components/components.dart';
import 'package:tazkarti_app/shared/components/constants.dart';

class ReserveTicketScreen extends StatelessWidget {

  MatchModel matchModel;

  ReserveTicketScreen(this.matchModel);

  var formKey = GlobalKey<FormState>(); //validator

  var DropDownKeyStadium = GlobalKey<DropdownSearchState<String>>();
  var stadiumName = TextEditingController();
  var stadiumLogo = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var ticketPriceController = TextEditingController();
  var ticketNumbersController = TextEditingController();
  var _ticketController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<TazkartiUserCubit,TazkartiUserState>(
      listener: (context, state) {},
      builder: (context, state) {

        var cubit = TazkartiUserCubit.get(context);


        stadiumName.text = matchModel.stadiumName!;
        stadiumLogo.text = matchModel.stadiumLogo!;
        dateController.text = matchModel.matchDate!;
        timeController.text = matchModel.matchTime!;
        ticketNumbersController.text = matchModel.ticketNumbers!;
        ticketPriceController.text = matchModel.ticketPrice!;

        return Scaffold(
          appBar:  AppBar(
            backgroundColor: Colors.green[600],
            centerTitle: true,
            title: Text(
              'Reserve Tickets',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ),

          ),
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children:
                [
                  Text(
                    matchModel.stadiumName!,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontSize: 20.0,
                      color: Colors.green[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  InkWell(
                    onTap: () async {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.INFO,
                        animType: AnimType.BOTTOMSLIDE,
                        title: 'Stadium Location',
                        desc: 'Do you want to see(${matchModel.stadiumName}) Location',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () async {
                          List<Location> locations = await TazkartiUserCubit.get(context).getLatAndLngOfAddress(address: matchModel.stadiumName!);

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
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5.0,
                      margin: EdgeInsets.all(
                        8.0,
                      ),
                      child: Row(
                        children:
                        [
                          Expanded(
                            child: Image(
                              width: double.infinity,
                              height: 200.0,
                              image: NetworkImage(
                                matchModel.stadiumLogo!,
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                      Center(
                        child: Text(
                          '${matchModel.matchDate}',
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 5.0,
                        margin: EdgeInsets.all(
                          8.0,
                        ),
                        child: Padding(
                          padding:const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Expanded(
                                child: Text(
                                  '${matchModel.firstTeamName}',
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
                                    '${matchModel.logoFirstTeam}',
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '${matchModel.matchTime}',
                                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                        fontSize: 13.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Image(
                                  image: NetworkImage(
                                    '${matchModel.logoSecondTeam}',
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Text(
                                  '${matchModel.secondTeamName}',
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
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
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
                                  'ticket price :',
                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  matchModel.ticketPrice!+' '+'\$',
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
                                'available tickets :',
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                '${int.parse(matchModel.ticketNumbers!) - matchModel.nomOfReservedTickets!}',
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
                    height: 15.0,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:
                          [
                            Text(
                              'Number Of Tickets You Need :',
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              child: MaterialButton(
                                onPressed: (){
                                  if(cubit.counter < 2){
                                    showToast(
                                      text: 'Number Of Tickets Can Not be zero!',
                                      state: ToastStates.ERROR,
                                    );
                                  }
                                  else
                                    cubit.minus();
                                },
                                child: Icon(
                                  Icons.remove,
                                  size: 25,
                                  color: Colors.deepOrange,
                                ),
                                minWidth: 20,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${cubit.counter}',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              child: MaterialButton(
                                onPressed: (){
                                  if(cubit.counter > 2) {
                                    showToast(
                                      text: 'You Can Reserve Until 3 Tickets only!',
                                      state: ToastStates.ERROR,
                                    );
                                  }
                                  else
                                    cubit.plus();
                                },
                                child: Icon(
                                  Icons.add,
                                  size: 25,
                                  color: Colors.green[600],
                                ),
                                minWidth: 10,
                                padding: EdgeInsets.zero,

                              ),
                            ),
                          ],
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
                        Row(
                          children:
                          [
                            Text(
                              'Total price :',
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              '${int.parse(matchModel.ticketPrice!) * cubit.counter}'+' '+'\$',
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                fontSize: 20.0,
                                color: Colors.green[600],
                                fontWeight: FontWeight.bold,
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Conditional.single(
                      context: context,
                      conditionBuilder: (context)=> state is! TazkartiUserReserveTicketLoadingState,
                      widgetBuilder: (context)=> defaultButton(
                        function: (){
                          cubit.userReserveTicket(
                            matchId: matchModel.matchId!,
                            numOfTickets: cubit.counter,
                            totalPrice: (double.parse(matchModel.ticketPrice!) * cubit.counter),
                            newNumOfTickets: matchModel.nomOfReservedTickets! + cubit.counter,
                          );
                        },
                        text: 'Reserve',
                        raduis: 20.0,
                        btnColor: Colors.green.shade600,
                        isUpperCase: true,
                      ),
                      fallbackBuilder:(context)=> Center(child: CircularProgressIndicator(color: Colors.green,), )
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
