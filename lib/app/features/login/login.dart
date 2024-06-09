import 'package:disk_space/disk_space.dart';
import 'package:file_man/app/config/routes/app_pages.dart';
import 'package:file_man/app/constans/app_constants.dart';
import 'package:file_man/app/features/login/ForgotPassWord.dart';
import 'package:file_man/app/features/login/signup.dart';
import 'package:file_man/app/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/provisioning_api.dart';

const Color primary = Color(0xfff2f9fe);
const Color secondary = Color(0xFFdbe4f3);
const Color black = Color(0xFF000000);
const Color white = Color(0xFFFFFFFF);
const Color grey = Colors.grey;
const Color red = Color(0xFFec5766);
const Color green = Color(0xFF43aa8b);
const Color blue = Color(0xFF28c2ff);
const Color buttoncolor = Color(0xff3e4784);
const Color mainFontColor = Color(0xff565c95);
const Color arrowbgColor = Color(0xffe4e9f7);

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: new Builder(
          builder: (context) => new Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorLight
                ])),
            child: Padding(
              padding: EdgeInsets.only(top: 40.0),
              //Sets the main padding all widgets has to adhere to.
              child: LogInPage(),
            ),
          ),
        ));
  }
}

class LogInPage extends StatefulWidget {
  LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController url = TextEditingController(text: "");
  TextEditingController _email = TextEditingController(text: "");
  TextEditingController password = TextEditingController(text: "");
  bool showPass = true;
  bool signing = false;

  Future<bool> signIn() async {
    try {
      setState(() {
        signing = true;
      });
      print(_email.text + password.text);
      final client = await  NextcloudClient(
        Uri.parse(url.text),
        loginName: _email.text,
        password: password.text,
      );
      setState(() {
        signing = false;
      });
      final response = await client.provisioningApi.users.getCurrentUser();
      setState(() {
        Global.client = client;
        Global.displayName = response.body.ocs.data.displayName;
        Global.Address = response.body.ocs.data.address;
        Global.Email = response.body.ocs.data.email;
        Global.user = client.provisioningApi.users;
      });
      print("đa login ");

      ApiPath.savePassData(password.text);
      ApiPath.saveURLData(url.text);
      ApiPath.saveUserData(_email.text);

      return true;
    } catch (e) {
      print("Đã có lõi : ${e.toString()}");
      Fluttertoast.showToast(msg: "Đã có lõi : ${e.toString()}");
      setState(() {
        signing = false;
      });
      return false;
    }
  }
  void quenmatkhau() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> QuenMatKhauPage()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ApiPath.readUserData().then((value) {
      setState(() {
        _email = TextEditingController(text: "$value");
        Global.userName = value;
      });
    });
    ApiPath.readPassData().then((value) {
      setState(() {
        password = TextEditingController(text: "$value");
        Global.password = value;
      });
    });

    ApiPath.readURLData().then((value) {
      setState(() {
        url = TextEditingController(text: "$value");
        ApiPath.BASE_URL = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: getBody(),
    );
  }

  Widget getBody() {
    return SafeArea(
        child: signing
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primary,
                          image: DecorationImage(
                            image: AssetImage("assets/images/raster/ncicon.jpg"),
                            fit: BoxFit.contain,scale: 1.5
                          ),),
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
                                  "Server Name",
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
                                    setState(() {
                                      ApiPath.BASE_URL = value;
                                    });
                                  }),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.electrical_services),
                                      prefixIconColor: black,
                                      hintText: "http://...",
                                      border: InputBorder.none),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 20,
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
                                  "User Name",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Color(0xff67727d)),
                                ),
                                TextField(
                                  controller: _email,
                                  cursorColor: black,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: black),
                                  onChanged: ((value) {
                                    setState(() {
                                      Global.userName = value;
                                    });
                                  }),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.person_2_outlined),
                                      prefixIconColor: black,
                                      hintText: "username",
                                      border: InputBorder.none),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 20,
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
                                  "Password",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Color(0xff67727d)),
                                ),
                                TextField(
                                  obscureText: showPass,
                                  controller: password,
                                  cursorColor: black,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: black),
                                  onChanged: ((value) {
                                    setState(() {
                                      Global.password = value;
                                    });
                                  }),
                                  decoration: InputDecoration(
                                      prefixIcon:
                                          Icon(Icons.lock_outline_rounded),
                                      prefixIconColor: Colors.black,
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              showPass = !showPass;
                                            });
                                          },
                                          child: showPass
                                              ? Icon(Icons.visibility)
                                              : Icon(Icons.visibility_off)),
                                      suffixIconColor: Colors.black,
                                      hintText: "Password",
                                      border: InputBorder.none),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await DiskSpace.getFreeDiskSpace.then((value) {
                            setState(() {
                              Global.StoragaFree = value!;
                            });
                          });
                          await DiskSpace.getTotalDiskSpace.then((value) {
                            setState(() {
                              Global.StoragTotal = value;
                            });
                          });
                          if (_email.text.length < 2 ||
                              password.text.length < 2) {
                            Fluttertoast.showToast(
                                msg: "Không được bỏ trống Username và Mật khẩu",
                                timeInSecForIosWeb: 2);
                          } else {
                             signIn().then((value) {
                              if (value == true) {
                                Get.toNamed(Routes.dashboard);
                              }
                            });
                          }
                          // Get.toNamed(Routes.dashboard);
                        },
                        child: Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                              color: buttoncolor,
                              borderRadius: BorderRadius.circular(25)),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 26.0, right: 26.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpPage()));
                              },
                              child: Text(
                                "Signup",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                quenmatkhau();
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }


}

class SocialIcon extends StatelessWidget {
  final IconData iconData;

  SocialIcon({required this.iconData});

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.only(),
      child: Container(
        width: 40.0,
        height: 40.0,
        child: RawMaterialButton(
          shape: CircleBorder(),
          onPressed: () {},
          child: Icon(iconData, color: Colors.white),
        ),
      ),
    );
  }
}
