

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/error/exception.dart';
import '../../../core/error/failure.dart';
import '../../../core/network/api_consts.dart';
import '../../../core/network/network_utils.dart';
import '../models/userData.dart';

Map<String, dynamic> headers = {
  "Accept": "text/plain",
  "User-Agent": "PostmanRuntime/7.37.3",
  "Content-Type": "application/json",
};

abstract class ILoginDataSource{
  Future<Either<Failure, UserData>> login(
      String email, String password);
}

class LoginDataSource extends ILoginDataSource{
  final NetworkUtils _networkUtils ;
  LoginDataSource(this._networkUtils);

  @override
  Future<Either<Failure, UserData>> login(String email, String password) async{
    try {
      /// todo make instance from dio and inject in this class
      /// and replace this object with this instance have network config
      var response = await _networkUtils.post(
        "${ApiConstance.baseUrl}${ApiConstance.auth}${ApiConstance.login}",
        data: {
          "username":email,
          "password":password,
        },
      );
      UserData userData = UserData.fromJson(response.data);
      return Right(userData);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message??""));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
