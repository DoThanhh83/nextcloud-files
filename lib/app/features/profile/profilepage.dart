import 'package:file_man/app/constans/app_constants.dart';
import 'package:file_man/app/shared_components/silverwithbox.dart';
import 'package:file_man/app/utils/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nextcloud/provisioning_api.dart';


typedef Quota = UserDetailsQuota;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Future<void> logout() async {
    setState(() {
      ApiPath.clearURLData();
      ApiPath.clearUserData();
      ApiPath.clearPassData();

    });

  }

  String? displayName;
  String? Address;
  String? Email;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    if (Global.user != null) {
      final response = Global.user!.getCurrentUser();
      displayName = Global.displayName;
      Address = Global.Address;
      Email = Global.Email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        automaticallyImplyLeading: false,
        title: Text("My profile"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverWidthBox(
            width: 350,
            sliver: SliverList.list(
              children: [
                const SizedBox(height: 16),
                if (Global.pfp == null)
                  const Icon(Icons.account_circle, size: 48 * 2)
                else
                  Center(
                    child: ClipPath(
                      clipper: ShapeBorderClipper(
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(40 * 2),
                        ),
                      ),
                      child: Image.memory(
                        Global.pfp!,
                        width: 48 * 2,
                        height: 48 * 2,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Center(child: Text(displayName ?? "--")),
                const SizedBox(height: 16),
                Center(child: Text(Email ?? "--")),
                const SizedBox(height: 16),
                Center(child: Text(Address ?? "--")),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    logout();
                    Navigator.of(context).pop();
                  },
                  child: Text("Đăng xuất"),
                ),
                const SizedBox(height: 16),
                Text("Links"),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    TextButton(
                      onPressed: () {
                        var link = NextcloudClientExtension.defaultNextcloudUri;
                        print(link);
                        launchUrl(link);
                      },
                      child: Text("Server HomePage"),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     var link = NextcloudClientExtension.Url_default;
                    //     showDialog(
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         return AlertDialog(
                    //           title: Text("Thông báo"),
                    //           content: Text(
                    //               "Đã bấm vào $link"),
                    //           actions: <Widget>[
                    //             TextButton(
                    //               child: Text("Đóng"),
                    //               onPressed: () {
                    //                     Navigator.pop(context);
                    //               },
                    //             ),
                    //           ],
                    //         );
                    //       },
                    //       // launchUrl(
                    //     //   Uri.parse(
                    //     //       '${link}/index.php/settings/user/drop_account'),
                    //     );
                    //   },
                    //   child: Text("Xóa tài khoản"),
                    // ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

        ],
      ),
    );
  }
}