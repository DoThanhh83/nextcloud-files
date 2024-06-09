import 'package:file_man/app/constans/app_constants.dart';
import 'package:file_man/app/features/login/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class QuenMatKhauPage extends StatefulWidget {
  const QuenMatKhauPage({Key? key}) : super(key: key);

  @override
  State<QuenMatKhauPage> createState() => _QuenMatKhauPageState();
}

class _QuenMatKhauPageState extends State<QuenMatKhauPage> {
  TextEditingController url = TextEditingController(text: "");

  void quenMatKhau() {
    Uri urls = Uri.parse("${ApiPath.BASE_URL}/lostpassword/email");
    final sendRequest = http.post(urls, body: {"user": "${url.text}"});
    sendRequest.then((value) {
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
      }
      else{
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Thông báo"),
              content: Text(
                  "Đã có lỗi "),
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
    });
  }

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
