abstract class TazkartiLoginState {}

class TazkartiLoginInitialState extends TazkartiLoginState{}

//Login With Email$Password
class TazkartiLoginLoadingState extends TazkartiLoginState{}
class TazkartiLoginSuccessState extends TazkartiLoginState
{
  late final String uId;
  late final String authType;
  TazkartiLoginSuccessState(this.uId,this.authType);
}
class TazkartiLoginErrorState extends TazkartiLoginState
{
  late final String error;

  TazkartiLoginErrorState(this.error);
}

//Login With Google
class TazkartiLoginWithGoogleLoadingState extends TazkartiLoginState{}
class TazkartiLoginWithGoogleSuccessState extends TazkartiLoginState {}
class TazkartiLoginWithGoogleErrorState extends TazkartiLoginState
{
  late final String error;

  TazkartiLoginWithGoogleErrorState(this.error);
}



class TazkartiChangePasswordVisibilityState extends TazkartiLoginState{}