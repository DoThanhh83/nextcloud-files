import 'dart:convert';
import 'dart:io';

import 'package:file_man/app/constans/app_constants.dart';
import 'package:file_man/app/features/login/login.dart';
import 'package:file_man/app/utils/model/crsftoken.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class QuenMatKhauPage extends StatefulWidget {
  const QuenMatKhauPage({Key? key}) : super(key: key);

  @override
  State<QuenMatKhauPage> createState() => _QuenMatKhauPageState();
}

class _QuenMatKhauPageState extends State<QuenMatKhauPage> {
  TextEditingController url = TextEditingController(text: "");

  Future<void> quenMatKhau() async {
    CsrfToken? tokens = CsrfToken();
      Uri url_getToken = Uri.parse("${ApiPath.BASE_URL}/csrftoken");
      Uri url_lost_pass = Uri.parse("${ApiPath.BASE_URL}/lostpassword/email");

      // Fetch the CSRF token
      final tokenResponse = await http.get(url_getToken);
      if (tokenResponse.statusCode != 200) {
        print("get token fail");
        return;
      }
      final tokenData = jsonDecode(tokenResponse.body);
      final token = CsrfToken.fromJson(tokenData);

      // Fetch the cookies
      final cookie = tokenResponse.headers['set-cookie'];

      var header =  {
        'Origin': '${ApiPath.BASE_URL}',
        'X-Requested-With': 'XMLHttpRequest',
        'Requesttoken': '${token.token ?? ""}',
        'Cookie': cookie!,
      };

      var request = http.MultipartRequest('POST', url_lost_pass);
      request.fields.addAll({
        'user': '${url.text}'
      });
      request.headers.addAll(header);

      http.StreamedResponse value = await request.send();

      if (value.statusCode == 200) {
        print(await value.stream.bytesToString());
      }
      else {
        print(value.reasonPhrase);
      }
      if (value.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Thông báo"),
              content: Text(
                  "Thông báo lấy lại mật khẩu đã được chuyển đến địa chỉ email."),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Xác nhận")),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Thông báo"),
              content: Text("Thông báo lấy lại mật khẩu đã được chuyển đến địa chỉ email"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Xác nhận")),
              ],
            );
          },
        );
      }

  }
  // Future<void> quenMatKhau() async {
  //   CsrfToken? tokens = CsrfToken();
  //   Uri base = Uri.parse(ApiPath.BASE_URL);
  //   Uri url_getToken = Uri.parse("${ApiPath.BASE_URL}/csrftoken");
  //   Uri url_lost_pass = Uri.parse("${ApiPath.BASE_URL}/lostpassword/email");
  //
  //   // Create a client with automatic redirects
  //   var client = http.Client();
  //   // Fetch the CSRF token
  //   final tokenResponse = await client.get(url_getToken);
  //   if (tokenResponse.statusCode != 200) {
  //     print("get token fail");
  //     return;
  //   }
  //   final tokenData = jsonDecode(tokenResponse.body);
  //   final token = CsrfToken.fromJson(tokenData);
  //
  //   // Fetch the cookies
  //   final cookie = tokenResponse.headers['set-cookie'];
  //
  //   var header = {
  //     'Requesttoken': '${token.token ?? ""}',
  //     HttpHeaders.cookieHeader: cookie!,
  //     HttpHeaders.contentTypeHeader: 'application/json',
  //     'X-Requested-With': 'XMLHttpRequest',
  //     // 'Accept': 'application/json'
  //   };
  //
  //   Map<String, String> header2 = {
  //     'Requesttoken': '${token.token ?? ""}',
  //     HttpHeaders.cookieHeader: cookie,
  //     'X-Requested-With': 'XMLHttpRequest',
  //     HttpHeaders.acceptHeader: 'application/json',
  //   };
  //
  //   var clients = http.Client();
  //   var request = http.Request('POST', url_lost_pass, )
  //     ..headers.addAll(header)
  //     ..body = jsonEncode({"user": "qqwertythanh@gmail.com"});
  //
  //   var streamedResponse = await clients.send(request);
  //   var response = await http.Response.fromStream(streamedResponse);
  //
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //   } else if (response.statusCode == 302) {
  //     var location = response.headers['location'];
  //     if (location != null) {
  //       var redirectUrl = Uri.parse("${ApiPath.BASE_URL}$location");
  //       launchUrl(redirectUrl);
  //       var redirectResponse = await http.post(redirectUrl,
  //           headers: header2,
  //           body: jsonEncode({"user": "qqwertythanh@gmail.com"}));
  //       print('Redirect response: ' + redirectResponse.body);
  //
  //     }
  //   } else {
  //     print(response.reasonPhrase! +
  //         response.statusCode.toString() +
  //         response.body);
  //   }
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            SizedBox(
              height: 30,
            ),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage("assets/images/raster/ncicon.jpg"),
                    fit: BoxFit.cover,
                  )),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: grey.withOpacity(0.03),
                        spreadRadius: 10,
                        blurRadius: 3,
                        // changes position of shadow
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 15, bottom: 5, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email đăng kí ",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Color(0xff67727d)),
                      ),
                      TextField(
                        controller: url,
                        cursorColor: black,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: black),
                        onChanged: ((value) {
                          setState(() {});
                        }),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_2_outlined),
                            prefixIconColor: black,
                            hintText: "",
                            border: InputBorder.none),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                quenMatKhau();
              },
              child: Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                    color: buttoncolor,
                    borderRadius: BorderRadius.circular(25)),
                child: Center(
                  child: Text(
                    "Lấy lại mật khẩu ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
