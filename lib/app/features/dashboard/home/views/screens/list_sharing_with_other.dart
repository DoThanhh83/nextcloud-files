import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_man/app/constans/app_constants.dart';
import 'package:file_man/app/features/dashboard/home/views/screens/preview_markdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nextcloud/files.dart';
import 'package:nextcloud/files_sharing.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/webdav.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;
import 'package:fluttertoast/fluttertoast.dart';

class ListSharingWithOthers extends StatefulWidget {
  final String? url;
  final String? previsionUrl;
  final bool wantBack;
  final String? title;
  final NextcloudClient? client;

  const ListSharingWithOthers(
      {Key? key,
      this.url,
      this.title,
      this.previsionUrl,
      this.wantBack = false,
      this.client})
      : super(key: key);

  @override
  State<ListSharingWithOthers> createState() => _FileListScreenState();
}

class _FileListScreenState extends State<ListSharingWithOthers> {
  late webdav.Client client;
  late NextcloudClient cli;

  String url = ApiPath.BASE_URL + '/remote.php/dav/files/admin/';
  final user = 'admin';
  final pwd = 'admin';
  final dirPath = '/';
  String? temp;

  @override
  void initState() {
    super.initState();
    loadData();

    // ApiPath.loadFiles(cli);
  }

  void loadData() {
    if (widget.previsionUrl != null) {
      temp = widget.previsionUrl!;
      url = url + temp!;
    }
    // init client
    cli = NextcloudClient(Uri.parse(ApiPath.BASE_URL),
        loginName: 'admin', password: 'admin');
    client = webdav.newClient(
      url,
      user: user,
      password: pwd,
      debug: true,
    );
  }

  Future<Uint8List?>? getThumnails(String? name) async {
    final cli = NextcloudClient(Uri.parse(ApiPath.BASE_URL),
        loginName: 'admin', password: 'admin');
    if (name!.startsWith('/')) {
      name = name.substring(1);
    }
    final file = cli.files.api.getThumbnail(x: 10, y: 10, file: name );
    return await file.then((value) {
      print("value body");
      // print(value.body);
      return value.body;
    });
  }

  Future<Uint8List?>? getContent(String? name) async {
    if (name!.startsWith('/')) {
      name = name.substring(1);
    }
    PathUri pathUri = PathUri.parse(name);
    final file = cli.webdav.get(pathUri);
    return await file.then((value) {
      print("value Contetn body");
      return value;
    });
  }

  Future<List<webdav.File>> _getData() {
    return client.readDir(dirPath);
  }

  Future<void> shareFile(String path, String userName) async {
    ///permission 19 : can edit
    final fileShare = await cli.filesSharing.shareapi.createShare(
        path: path.substring(1),
        permissions: 19,
        shareType: 0,
        shareWith: userName);
    if (fileShare.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Chia sẻ thành công",
      );
    } else {
      Fluttertoast.showToast(msg: "Đã có lỗi!");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty || user.isEmpty || pwd.isEmpty) {
      return const Center(child: Text("you need add url || user || pwd"));
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.wantBack,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title ?? "Sharing with Me",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(width: 10),
            widget.title == null
                ? SizedBox(
                    width: 20,
                    child:
                        Image.asset(ImageRaster.logoNC, height: 20, width: 20),
                  )
                : Container(),
            Spacer(),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                loadData();
              },
              icon: Icon(Icons.rotate_left)),

        ],
      ),
      body: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context,
              AsyncSnapshot<List<webdav.File>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return _buildListView(context, snapshot.data ?? []);
            }
          }),
    );
  }

  Widget _buildListView(BuildContext context, List<webdav.File> list,
      {String? image}) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final file = list[index];
          return FutureBuilder(
            future: getThumnails(file.path),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.error != null) {
                /// nếu không lấy được Thumbnail
                return ListTile(
                    leading: file.isDir == true
                        ? SvgPicture.asset(
                            ImageVector.folder,
                            height: 40,
                          )
                        : snapshot.data != null
                            ? Image.memory(
                                snapshot.data as Uint8List,
                                height: 20,
                                width: 20,
                              )
                            : file.name!.endsWith(".docx")
                                ? Icon(CustomIcons.ms_word)
                                : Icon(Icons.file_present_rounded),
                    title: Text(file.path ?? ''),
                    trailing: InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.share,
                          size: 20,
                        )),
                    subtitle: Text(file.mTime.toString()),
                    onTap: () async {});
              } else {
                return ListTile(
                  leading: file.isDir == true
                      ? SvgPicture.asset(
                          ImageVector.folder,
                          height: 30,
                        )
                      : snapshot.data != null
                          ? Image.memory(snapshot.data as Uint8List)
                          : file.name!.endsWith(".docx")
                              ? Icon(CustomIcons.ms_word)
                              : Icon(Icons.file_present_rounded),
                  title: Text(file.path ?? ''),
                  subtitle: Text(file.mTime.toString()),
                  trailing: InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.share,
                        size: 20,
                      )),
                  onTap: () async {},
                );
              }
            },
          );
        });
  }

  void downloadAndOpenFile(webdav.File file, String direcPath) async {
    if (file.name!.endsWith('.md')) {
      var datas = await getContent(file.path);
      var acb = datas as Uint8List;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewMarkdown(
                    title: file.name,
                    data: acb,
                  )));
    } else {
      PathUri path = PathUri.parse(direcPath);
      final bytes = await cli.webdav.get(path);
      final dir = await getApplicationDocumentsDirectory();
      final localFile = File('${dir.path}/${file.name}');
      await localFile.writeAsBytes(bytes);

      // Open the file
      OpenFile.open(localFile.path);
    }
  }
}
