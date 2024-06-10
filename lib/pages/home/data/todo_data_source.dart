

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/error/exception.dart';
import '../../../core/error/failure.dart';
import '../../../core/network/api_consts.dart';
import '../../../core/network/network_utils.dart';
import '../models/todo_login_response.dart';

abstract class ITodoDataSource {
  Future<Either<Failure, TodoModelResponse>> getTodos(
      int limit, int skip);
}

class TodoDataSource extends ITodoDataSource{
  final NetworkUtils _networkUtils ;
  TodoDataSource(this._networkUtils);
  @override
  Future<Either<Failure, TodoModelResponse>> getTodos(int limit, int skip)async {
    try {
      var response = await _networkUtils.get(
        "${ApiConstance.baseUrl}${ApiConstance.todos}",
       queryParameters: {
          "limit":limit,
         "skip":skip
        }
      );
      TodoModelResponse todoModelResponse = TodoModelResponse.fromJson(response.data);

      return Right(todoModelResponse);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message??""));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}