import 'dart:convert';

import 'package:file_man/app/constans/app_constants.dart';
import 'package:file_man/app/features/login/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/provisioning_api.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late NextcloudClient client;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    client = NextcloudClient(Uri.parse(ApiPath.BASE_URL),
        loginName: 'admin', password: 'admin');
  }

  void dangkinew() {
    // POST http://192.168.1.13:8080/apps/registration/register/{token lay từ emial}
  }

  Future<void> SignUp() async {
    if (namecontroller.text.isEmpty) {
      Fluttertoast.showToast(msg: "Hãy nhập tên");
    }
    if (passcontroller.text.isEmpty) {
      Fluttertoast.showToast(msg: "Hãy nhập mật khẩu");
    }
    if (emailcontroller.text.isEmpty) {
      Fluttertoast.showToast(msg: "Hãy nhập email");
    }
    if (!namecontroller.text.isEmpty &&
        !passcontroller.text.isEmpty &&
        !emailcontroller.text.isEmpty) {
      final value = await client.provisioningApi.users.$addUser_Request(
          userid: "${namecontroller.text}",
          password: "${passcontroller.text}",
          displayName: "${namecontroller.text}",
          email: "${emailcontroller.text}",
          quota: "1 GB");

      final requets = await client.provisioningApi.httpClient.send(value);

      if (requets.statusCode == 200) {
        Fluttertoast.showToast(msg: "Đăng ký thành công");
        Navigator.pop(context);
      } else {
        // final _serializer = client.provisioningApi.users.$getUser_Serializer();
        // final _rawResponse = await _i1.ResponseConverter<dynamic, void>(_serializer)
        //     .convert(requets);
        final body = await requets.stream.bytesToString();
        Map<String, dynamic> jsonObject = jsonDecode(body);
        String message = jsonObject['ocs']['meta']['message'];

        // final messs = body['ocs']['meta']['message'];
        Fluttertoast.showToast(msg: "${message}", timeInSecForIosWeb: 4);
      }
      // );
    }
  }

  final emailcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  final mobilecontroller = TextEditingController();
  final passcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final emailField = InputText(
      "Email",
      emailcontroller,
      Icons.email,
      (p0) {},
    );

    final name = InputText(
      "Username",
      namecontroller,
      Icons.person,
      (p0) {},
    );

    final mobile = InputText(
      "Số điện thoại ",
      mobilecontroller,
      Icons.phone,
      (p0) {},
    );

    final passwordField = InputText(
      "Password",
      passcontroller,
        Icons.lock,
      (p0) {},
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
      color: buttoncolor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(50.0, 15.0, 50.0, 15.0),
        onPressed: () {
          SignUp();
        },
        child: Text(
          "Đăng ký",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Đăng ký tài khoản")),
      body: SingleChildScrollView(
        child: Container(
          color: primary,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 45.0),
                emailField,
                SizedBox(height: 25.0),
                name,
                SizedBox(height: 25.0),
                mobile,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButon,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget InputText(String title, TextEditingController controller, IconData icon,
      Function(String)? onChanged) {
    return Container(
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
          padding:
              const EdgeInsets.only(left: 20, top: 15, bottom: 5, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Color(0xff67727d)),
              ),
              TextField(
                controller: controller,
                cursorColor: black,
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w500, color: black),
                onChanged: onChanged ??
                    (value) {
                      print("chua nhạn dc");
                    },
                decoration: InputDecoration(
                    prefixIcon: Icon(icon),
                    prefixIconColor: black,
                    hintText: "Nhập $title",
                    border: InputBorder.none),
              ),
            ],
          ),
        ));
  }
}
