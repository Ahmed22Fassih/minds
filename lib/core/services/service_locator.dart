

import 'package:get_it/get_it.dart';

import '../../pages/home/data/todo_data_source.dart';
import '../../pages/home/home_viewModel/home_viewModel.dart';
import '../../pages/login/loginDataSource/login_data_source.dart';
import '../../pages/login/loginViewModel/login_viewModel.dart';
import '../localDataBase/todo_db.dart';
import '../network/network_utils.dart';


final sl = GetIt.instance;

class ServicesLocator {
  void init() {

    sl.registerLazySingleton<NetworkUtils>(
            () => NetworkUtils());

    sl.registerLazySingleton<TodoBD>(
            () => TodoBD());

    sl.registerLazySingleton<ILoginDataSource>(
            () => LoginDataSource(sl()));

    sl.registerLazySingleton<ITodoDataSource>(
            () => TodoDataSource(sl()));

    sl.registerLazySingleton<LoginViewModel>(
            () => LoginViewModel(sl()));

    sl.registerLazySingleton<HomeViewModel>(
            () => HomeViewModel(sl()));

  }
}