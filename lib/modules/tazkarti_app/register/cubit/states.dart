abstract class TazkartiRegisterState {}

class TazkartiRegisterInitialState extends TazkartiRegisterState {}


class TazkartiRegisterLoadingState extends TazkartiRegisterState {}
class TazkartiRegisterSuccessState extends TazkartiRegisterState {}
class TazkartiRegisterErrorState extends TazkartiRegisterState
{
  final String error;

  TazkartiRegisterErrorState(this.error);
}


class TazkartiCreateUserSuccessState extends TazkartiRegisterState {}
class TazkartiCreateUserErrorState extends TazkartiRegisterState
{
  final String error;

  TazkartiCreateUserErrorState(this.error);
}


class TazkartiRegisterChangePasswordVisibilityState extends TazkartiRegisterState {}