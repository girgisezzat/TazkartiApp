import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tazkarti_app/layout/tazkarti_app/admin/cubit/cubit.dart';
import 'package:tazkarti_app/layout/tazkarti_app/admin/cubit/state.dart';
import 'package:tazkarti_app/shared/components/components.dart';

class AddMatchesScreen extends StatelessWidget {

  AddMatchesScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>(); //validator
  var DropDownKeyTeam1 = GlobalKey<DropdownSearchState<String>>(); // as a controller
  var DropDownKeyTeam2 = GlobalKey<DropdownSearchState<String>>();// as a controller
  var DropDownKeyStadium = GlobalKey<DropdownSearchState<String>>();// as a controller
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var ticketPriceController = TextEditingController();
  var ticketNumbersController = TextEditingController();
  String? key1;
  String? key2;


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<TazkartiAdminCubit,TazkartiAdminState>(
      listener: (context, state) {},
      builder: (context, state) {

        var cubit = TazkartiAdminCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green[600],
            centerTitle: true,
            title: Text(
              'Add Matches',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ),

          ),
          body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: formKey, // to validate
                  child: Column(
                    children: [
                      dropDownSearch(
                          dropDownList: cubit.teamsData.values.toList(),
                          hint:'select first team',
                          dropDownSearchKey: DropDownKeyTeam1,
                          selectedItem: cubit.firstTeamName,
                          onChanged: (String? value) {

                            cubit.firstTeamName = value;
                            key1 = cubit.teamsData.keys.firstWhere((k) => cubit.teamsData[k] == '${cubit.firstTeamName}');
                            cubit.selectedTeamChanged();

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
                      dropDownSearch(
                          dropDownList: cubit.teamsData.values.toList(),
                          hint:'select second team',
                          dropDownSearchKey: DropDownKeyTeam2,
                          selectedItem: cubit.secondTeamName,
                          onChanged: (String? value) {

                            cubit.secondTeamName = value;
                            key2 = cubit.teamsData.keys.firstWhere((k) => cubit.teamsData[k] == '${cubit.secondTeamName}');
                            cubit.selectedTeamChanged();

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
                      dropDownSearch(
                          dropDownList: cubit.stadiumsData.keys.toList(),
                          hint:'select a stadium',
                          dropDownSearchKey: DropDownKeyStadium,
                          selectedItem: cubit.stadiumName,
                          onChanged: (String? value) {

                            cubit.stadiumName = value;
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
                      Card(
                        elevation: 5,
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding:const EdgeInsets.symmetric(
                              horizontal: 8
                          ),
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  dateController.text,
                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontSize: 20.0,
                                  ),
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
                                      DropDownKeyTeam1.currentState!=null? DropDownKeyTeam1.currentState!.getSelectedItem.toString() : 'first team',
                                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  if(key1!=null)
                                    Expanded(
                                      child: Image(
                                        image: NetworkImage('https://sportteamslogo.com/api?key=2fc4f5d0d1d6456e92f032135a2c544c&size=medium&tid=$key1'),
                                      ),
                                    ),

                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          timeController.text,
                                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                            fontSize: 10.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),

                                  if(key2!=null)
                                    Expanded(
                                      child: Image(
                                        image: NetworkImage('https://sportteamslogo.com/api?key=2fc4f5d0d1d6456e92f032135a2c544c&size=medium&tid=$key2'),
                                      ),
                                    ),

                                  Expanded(
                                    child: Text(
                                      DropDownKeyTeam2.currentState!=null? DropDownKeyTeam2.currentState!.getSelectedItem.toString() : 'second team',
                                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              if(cubit.stadiumName != null)
                                Column(
                                  children:
                                  [
                                    Text(
                                      DropDownKeyStadium.currentState!=null? DropDownKeyStadium.currentState!.getSelectedItem.toString() : 'stadium name',
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
                                            cubit.stadiumsData[cubit.stadiumName]!,
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
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Conditional.single(
                        context: context,
                        conditionBuilder: (context)=> state is! TazkartiAdminAddMatchLoadingState ,
                        widgetBuilder: (context)=> defaultButton(
                          function: (){
                            if (formKey.currentState!.validate()) {
                              cubit.addMatch(
                                firstTeamName: DropDownKeyTeam1.currentState!.getSelectedItem.toString(),
                                secondTeamName: DropDownKeyTeam2.currentState!.getSelectedItem.toString(),
                                stadiumName: DropDownKeyStadium.currentState!.getSelectedItem.toString(),
                                matchDate: dateController.text,
                                matchTime: timeController.text,
                                logoFirstTeam: 'https://sportteamslogo.com/api?key=2fc4f5d0d1d6456e92f032135a2c544c&size=medium&tid=$key1',
                                logoSecondTeam: 'https://sportteamslogo.com/api?key=2fc4f5d0d1d6456e92f032135a2c544c&size=medium&tid=$key2',
                                stadiumLogo: cubit.stadiumsData[cubit.stadiumName]!,
                                ticketNumbers: ticketNumbersController.text,
                                ticketPrice: ticketPriceController.text
                              );

                            }
                          },
                          text: 'Add Match',
                          raduis: 20.0,
                          btnColor: Colors.green.shade600,
                          isUpperCase: true,
                        ),
                        fallbackBuilder: (context)=> Center(child: CircularProgressIndicator(),),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      if(state is TazkartiAdminAddMatchLoadingState)
                        LoadingIndicator(
                          indicatorType: Indicator.ballBeat,
                          colors: [
                            Colors.green.shade600,
                            Colors.red,
                            Colors.yellowAccent,
                            Colors.blue,
                            Colors.orange,
                          ],
                        )
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