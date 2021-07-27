import 'package:fitcarib/base/model/base_model.dart';
import 'dart:convert';

class LoginRequest extends BaseModel
{
  String? email;
  String? username;
  String? name;
  String? imageId;
  String? access_token;


  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data["name"] = name;
    data["imageId"]=_getEncodeImage();
    data["access_token"] = access_token;
    return data;
  }

  LoginRequest.fromMap(Map<String, dynamic> map){
    name = map['name'];
    imageId = _decodeImage(map['imageId']);
    access_token = map['access_token'];
  }
  LoginRequest();

   String _getEncodeImage(){
     // encoding
     var bytesInLatin1 = latin1.encode(imageId!);
    // [68, 97, 114, 116, 32, 105, 115, 32, 97, 119, 101, 115, 111, 109, 101]
     return base64.encode(bytesInLatin1);
  }

  String _decodeImage(String image){
    // decoding
    var bytesInLatin1_decoded = base64.decode(image);
// [68, 97, 114, 116, 32, 105, 115, 32, 97, 119, 101, 115, 111, 109, 101]

    return latin1.decode(bytesInLatin1_decoded);

  }
}
