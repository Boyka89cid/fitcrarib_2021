import 'dart:convert';
//import 'dart:io';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:fitcarib/base/model/base_model.dart';
import 'package:fitcarib/constants.dart';

class ServerAPI {
  static final ServerAPI _singleton = new ServerAPI._internal();

  String? token;

  Encrypter? encrypter;

  factory ServerAPI(){return _singleton;}

  final Dio dio=Dio();

  ServerAPI._internal()
  {
    // dio.onHttpClientCreate = ((client) {
    //   client.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) {
    //     return certificateAllow;
    //   });
    // });
    //final Dio dio=Dio();
    dio.options.baseUrl = baseURLStaging;
    dio.options.connectTimeout = connectTimeout;
    dio.options.receiveTimeout = connectTimeout;
    dio.interceptors.add(InterceptorsWrapper(
        onRequest:(options, handler)
        {
          print("OP->${options.data?.toString()}");
          print("OP->${options.extra.toString()}");
          print("OP->${options.headers}");
          print("OP->${options.path}");
          print("OP->${options.contentType}");
          print("OP->${options.responseType}");
          return handler.next(options);
        },
        onResponse:(response,handler)
        {
          print("REs->$response");
          return handler.next(response);
        },
        onError: (DioError e, handler)
        {
          return  handler.next(e);
        }
    ));
    /*dio.interceptors.request.onSend = (Options options)
    {
      // Do something before request is sent
      print("OP->${options.data?.toString()}");
      print("OP->${options.extra?.toString()}");
      print("OP->${options.headers}");
      print("OP->${options.path}");
      print("OP->${options.contentType}");
      print("OP->${options.responseType}");
      return options;
      // If you want to resolve the request with some custom data，
      // you can return a `Response` object or return `dio.resolve(data)`.
      // If you want to reject the request with a error message,
      // you can return a `DioError` object or return `dio.reject(errMsg)`
    };*/
    /*dio.interceptor.response.onSuccess = (Response response) {
      // Do something with response data
      print("REs->$response");
      return response; // continue
    };*/
    /*dio.interceptor.response.onError = (DioError e) {
      // Do something with response error
      return e; //continue
    };*/

    encrypter =Encrypter(Salsa20(Key.fromLength(32))); //edited
  }

  String encode(BaseModel model)
  {
    final iv = IV.fromLength(8);  //edited
    String s = json.encode(model.toMap());
    return encrypter!.encrypt(s,iv:iv).toString();
  }

  dynamic decode(String data)
  {
    String s = encrypter!.decrypt(data as Encrypted);  //edited
    return json.decode(s);
  }

  // Future<dynamic> register(
  //     String mobile, String password, String name, String agreeToc) async {
  //   FormData formData = new FormData.from({
  //     "mobile": mobile,
  //     "password": password,
  //     "name": name,
  //     "agree_toc": agreeToc
  //   });
  //   try {
  //     Response response = await dio.post("users/register", data: formData);
  //     return RegisterResponse.fromJSON(response.data);
  //   } on DioError catch (e) {
  //     return ErrorResponse.fromJSON(parseError(e));
  //   }
  // }

  // void sample(String mobile, String password) async {
  //   FormData formData =
  //       new FormData.from({"mobile": mobile, "password": password});

  //   try {
  //     Response res = await dio.post('users/login', data: formData);
  //   } on DioError catch (e) {}
  // }



  // void loginSuccess(String token) {
  //   Map<String, dynamic> headers = Map();
  //   headers["Authorization"] = token;
  //   dio.options.headers = headers;
  //   print("TOKEN->$token");
  //   this.token = token;
  // }

  // void logout() {
  //   dio.options.headers = Map();
  // }


 

  // Future<String> forgotPassword(String mobile) async {
  //   FormData formData = new FormData.from({"mobile": mobile});

  //   try {
  //     Response response =
  //         await dio.put('users/forgot_password', data: formData);
  //     if (response.statusCode == 200) {
  //       return "Success";
  //     } else {
  //       return "Error";
  //     }
  //   } on DioError catch (e) {
  //     return parseError(e);
  //   }
  // }



  // Future<dynamic> getGeoIp() async {
  //   try {
  //     Response response = await dio.get('users/geoip',
  //         options: new Options(headers: {"GeoipKey": "fsdy87yasrhtht98"}));

  //     return GeoIpResponse.fromJSON(response.data);
  //   } on DioError catch (e) {
  //     return parseError(e);
  //   }
  // }


  // Future<dynamic> dashBoard() async {
  //   try {
  //     Response res = await dio.get('users/dashboard');
  //     return DashboardResponse.fromJSON(res.data);
  //   } on DioError catch (e) {
  //     return ErrorResponse.fromJSON(parseError(e));
  //   }
  // }

 

  // Future<dynamic> downloadFile(String path, String filePath) async {
  //   try {
  //     Response res = await dio.download(path, filePath);
  //     return res.data;
  //   } on DioError catch (e) {
  //     return ErrorResponse.fromJSON(parseError(e));
  //   }
  // }



