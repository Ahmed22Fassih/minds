import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maids_task/pages/home/homeScreen/widgets/todo_item.dart';
import 'package:maids_task/pages/home/home_viewModel/home_viewModel.dart';
import 'package:maids_task/utils/enum/state_view.dart';
import 'package:provider/provider.dart';

import '../../../core/localDataBase/todo_db.dart';
import '../../../core/services/service_locator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeViewModel homeViewModel = sl();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    homeViewModel.getTodosDataFromLocalOrRemote();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // homeViewModel.getMoreNews();
        // homeViewModel.incrementPage();
        homeViewModel.getTodosPaginationDataFromLocalOrRemote();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: homeViewModel.scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            TodoBD.deleteAllTodos();
          },
          child: const Icon(Icons.delete),
        ),
        body: ChangeNotifierProvider(
          create: (context) => homeViewModel,
          child: Selector<HomeViewModel, ViewState>(
            selector: (context, viewModel) => viewModel.todoViewState,
            builder: (_, todoView, __) {
              if (todoView == ViewState.Loading && homeViewModel.skip == 0) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if(homeViewModel.todos.isNotEmpty){
                  return Selector<HomeViewModel,bool>(
                    selector: (context, viewModel) => viewModel.loadMore,
                    builder: (_,loadingMore,__){
                     return ListView.separated(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(vertical: 48.h),
                          itemBuilder: (context, index) {
                            if (index == homeViewModel.todos.length&&loadingMore) {
                              return homeViewModel.loadMore
                                  ? const Center(child: CircularProgressIndicator())
                                  : const SizedBox.shrink();
                            }
                            return TodoItem(
                              todo: homeViewModel.todos[index],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 24.h,
                            );
                          },
                          itemCount: homeViewModel.todos.length+ (homeViewModel.loadMore ? 1 : 0));
                    },
                  );
                }else{
                  return const Center(child: Text("No data found"));
                }
              }
            },
          ),
        ));
  }
}
