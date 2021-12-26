import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:tazkarti_app/layout/tazkarti_app/admin/tazkarti_admin_layout.dart';
import 'package:tazkarti_app/layout/tazkarti_app/user/tazkarti_user_layout.dart';
import 'package:tazkarti_app/modules/tazkarti_app/register/register_screen.dart';
import 'package:tazkarti_app/shared/components/components.dart';
import 'package:tazkarti_app/shared/components/constants.dart';
import 'package:tazkarti_app/shared/network/local/cache_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class TazkartiLoginScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TazkartiLoginCubit(),
      child: BlocConsumer<TazkartiLoginCubit,TazkartiLoginState>(
        listener: (context,state)
        {
          if (state is TazkartiLoginErrorState) {
            showToast(
              text: state.error,
              state: ToastStates.ERROR,
            );
          }

          if(state is TazkartiLoginSuccessState){

            if(emailController.text == 'girgisezzat123456@gmail.com' &&
                passwordController.text == '1234567'){

              CacheHelper.saveData(
                key: 'uId',
                value: state.uId,
              ).then((value)
              {
                navigateAndFinish(
                  context,
                  TazkartiAdminLayout(),
                );
                uId = state.uId;
              });

              print('admin login');
            }


            else{
              CacheHelper.saveData(
                key: 'uId',
                value: state.uId,
              ).then((value)
              {
                navigateAndFinish(
                  context,
                  TazkartiUserLayout(),
                );
                uId = state.uId;
              });

              CacheHelper.saveData(
                key: 'authType',
                value: state.authType,
              ).then((value)
              {
                navigateAndFinish(
                  context,
                  TazkartiUserLayout(),
                );
                uId = state.uId;
              });
              print('user login');
            }

          }

          if (state is TazkartiLoginWithGoogleErrorState) {
            showToast(
              text: state.error,
              state: ToastStates.ERROR,
            );
          }


          if(state is TazkartiLoginWithGoogleSuccessState){
            navigateAndFinish(
              context,
              TazkartiUserLayout(),
            );
          }
        },

        builder:  (context,state)
        {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green[600],
              centerTitle: true,
              title: Text(
                'LOGIN',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
              ),
            ),
            body:Center(
              child: Stack(
                children:
                [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [GREEN, YELLOW],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(40),
                            bottomLeft: Radius.circular(40),
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              GREEN.withOpacity(0.7),
                              BlendMode.dstOut,
                            ),
                            image: AssetImage(
                              'assets/images/ahly.jpg',
                            ),
                          ),
                        ),
                        width: double.infinity,
                        height: 250,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Form(
                            key: formKey,
                            child: Padding(
                              padding: EdgeInsets.all(
                                  8.0
                              ),
                              child:Column(
                                children:
                                [
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'login now to Book Your Tickets',
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color:Colors.grey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  defaultTextFormField(
                                    fieldController: emailController,
                                    inputType: TextInputType.emailAddress,
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return 'please enter your email address';
                                      }
                                    },
                                    labelText: 'Email Address',
                                    raduis: 20.0,
                                    prefixIcon: Icons.email_outlined,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultTextFormField(
                                    fieldController: passwordController,
                                    inputType: TextInputType.visiblePassword,
                                    obscureText: TazkartiLoginCubit.get(context).isPassword,
                                    suffixIcon: TazkartiLoginCubit.get(context).suffix,
                                    suffixClicked: (){
                                      TazkartiLoginCubit.get(context).changePasswordVisibility();
                                    },
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return 'password is too short';
                                      }
                                    },
                                    labelText: 'Password',
                                    raduis: 20.0,
                                    prefixIcon: Icons.lock_outline,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Conditional.single(
                                    context: context,
                                    conditionBuilder: (context)=> state is! TazkartiLoginLoadingState ,
                                    widgetBuilder: (context)=> defaultButton(
                                      function: (){
                                        if (formKey.currentState!.validate()) {

                                            TazkartiLoginCubit.get(context).userLogin(
                                              email: emailController.text,
                                              password: passwordController.text,
                                            );

                                        }
                                      },
                                      text: 'login',
                                      raduis: 20.0,
                                      btnColor: Colors.green.shade600,
                                      isUpperCase: true,
                                    ),
                                    fallbackBuilder: (context)=> Center(child: CircularProgressIndicator()),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text(
                                        'Don\'t have an account?',
                                      ),
                                      TextButton(
                                        onPressed: ()
                                        {
                                          navigateTo(context, TazkartiRegisterScreen(),);
                                        },
                                        child: Text(
                                            'Register'
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Row(
                                    children:
                                    [
                                      Expanded(
                                        child: Container(
                                          color: BROWN,
                                          height: 3.0,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        'OR',
                                        style: TextStyle(
                                            color: BROWN,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Expanded(
                                          child: Container(
                                            color: BROWN,
                                            height: 3.0,
                                          )
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      InkWell(
                                        onTap: (){
                                          print('google login');
                                          TazkartiLoginCubit.get(context).logInWithGoogle(context: context);
                                        },
                                        child: CircleAvatar(
                                          radius: 15.0,
                                          backgroundColor: Colors.white,
                                          backgroundImage: AssetImage(
                                              'assets/images/icons8-google-48.png',
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: (){
                                          print('twitter login');
                                        },
                                        child: CircleAvatar(
                                          radius: 15.0,
                                          backgroundColor: Colors.white,
                                          backgroundImage: AssetImage(
                                            'assets/images/icons8-twitter-48.png',
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          print('facebook login');
                                        },
                                        child: CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Colors.white,
                                          backgroundImage: AssetImage(
                                              'assets/images/icons8-facebook-logo-48.png'
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
