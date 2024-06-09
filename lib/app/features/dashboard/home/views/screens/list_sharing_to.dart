import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_man/app/constans/app_constants.dart';
import 'package:file_man/app/features/dashboard/home/views/screens/preview_markdown.dart';
import 'package:file_man/app/utils/model/file_sharing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud/files.dart';
import 'package:nextcloud/files_sharing.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/webdav.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dynamite_runtime/http_client.dart' as _i1;

class ListSharingTo extends StatefulWidget {
  final String? url;
  final String? previsionUrl;
  final bool wantBack;
  final String? title;
  final NextcloudClient? client;
  final bool toMe;

  const ListSharingTo(
      {Key? key,
      this.url,
      this.title,
      this.previsionUrl,
      this.wantBack = false,
      this.toMe = false,
      this.client})
      : super(key: key);

  @override
  State<ListSharingTo> createState() => _FileListScreenState();
}

class _FileListScreenState extends State<ListSharingTo> {
  late NextcloudClient cli;
  List<FileSharing> fileSharingList = [];

  @override
  void initState() {
    super.initState();
    cli = widget.client!;
    loadData2();
  }

  Future<List<FileSharing>> loadData() async {
    // cli = widget.client!;
    final acb = cli.filesSharing.shareapi
        .getShares(sharedWithMe: "false", includeTags: "true");
    var body;

    acb.then((value) {
      body = value.body.toJson();
      print(body);
      List<dynamic> fileData = body['ocs']['data'];
      setState(() {
        fileSharingList =
            fileData.map((data) => FileSharing.fromJson(data)).toList();
      });
    });
    return fileSharingList;
  }

  Future<List<FileSharing>> loadData2() async {
    String withME = widget.toMe.toString();
    var body;
    final acb = cli.filesSharing.shareapi
        .$getShares_Request(sharedWithMe: withME, includeTags: "true");
    final _response = await cli.filesSharing.httpClient.send(acb);
    final _serializer = cli.filesSharing.shareapi.$getShares_Serializer();

    final _rawResponse = await _i1.ResponseConverter<dynamic, void>(_serializer)
        .convert(_response);
    // print(_i1.DynamiteResponse.fromRawResponse(_rawResponse));
    // acb.then((value) {
    body = _rawResponse.body;
    List<dynamic> fileData = body['ocs']['data'];
    setState(() {
      fileSharingList =
          fileData.map((data) => FileSharing.fromJson(data)).toList();
    });
    // });
    return fileSharingList;
  }

  Future<Uint8List?>? getThumbnails(String? name) async {
    if (name!.startsWith('/')) {
      name = name.substring(1);
    }
    final file = cli.files.api.getThumbnail(x: 10, y: 10, file: name );
    return await file.then((value) {
      print("value body");
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

  Future<void> shareFile(String path, String userName) async {
    ///permission 19 : can edit
    final fileShare = await cli.filesSharing.shareapi.createShare(
        path: path.substring(1),
        permissions: 19,
        shareType: 0,
        shareWith: userName);
    if (fileShare.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Chia sẻ thành công cho $userName",
      );
    } else {
      Fluttertoast.showToast(msg: "Đã có lỗi!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: widget.wantBack,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.toMe ? "Được chia sẻ với tôi " : "Chia sẻ với người khác",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(width: 10),
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
        body: SingleChildScrollView(
          child: fileSharingList.length > 0
              ? Column(
                  children:
                      fileSharingList.map((e) => _buildListView(e)).toList(),
                )
              : Center(
                  child: Text("Chưa có gì chia sẻ !"),
                ),
        ));
  }

  Widget _buildListView(FileSharing file, {String? image}) {
    return FutureBuilder(
        future: getThumbnails(file.path),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            /// nếu không lấy được Thumbnail
            return ListTile(
                leading: snapshot.data != null
                    ? Image.memory(
                        snapshot.data as Uint8List,
                        height: 20,
                        width: 20,
                      )
                    : file.mimetype!.contains(".docx")
                        ? Icon(CustomIcons.ms_word)
                        : Icon(Icons.file_present_rounded,size: 45),
                title: Text(file.fileTarget!.substring(1)),
                trailing: InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.share,
                      size: 20,
                    )),
                subtitle:
                    Text("Sở hữu bởi " + '${file.displaynameFileOwner ?? ""}'),
                onTap: () async {
                  downloadAndOpenFile(file, file.path!.substring(1));
                });
          } else {
            return ListTile(
              leading: snapshot.data != null
                  ? Image.memory(snapshot.data as Uint8List)
                  : file.mimetype!.contains(".docx")
                      ? Icon(CustomIcons.ms_word)
                      : Icon(Icons.file_present_rounded,size: 45),
              title: Text(file.fileTarget!.substring(1)),
              subtitle:
                  Text("Sở hữu bởi " + '${file.displaynameFileOwner ?? ""}'),
              trailing: InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.share,
                    size: 20,
                  )),
              onTap: () async {
                downloadAndOpenFile(file, file.path!.substring(1));
              },
            );
          }
        });
  }

  void downloadAndOpenFile(FileSharing file, String direcPath) async {
    if (file.path!.endsWith('.md')) {
      var datas = await getContent(file.path);
      var acb = datas as Uint8List;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewMarkdown(
                    title: file.path!.substring(1),
                    data: acb,
                  )));
    } else {
      PathUri path = PathUri.parse(direcPath);
      final bytes = await cli.webdav.get(path);
      final dir = await getApplicationDocumentsDirectory();
      final localFile = File('${dir.path}/${file.fileTarget}');
      await localFile.writeAsBytes(bytes);

      // Open the file
      OpenFile.open(localFile.path);
    }
  }


}
