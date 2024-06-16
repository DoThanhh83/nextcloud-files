import 'package:file_man/app/utils/model/userstatus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/user_status.dart';

import '../../../../../utils/global.dart';

class ListUser extends StatefulWidget {
  final NextcloudClient cli;

  final Function(String userName)? onDone;

  ListUser({Key? key, this.onDone, required this.cli}) : super(key: key);

  @override
  State<ListUser> createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  // List<String> users = [];
  List<UserStatus> users = [];
  List<UserStatus> tempusers = [];
  String search = '';
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData(null);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  Future<void> loadData(String? search) async {
      var datt1;
      if (search == null) {
        datt1 = widget.cli.userStatus.statuses.findAll();
      } else {
        datt1 = widget.cli.userStatus.statuses.find(userId: search);
      }
      await datt1.then((value) {
        setState(() {
          var val = value.body.toJson();
          print(val);
          List data = val['ocs']['data'];
          List<UserStatus> abc =
          data.map((item) => UserStatus.fromJson(item)).toList();
          users =
              abc.where((element) => element.userId != Global.userName).toList();
          tempusers = users;
        });
      });
    // final data = widget.cli.provisioningApi.users.getUsers(search: search);
    // var abc;
    // data.then((value) {
    //   setState(() {
    //     // abc = value.body.toJson();
    //     // users = List<String>.from(abc['ocs']['data']['users']);
    //     // for(var name in users){
    //     //  if(name == Global.userName){
    //     //    users.remove(name);
    //     //  }
    //     // }
    //     abc = value.body.toJson();
    //     users = List<String>.from(abc['ocs']['data']['users']);
    //     users = users.where((name) => name != Global.userName).toList();
    //   });
    // });
  }
 void searchUser(String? search) {
    if(search != ""){
      users = users.where((element) => element.userId!.contains(search as Pattern)).toList();
    }
    else{
     users = List.from(tempusers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Danh sách người dùng'),
        ),
        body: users.length > 0
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                          labelText: 'Search',
                          hintText: 'Nhập tên người dùng ',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                      onChanged: (text) {
                        setState(() {
                         searchUser(text);
                        });
                      },

                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('${index + 1}.${users[index].userId}'),
                          onTap: () {
                            widget.onDone?.call(users[index].userId.toString());
                            // Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
