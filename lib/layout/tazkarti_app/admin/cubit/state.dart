abstract class TazkartiAdminState {}

class TazkartiInitialAdminState extends TazkartiAdminState {}

//Bottom NavigationBar
class TazkartiChangeBottomNavAdminState extends TazkartiAdminState{}


//Home
class TazkartiAdminLoadingHomeDataState extends TazkartiAdminState {}
class TazkartiAdminSuccessHomeDataState extends TazkartiAdminState {}
class TazkartiAdminErrorHomeDataState extends TazkartiAdminState
{
  late final String error;
  TazkartiAdminErrorHomeDataState(this.error);
}


//Get Admin Data
class TazkartiGetAdminDataLoadingState extends TazkartiAdminState {}
class TazkartiGetAdminDataSuccessState extends TazkartiAdminState {}
class TazkartiGetAdminDataErrorState extends TazkartiAdminState
{
  late final String error;
  TazkartiGetAdminDataErrorState(this.error);
}


//Add Match
class TazkartiAdminAddMatchLoadingState extends TazkartiAdminState {}
class TazkartiAdminAddMatchSuccessState extends TazkartiAdminState {}
class TazkartiAdminAddMatchErrorState extends TazkartiAdminState
{
  late final String error;
  TazkartiAdminAddMatchErrorState(this.error);
}

//Update Match
class TazkartiAdminUpdateMatchLoadingState extends TazkartiAdminState {}
class TazkartiAdminUpdateMatchSuccessState extends TazkartiAdminState {}
class TazkartiAdminUpdateMatchErrorState extends TazkartiAdminState
{
  late final String error;
  TazkartiAdminUpdateMatchErrorState(this.error);
}


//Delete Match
class TazkartiAdminDeleteMatchSuccessState extends TazkartiAdminState {}
class TazkartiAdminDeleteMatchErrorState extends TazkartiAdminState
{
  late final String error;
  TazkartiAdminDeleteMatchErrorState(this.error);
}


//Get Match Data
class TazkartiGetMatchSuccessAdminState extends TazkartiAdminState {}

//Get Specific Match Data
class TazkartiGetSpecificMatchSuccessAdminState extends TazkartiAdminState {}

//Select Team
class TazkartiSelectedTeamChangedAdminState extends TazkartiAdminState {}

//Select Stadium
class TazkartiSelectedStadiumChangedAdminState extends TazkartiAdminState {}

//Search By Team
class TazkartiSearchTrueByTeamAdminState extends TazkartiAdminState {}
class TazkartiSearchFalseByTeamAdminState extends TazkartiAdminState {}


//Search Match
class TazkartiAdminSearchMatchLoadingState extends TazkartiAdminState {}
class TazkartiAdminSearchMatchSuccessState extends TazkartiAdminState {}
class TazkartiAdminSearchMatchErrorState extends TazkartiAdminState
{
  late final String error;
  TazkartiAdminSearchMatchErrorState(this.error);
}

//Publish Match
class TazkartiAdminReleaseMatchTicketsLoadingState extends TazkartiAdminState {}
class TazkartiAdminReleaseMatchTicketsSuccessState extends TazkartiAdminState {}
class TazkartiAdminReleaseMatchTicketsErrorState extends TazkartiAdminState
{
  late final String error;
  TazkartiAdminReleaseMatchTicketsErrorState(this.error);
}