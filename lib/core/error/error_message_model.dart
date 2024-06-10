
class ErrorMessageModel {
  final int statusCode;
  final String statusMessage;

  const ErrorMessageModel(this.statusCode, this.statusMessage);

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) {
    return ErrorMessageModel(json["statusCode"], json["message"]);
  }
}
