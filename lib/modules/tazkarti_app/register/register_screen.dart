import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:tazkarti_app/layout/tazkarti_app/user/tazkarti_user_layout.dart';
import 'package:tazkarti_app/shared/components/components.dart';
import 'package:tazkarti_app/shared/components/constants.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';


class TazkartiRegisterScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TazkartiRegisterCubit(),
      child: BlocConsumer<TazkartiRegisterCubit, TazkartiRegisterState>(
        listener: (context, state)
        {
          if (state is TazkartiCreateUserErrorState) {
            showToast(
              text: state.error,
              state: ToastStates.ERROR,
            );
          }

          if (state is TazkartiCreateUserSuccessState) {

            navigateAndFinish(
              context,
              TazkartiUserLayout(),
            );
          }
        },
        builder: (context, state)
        {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green[600],
              centerTitle: true,
              title: Text(
                'Register',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
              ),
            ),
            body: Center(
              child:Stack(
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
                                    'Register now to Book Your Tickets',
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Colors.grey,
                                      //fontSize: 15.0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  defaultTextFormField(
                                    fieldController: nameController,
                                    inputType: TextInputType.name,
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return 'please enter your name';
                                      }
                                    },
                                    labelText: 'User Name',
                                    raduis: 20.0,
                                    prefixIcon: Icons.person,
                                  ),
                                  SizedBox(
                                    height: 15.0,
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
                                    fieldController: phoneController,
                                    inputType: TextInputType.phone,
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return 'please enter your phone number';
                                      }
                                    },
                                    labelText: 'Phone',
                                    raduis: 20.0,
                                    prefixIcon: Icons.phone,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultTextFormField(
                                    fieldController: passwordController,
                                    inputType: TextInputType.visiblePassword,
                                    obscureText: TazkartiRegisterCubit.get(context).isPassword,
                                    suffixIcon: TazkartiRegisterCubit.get(context).suffix,
                                    suffixClicked: (){
                                      TazkartiRegisterCubit.get(context).changePasswordVisibility();
                                    },
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return 'please enter your password';
                                      }
                                    },
                                    labelText: 'Password',
                                    raduis: 20.0,
                                    prefixIcon: Icons.lock_outline,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultTextFormField(
                                    fieldController: confirmPasswordController,
                                    inputType: TextInputType.visiblePassword,
                                    obscureText: TazkartiRegisterCubit.get(context).isPassword,
                                    suffixIcon: TazkartiRegisterCubit.get(context).suffix,
                                    suffixClicked: (){
                                      TazkartiRegisterCubit.get(context).changePasswordVisibility();
                                    },
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return 'please enter your password';
                                      }
                                      else if(value != passwordController.text)
                                        return 'Password Don\'t Match';
                                    },
                                    labelText: 'Confirm Password',
                                    raduis: 20.0,
                                    prefixIcon: Icons.lock_outline,
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Conditional.single(
                                    context: context,
                                    conditionBuilder: (context)=> state is! TazkartiRegisterLoadingState,
                                    widgetBuilder: (context)=> defaultButton(
                                      function: () {
                                        if (formKey.currentState!.validate())
                                        {
                                          TazkartiRegisterCubit.get(context).userRegister(
                                            name: nameController.text,
                                            email: emailController.text,
                                            password: passwordController.text,
                                            phone: phoneController.text,
                                          );
                                        }
                                      },
                                      text: 'Register',
                                      raduis: 20.0,
                                      isUpperCase: true,
                                      btnColor: Colors.green.shade600,
                                    ),
                                    fallbackBuilder: (context)=>
                                        Center(child: CircularProgressIndicator()),
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
