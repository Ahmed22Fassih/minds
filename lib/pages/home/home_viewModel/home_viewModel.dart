
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../core/error/failure.dart';
import '../../../core/localDataBase/todo_db.dart';
import '../../../utils/enum/state_view.dart';
import '../../../utils/toast/global_toast.dart';
import '../data/todo_data_source.dart';
import '../models/todo_login_response.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this.todoDataSource);

  final ITodoDataSource todoDataSource;
  // final TodoBD todoBD ;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ViewState todoViewState = ViewState.Empty;
  bool loadMore = false ;

  int limit = 10;
  int skip = 0;
  int totalTodos = 0;

  List<Todos> todos = [];

  /// call api to get todos list
  Future<void> getTodosFromApi({int limit = 10,int skip = 0}) async {
    changeTodoState(ViewState.Loading);
    changeLoadMoreState(true);
    Either<Failure, TodoModelResponse> response =
        await todoDataSource.getTodos(limit, skip);
    return response.fold((error) {
      /// todo handel Error
      changeTodoState(ViewState.Error);
      changeLoadMoreState(false);
      log("error${error.message}");
      // GlobalToast.showToast(error.message);
      GlobalToast.showToast("something error , try again");
      notifyListeners();
    }, (todos) {
      addMoreTodos(todos.todos??[]);
      this.limit = todos.limit??0;
      this.skip = todos.skip??0;
      totalTodos = todos.total??0;
      todos.todos?.forEach((element) {
        TodoBD.insertTodo(element);
      });
      changeTodoState(ViewState.Success);
      changeLoadMoreState(false);
      notifyListeners();
    });
  }


  // read data from local database
  getTodosFromLocal() async {
    changeTodoState(ViewState.Loading);
    var todos = await TodoBD.getTodos();
    this.todos = todos.map((e) => Todos.fromJson(e)).toList();
    changeTodoState(ViewState.Success);
  }

  // get more Todos from local database
  getMoreNews() async {
    changeLoadMoreState(true);
    var todos = await TodoBD.getMoreTodos(this.todos.length);
    log("todos ${this.todos.length}");
    this.todos.addAll(todos.map((e) => Todos.fromJson(e)).toList());
    changeTodoState(ViewState.Success);
    changeLoadMoreState(false);
  }


  // check if current page loaded is page index then increment
  Future<void> incrementPage() async {
    if (totalTodos>skip) {
      // limit = limit + 10; /// if need increase limmit
      skip = skip + 10;
      log("limit $limit");
      log("skip $skip");
      await getTodosFromApi(limit: limit,skip: skip);
    }
  }

  /// append list of Todos to my Todos list.
  void addMoreTodos(List<Todos> todoList) {
    todos.addAll(todoList);
    log("todos${todos.length}");
    notifyListeners();
  }

  void changeTodoState(ViewState newState) {
    todoViewState = newState;
    notifyListeners();
  }
  void changeLoadMoreState(bool load) {
    loadMore = load;
    notifyListeners();
  }

  Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true ;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true ;
    } else {
      return false ;
    }
  }

  Future<void> getTodosDataFromLocalOrRemote()async {
    // if(await checkConnection()){
    if(false){
      getTodosFromApi();
    }else{
      getTodosFromLocal();
    }
  }

  Future<void> getTodosPaginationDataFromLocalOrRemote() async{
    // if(await checkConnection()){
    if(false){
      incrementPage();
    }else{
      getMoreNews();
      log("getMoreNews");
    }
  }
}
