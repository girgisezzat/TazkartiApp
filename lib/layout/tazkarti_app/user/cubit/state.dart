abstract class TazkartiUserState {}

class TazkartiInitialUserState extends TazkartiUserState {}

//Bottom NavigationBar
class TazkartiChangeBottomNavUserState extends TazkartiUserState{}
class TazkartiAddMatchState extends TazkartiUserState {}


//Home
class TazkartiLoadingHomeDataState extends TazkartiUserState {}
class TazkartiSuccessHomeDataState extends TazkartiUserState {}
class TazkartiErrorHomeDataState extends TazkartiUserState
{
  late final String error;
  TazkartiErrorHomeDataState(this.error);
}


//Get User Data
class TazkartiGetUserDataLoadingState extends TazkartiUserState {}
class TazkartiGetUserDataSuccessState extends TazkartiUserState {}
class TazkartiGetUserDataErrorState extends TazkartiUserState
{
  late final String error;
  TazkartiGetUserDataErrorState(this.error);
}


class TazkartiSelectedTeamChangedUserState extends TazkartiUserState {}

//Get Match Data
class TazkartiGetMatchSuccessUserState extends TazkartiUserState {}


//Counter
class CounterMinusState extends TazkartiUserState
{
  late final int counter;

  CounterMinusState(this.counter);
}
class CounterPlusState extends TazkartiUserState
{
  late final int counter;

  CounterPlusState(this.counter);
}

//Reserve Ticket
class TazkartiUserReserveTicketLoadingState extends TazkartiUserState {}
class TazkartiUserReserveTicketSuccessState extends TazkartiUserState {}
class TazkartiUserReserveTicketErrorState extends TazkartiUserState
{
  late final String error;
  TazkartiUserReserveTicketErrorState(this.error);
}


//Get Reserve Ticket
class TazkartiGetUserReserveTicketLoadingState extends TazkartiUserState {}
class TazkartiGetUserReserveTicketSuccessState extends TazkartiUserState {}
class TazkartiGetUserReserveTicketErrorState extends TazkartiUserState
{
  late final String error;
  TazkartiGetUserReserveTicketErrorState(this.error);
}