import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tazkarti_app/layout/tazkarti_app/admin/cubit/cubit.dart';
import 'package:tazkarti_app/layout/tazkarti_app/admin/cubit/state.dart';
import 'package:tazkarti_app/models/tazkarti_app/match_model.dart';
import 'package:tazkarti_app/shared/components/components.dart';

class EditMatchesScreen extends StatelessWidget {

  MatchModel matchModel;

  EditMatchesScreen(this.matchModel);

  var formKey = GlobalKey<FormState>(); //validator

  var DropDownKeyStadium = GlobalKey<DropdownSearchState<String>>();
  var stadiumName = TextEditingController();
  var stadiumLogo = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var ticketPriceController = TextEditingController();
  var ticketNumbersController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<TazkartiAdminCubit,TazkartiAdminState>(

      listener: (context, state) {
        print(TazkartiAdminCubit.get(context).specificMatchId);
      },
      builder: (context, state) {


        var cubit = TazkartiAdminCubit.get(context);

        stadiumName.text = matchModel.stadiumName!;
        stadiumLogo.text = matchModel.stadiumLogo!;
        dateController.text = matchModel.matchDate!;
        timeController.text = matchModel.matchTime!;
        ticketNumbersController.text = matchModel.ticketNumbers!;
        ticketPriceController.text = matchModel.ticketPrice!;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green[600],
            centerTitle: true,
            title: Text(
              'Edit Matches',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ),

          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
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
                    SizedBox(
                      height: 8.0,
                    ),
                    Card(
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
                            Padding(
                              padding:const EdgeInsets.symmetric(
                                  horizontal: 8
                              ),
                              child: Column(
                                children: [
                                  Center(
                                    child: Text(
                                      '${matchModel.matchDate}',
                                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                        fontSize: 20.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
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
                                                fontSize: 10.0,
                                              ),
                                              textAlign: TextAlign.center,
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
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Column(
                                      children:
                                      [
                                        Text(
                                          DropDownKeyStadium.currentState != null? DropDownKeyStadium.currentState!.getSelectedItem.toString() : matchModel.stadiumName!,
                                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                            fontSize: 20.0,
                                            color: Colors.green[600],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Row(
                                          children:
                                          [
                                            Expanded(
                                              child: Image(
                                                width: double.infinity,
                                                height: 150.0,
                                                image: NetworkImage(
                                                  matchModel.stadiumLogo!,
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                ],
                              ),

                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    dropDownSearch(
                        dropDownList: cubit.stadiumsData.keys.toList(),
                        hint:matchModel.stadiumName,
                        dropDownSearchKey: DropDownKeyStadium,
                        selectedItem: cubit.stadiumName,
                        onChanged: (String? value) {

                          matchModel.stadiumName = value;
                          matchModel.stadiumLogo = cubit.stadiumsData[matchModel.stadiumName!];
                          cubit.selectedStadiumChanged();

                        },
                        validator: (String? item){
                          if(item==null) {
                            return 'team must be selected';
                          }
                        }
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    defaultTextFormField(
                      fieldController:  dateController,
                      inputType:  TextInputType.datetime,
                      validator:  (value){
                        if(value!.isEmpty){
                          return 'Date Can Not Be Empty ';
                        }
                      },
                      onTap: (){
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.parse('2022-08-01'),
                        ).then((value) {
                          dateController.text = DateFormat.yMMMd().format(value!);
                          print(DateFormat.yMMMd().format(value));
                        });
                      },
                      labelText:  'Match Date',
                      prefixIcon:  Icons.calendar_today,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    defaultTextFormField(
                      fieldController: timeController,
                      inputType:  TextInputType.datetime,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Time Can Not Be Empty ';
                        }
                      },
                      onTap: (){
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((value){
                          timeController.text = value!.format(context).toString();
                          print(value.format(context));
                        });
                      },
                      labelText:  'Match Time',
                      prefixIcon:  Icons.watch_later_outlined,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    defaultTextFormField(
                      fieldController: ticketPriceController,
                      inputType:  TextInputType.number,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Ticket price Can Not Be Empty ';
                        }
                      },
                      labelText:  'Ticket Price',
                      prefixIcon:  Icons.price_change_outlined,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    defaultTextFormField(
                      fieldController: ticketNumbersController,
                      inputType:  TextInputType.number,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Ticket numbers Can Not Be Empty ';
                        }
                      },
                      labelText:  'Ticket Numbers',
                      prefixIcon:  Icons.confirmation_number,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Conditional.single(
                      context: context,
                      conditionBuilder: (context)=> state is! TazkartiAdminUpdateMatchLoadingState ,
                      widgetBuilder: (context)=> defaultButton(
                        function: (){
                          if (formKey.currentState!.validate()) {
                            cubit.updateMatch(
                              firstTeamName: matchModel.firstTeamName.toString(),
                              logoFirstTeam: matchModel.logoFirstTeam.toString(),
                              stadiumName: DropDownKeyStadium.currentState!.getSelectedItem.toString(),
                              secondTeamName: matchModel.secondTeamName.toString(),
                              logoSecondTeam: matchModel.logoSecondTeam.toString(),
                              stadiumLogo: matchModel.stadiumLogo.toString(),
                              matchDate: dateController.text,
                              matchTime: timeController.text,
                              ticketNumbers: ticketNumbersController.text,
                              ticketPrice: ticketPriceController.text,
                              matchId: matchModel.matchId.toString(),
                            );
                          }
                        },
                        text: 'Update Match',
                        raduis: 20.0,
                        btnColor: Colors.green.shade600,
                        isUpperCase: true,
                      ),
                      fallbackBuilder: (context)=> Center(child: CircularProgressIndicator(),),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    // if(state is TazkartiAdminUpdateLoadingState)
                    //   LoadingIndicator(
                    //     indicatorType: Indicator.ballBeat,
                    //     colors: [
                    //       Colors.green.shade600,
                    //       Colors.red,
                    //       Colors.yellowAccent,
                    //       Colors.blue,
                    //       Colors.orange,
                    //     ],
                    //     strokeWidth: 2.0,
                    //   ),
                    // SizedBox(
                    //   height: 15.0,
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
