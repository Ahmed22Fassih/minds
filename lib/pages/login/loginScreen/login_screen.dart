import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maids_task/pages/home/homeScreen/home_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/services/service_locator.dart';
import '../../../utils/enum/state_view.dart';
import '../../../utils/navigator.dart';
import '../../../utils/textFields/default_text_field.dart';
import '../../../utils/textFields/password_text_field.dart';
import '../loginViewModel/login_viewModel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginViewModel loginViewModel = sl();

  void goToHome(BuildContext context) {
    navigateAndKeepStack(context, const HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>loginViewModel,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          key: loginViewModel.scaffoldKey,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      if (kDebugMode) {
                        loginViewModel.emailController.text = 'emilys';
                        loginViewModel.passwordController.text = 'emilyspass';
                      }
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 96.sp),
                    )),
                SizedBox(
                  height: 60.h,
                ),
                DefaultTextField(
                  controller: loginViewModel.emailController,
                  hintName: "Email",
                  onChange: (String value) {
                    loginViewModel.emailController.text = value;
                  },
                ),
                SizedBox(
                  height: 16.h,
                ),
                PasswordTextField(
                  passwordController: loginViewModel.passwordController,
                  hint: "Password",
                  onChanged: (String value) {
                    loginViewModel.passwordController.text = value;
                  },
                  lable: 'Password',
                ),
                SizedBox(
                  height: 40.h,
                ),

                /// can make custom button if need
                Selector<LoginViewModel, ViewState>(
                  selector: (context, viewModel) => viewModel.loginViewState,
                  builder: (_, value, __) {
                    log("value$value");
                    if (value == ViewState.Loading) {
                      return const CircularProgressIndicator();
                    } else {
                      return ElevatedButton(
                          onPressed: () {
                            if (loginViewModel.emailController.text.isNotEmpty &&
                                loginViewModel
                                    .passwordController.text.isNotEmpty) {
                              loginViewModel.callLogin(() {
                                goToHome(context);
                              });
                            }
                          },
                          child: const Text("Login"));
                    }
                  },
                ),
                SizedBox(
                  height: 60.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
