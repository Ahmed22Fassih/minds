import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maids_task/core/localDataBase/todo_db.dart';
import 'package:maids_task/pages/home/home_viewModel/home_viewModel.dart';
import 'package:maids_task/pages/login/loginScreen/login_screen.dart';
import 'package:maids_task/pages/login/loginViewModel/login_viewModel.dart';
import 'package:provider/provider.dart';

import 'core/services/service_locator.dart';

void main() async{
  ServicesLocator().init();
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await TodoBD.createDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginViewModel>(create: (_) => LoginViewModel(sl())),
        ChangeNotifierProvider<HomeViewModel>(create: (_) => HomeViewModel(sl(),)),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        child: MaterialApp(
          title: 'Flutter Demo',
          home:LoginScreen(),
        ),
      ),
    );
  }
}
