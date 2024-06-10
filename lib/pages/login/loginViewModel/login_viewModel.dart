
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:maids_task/pages/login/models/userData.dart';
import 'package:maids_task/utils/enum/state_view.dart';

import '../../../core/error/failure.dart';
import '../../../utils/global_vars.dart';
import '../../../utils/toast/global_toast.dart';
import '../loginDataSource/login_data_source.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel(this.loginDataSource);

  final ILoginDataSource loginDataSource;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ViewState loginViewState = ViewState.Empty ;

  Future<void> callLogin(Function goToHome) async {
    changeLoginState(ViewState.Loading);
    Either<Failure, UserData> response = await loginDataSource.login(
        emailController.text,
        passwordController.text);
    return response.fold((error) {
      /// todo handel Error
      changeLoginState(ViewState.Error);
      // GlobalToast.showToast(error.message);
      GlobalToast.showToast("something error , try again");
      notifyListeners();
    }, (user) {
      GlobalVars.userData = user ;
      goToHome.call();
      changeLoginState(ViewState.Success);
    });
  }

  void changeLoginState(ViewState newState){
    loginViewState = newState;
    notifyListeners();
  }
}
