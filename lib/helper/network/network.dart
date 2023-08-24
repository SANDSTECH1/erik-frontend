import 'package:erick/features/onboarding/viewmodel/loginviewmodel.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper {
  getApi(
    String url,
  ) async {
    // final query = params?.entries.map((e) => '${e.key}=${e.value}').join('&');
    final response = await http.get(
      // Uri.parse('$url?$query'),
      Uri.parse(url),
      headers: {
        'x-access-token': userToken,
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    print(userToken);
    print(response.body);
    return response;
  }

  postApi(String url, data) async {
    String jsondata = json.encode(data);

    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'x-access-token': userToken,
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsondata);
      print(response.body);

      return response;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  postFormApi(String url, data, file) async {
    var postUri = Uri.parse(url);
    var request = http.MultipartRequest("POST", postUri);
    request.fields['user'] = 'blah';
    data.forEach((key, value) {
      request.fields['$key'] = value;
    });
    final headers = {'x-access-token': userToken};
    request.headers.addAll(headers);
    for (var i = 0; i < file.length; i++) {
      var multipartFile = await http.MultipartFile.fromPath(
          'images', file[i].path,
          filename: file[i].path.split('/').last,
          contentType: MediaType("image", "${file[i].path.split('.').last}"));
      request.files.add(multipartFile);
    }
    var response = await request.send();
    final res = await http.Response.fromStream(response);

    if (res.statusCode == 200) {
      var resData = json.decode(res.body.toString());
      return resData;
    }
  }

  mediaFormUpload(String url, data, file, type) async {
    print(url);
    var postUri = Uri.parse(url);
    var request = http.MultipartRequest("POST", postUri);
    request.fields['user'] = 'blah';
    data.forEach((key, value) {
      request.fields['$key'] = value;
    });
    final headers = {'x-access-token': userToken};
    request.headers.addAll(headers);
    var multipartFile = await http.MultipartFile.fromPath(
        // file.path.split('.').last.toString().toUpperCase() == "MOV"
        //     ? "video"
        //     : file.path.split('.').last.toString().toUpperCase() == "MP4"
        //         ? "video"
        //         : "image",
        type,
        file.path,
        filename: file.path.split('/').last,
        contentType: MediaType(
            file.path.split('.').last.toString().toUpperCase() == "MOV"
                ? "video"
                : file.path.split('.').last.toString().toUpperCase() == "MP4"
                    ? "video"
                    : "image",
            "${file.path.split('.').last}"));
    request.files.add(multipartFile);
    var response = await request.send();
    final res = await http.Response.fromStream(response);
    print(res.body);
    if (res.statusCode == 200 || res.statusCode == 500) {
      var resData = json.decode(res.body.toString());
      return resData;
    }
  }

  Future<http.Response> putApi(String url, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'x-access-token': userToken,
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    print(userToken);
    print(response.body);
    return response;
  }

  Future<http.Response> deleteApi(String url) async {
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'x-access-token': userToken,
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    print(userToken);
    print(response.body);
    return response;
  }
}

class ApiUrls {
  static const String baseUrl = "http://localhost:4000/api/v1";

  //For Users
  String login = "$baseUrl/userLogin";
  String forgetpass = "$baseUrl/forgetPassword";
  String otp = "$baseUrl/verifyOtp";
  String resetpass = "$baseUrl/resetPassword";
  String putimage = "$baseUrl/updateImage";
  String createtask = "$baseUrl/createtask";
  String getuser = "$baseUrl/getUser";
  String gettask = "$baseUrl/gettask";
  String updatetask = "$baseUrl/updatetask";
  String deletetask = "$baseUrl/deletetask";
  String createsubtask = "$baseUrl/createsubtask";
  String getsubtasks = "$baseUrl/getsubtask";
  String deletesubtasks = "$baseUrl/deleteSubTask";
  String updatesubtasks = "$baseUrl/updateSubTask";
  String getTaskByDate = "$baseUrl/getTaskByDate";
  String generateTaskPdf = "$baseUrl/generatepdftask";
  String generateSubTaskPdf = "$baseUrl/generatepdfsubtask";
}