  // Future<dynamic> deleteJobPost(int id) async {
  //   try {
  //     Response res = await dio.delete('jobs/$id');
  //     if (res.statusCode == 200)
  //       return "Success";
  //     else
  //       return "Error";
  //   } on DioError catch (e) {
  //     return ErrorResponse.fromJSON(parseError(e));
  //   }
  // }

  // Future<dynamic> addUpdateResume(Resume resume) async {
  //   UploadAPI uploadAPI = UploadAPI();
  //   try {
  //     final response = resume.id == null
  //         ? await uploadAPI.upload(dio.options.baseUrl + "resumes", "file",
  //             File(resume.file), token, {"title": resume.title}, 'POST')
  //         : await uploadAPI.upload(dio.options.baseUrl + "resumes/${resume.id}",
  //             "file", File(resume.file), token, {"title": resume.title}, 'PUT');
  //     final data = json.decode(response.body);
  //     if (data != null &&
  //         data["error"] != null &&
  //         data["error"]["message"] != null) {
  //       return data["error"]["message"];
  //     } else if (data != null)
  //       return Resume.fromJSON(data);
  //     else
  //       return "Some Error has Occurred";
  //   } catch (e) {
  //     return parseError(e);
  //   }
  // }

  

  // Future<dynamic> uploadAvatar(File file) async {
  //   try {
  //     final fileName = basename(file.path);
  //     final contentType = ContentType.parse("image/jpeg");
  //     print("MIM->${contentType.mimeType}");
  //     FormData formData = FormData.from(<String, dynamic>{
  //       "file":
  //           UploadFileInfo(File(file.path), fileName, contentType: contentType)
  //     });

  //     final response = await dio.post('intro/upload_avatar',
  //         data: formData,
  //         options: Options(
  //           contentType: contentType,
  //           headers: {
  //             "Authorization": token,
  //             "content-type": "multipart/form-data"
  //           },
  //           followRedirects: true,
  //           responseType: ResponseType.JSON,
  //         ));
  //     return response.data["avatar_url"];
  //   } on DioError catch (e) {
  //     return parseError(e);
  //   }
  // }

  

  // Future<dynamic> exportContacts(ExportContacts contacts) async {
  //   // FormData formData = new FormData.from(contacts.toMap());
  //   try {
  //     var dd = [];

  //     for (var d in contacts.data) {
  //       var emails = [];
  //       d.emails.forEach((e) {
  //         if (e != null) emails.add({"label": e.label, "value": e.value});
  //       });
  //       var phones = [];
  //       d.phones.forEach((e) {
  //         if (e != null) phones.add({"label": e.label, "value": e.value});
  //       });

  //       var postalAddresses = [];
  //       d.postalAddresses.forEach((e) {
  //         if (e != null)
  //           postalAddresses.add({
  //             "label": e.label,
  //             "city": e.city,
  //             "country": e.country,
  //             "postcode": e.postcode,
  //             "region": e.region,
  //             "street": e.street,
  //           });
  //       });

  //       var ad = {
  //         "company": d.company,
  //         "displayName": d.displayName,
  //         "familyName": d.familyName,
  //         "givenName": d.givenName,
  //         "identifier": d.identifier,
  //         "jobTitle": d.jobTitle,
  //         "middleName": d.middleName,
  //         "prefix": d.prefix,
  //         "emails": emails,
  //         "phones": phones,
  //         "postalAddresses": postalAddresses,
  //       };
  //       dd.add(ad);
  //     }

  //     final dio1 = Dio();
  //     dio1.onHttpClientCreate = ((client) {
  //       client.badCertificateCallback =
  //           ((X509Certificate cert, String host, int port) {
  //         return certificateAllow;
  //       });
  //     });

  //     final response = await dio1.post('contacts',
  //         options: Options(
  //             contentType: ContentType.text,
  //             headers: {
  //               "Content-Type": "application/json",
  //               "Authorization": token
  //             },
  //             baseUrl: dio.options.baseUrl,
  //             data: json.encode({
  //               "operating_system": contacts.operating_system,
  //               "operating_system_version": contacts.operating_system_version,
  //               "data": dd
  //             })));
  //     if (response.statusCode == 200) {
  //       return true;
  //     } else
  //       return false;
  //   } on DioError catch (e) {
  //     return parseError(e);
  //   }
  // }

 
  dynamic parseError(e) {
    try {
      print("Error--->$e");
      final data = e.response?.data;

      if (data != null) {
        if (data['error'] != null) {
          if (data['error']['payload'] != null) {
            return data['error']['payload'];
          }
          if (data['error']['message'] != null) {
            return data['error']['message'];
          }
        }
        if (data["errors"] != null) {
          return data["errors"]["message"];
        }
      }
      if (e.message != null) {
        return e.message;
      } else
        return "Some Error has occurred";
    } catch (e1) {
      return "Some Error has occurred";
    }
  }
}
