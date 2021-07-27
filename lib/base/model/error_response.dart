import 'package:fitcarib/base/model/base_model.dart';

class ErrorResponse extends BaseModel
{
  String? message;

  ErrorResponse.fromJSON(dynamic data) : super.fromJSON(data) {
    if (data != null) {
      message = data["message"];
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data["message"] = message;
    return data;
  }
}
