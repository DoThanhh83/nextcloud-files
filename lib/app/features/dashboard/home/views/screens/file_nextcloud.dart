import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_man/app/constans/app_constants.dart';
import 'package:file_man/app/features/dashboard/home/views/screens/list_sharing_to.dart';
import 'package:file_man/app/features/dashboard/home/views/screens/list_user_sharing.dart';
import 'package:file_man/app/features/dashboard/home/views/screens/ocr_page.dart';
import 'package:file_man/app/features/dashboard/home/views/screens/preview_markdown.dart';
import 'package:file_man/app/features/dashboard/home/views/screens/preview_pdf.dart';
import 'package:file_man/app/utils/global.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nextcloud/files.dart';
import 'package:nextcloud/files_sharing.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/webdav.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;
import 'package:fluttertoast/fluttertoast.dart';

class FileNextCould extends StatefulWidget {
  final String? url;
  final String? previsionUrl;
  final bool wantBack;
  final String? title;

  const FileNextCould(
      {Key? key,
      this.url,
      this.title,
      this.previsionUrl,
      this.wantBack = false})
      : super(key: key);

  @override
  State<FileNextCould> createState() => _FileListScreenState();
}

class _FileListScreenState extends State<FileNextCould> {
  late webdav.Client client;
  late NextcloudClient cli;

  String url = ApiPath.BASE_URL + '/remote.php/dav/files/${Global.userName}/';
  String user = "";
  String pwd = "";
  final dirPath = '/';
  String? temp;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    if (Global.userName != null) {
      setState(() {
        user = Global.userName ?? "";
        pwd = Global.password ?? "";
      });
      loadData();
    } else {
      print(Global.userName);
    }
  }

  void loadData() {
    if (widget.previsionUrl != null) {
      setState(() {
        temp = widget.previsionUrl!;
        url = url + temp!;
      });
    }
    // init client

    cli = NextcloudClient(Uri.parse(ApiPath.BASE_URL),
        loginName: Global.userName, password: Global.password);
    client = webdav.newClient(url, user: user, password: pwd, debug: true);
  }

  Future<Uint8List?>? getThumnails(String? name, {int? idFile}) async {
    // final cli = NextcloudClient(Uri.parse(ApiPath.BASE_URL),
    //     loginName: 'admin', password: 'admin');
    if (name!.startsWith('/')) {
      name = name.substring(1);
    }
    if (widget.previsionUrl != null) {
      // final uri = Uri.file( widget.previsionUrl! + name);
      // final ppah = uri.path;
      final ppah = widget.previsionUrl! + name;
      Uri encodedPath = Uri.parse(ppah);
      final file = cli.files.api
          .getThumbnail(x: 10, y: 10, file: encodedPath.path );
      return await file.then((value) {
        return value.body;
      });
    } else {
      final file = cli.files.api.getThumbnail(x: 10, y: 10, file: name);
      return await file.then((value) {
        // print(value.body);
        return value.body;
      });
    }
  }

  Future<Uint8List?>? getContent(String? name) async {
    if (name!.startsWith('/')) {
      name = name.substring(1);
    }
    if (widget.previsionUrl != null) {
      final ppah = widget.previsionUrl! + name;
      PathUri pathUri = PathUri.parse(ppah);
      final file = cli.webdav.get(pathUri);
      return await file.then((value) {
        print("value Contetn body có previsionUrl ");
        return value;
      });
    } else {
      PathUri pathUri = PathUri.parse(name);
      final file = cli.webdav.get(pathUri);
      return await file.then((value) {
        print("value Contetn body");
        return value;
      });
    }
  }

  Future<List<webdav.File>> _getData() {
    return client.readDir(dirPath);
  }

  Future<void> shareFile(String path, String userName) async {
    ///permission 19 :  edit
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

  Future<void> deleteFile(String? nameFile) async {
    if (widget.previsionUrl != null) {
      final ppah = widget.previsionUrl! + nameFile!;
      PathUri urlDelete = PathUri.parse(ppah);
      final file = cli.webdav.delete(urlDelete);
      file.then((value) {
        print(value);
        Fluttertoast.showToast(
            msg: "Xóa file $nameFile thành công!", timeInSecForIosWeb: 2);
      });
    } else {
      PathUri urlDelete = PathUri.parse(nameFile!);
      final file = cli.webdav.delete(urlDelete);
      file.then((value) {
        print(value);
        Fluttertoast.showToast(
            msg: "Xóa file $nameFile thành công!", timeInSecForIosWeb: 2);
      });
    }
  }

  void uploadFile(String? nameFile, Uint8List localData) {
    if (widget.previsionUrl != null) {
      final ppah = widget.previsionUrl! + nameFile!;
      PathUri urlPut = PathUri.parse(ppah);
      final file = cli.webdav.put(localData, urlPut);
      file.then((value) {
        print(value);
        Fluttertoast.showToast(
            msg: "Upload file $nameFile thành công!", timeInSecForIosWeb: 2);
      });
    } else {
      PathUri urlPut = PathUri.parse(nameFile!);
      final file = cli.webdav.put(localData, urlPut);
      file.then((value) {
        print(value);
        Fluttertoast.showToast(
            msg: "Upload file $nameFile thành công!", timeInSecForIosWeb: 2);
      });
    }
  }

  Widget thumbnail(webdav.File file) {
    if (file.name!.endsWith("doc") || file.name!.endsWith("docx")) {
      return Icon(CustomIcons.ms_word, size: 50);
    } else if (file.name!.endsWith("pptx") || file.name!.endsWith("ppt")) {
      return Icon(CustomIcons.ms_power_point, size: 50);
    } else if (file.name!.endsWith("xlsx") || file.name!.endsWith("xls")) {
      return Icon(CustomIcons.ms_excel, size: 50);
    }
    return Icon(Icons.file_present_rounded, size: 50);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: widget.wantBack,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title ?? "My Cloud",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(width: 10),
              widget.title == null
                  ? SizedBox(
                      width: 20,
                      child: Image.asset(
                        ImageRaster.logoNC,
                        height: 20,
                        width: 20,
                      ),
                    )
                  : Container(),
              Spacer(),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _getData();
                  });
                },
                icon: Icon(Icons.rotate_left)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OCRPage(title: "OCR", client: cli)));
                },
                icon: Icon(Icons.move_down))
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
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          spacing: 3,
          openCloseDial: isDialOpen,
          children: [
            SpeedDialChild(
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        isDialOpen.value = !isDialOpen.value;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListSharingTo(
                                  client: cli, toMe: true, wantBack: true)));
                    },
                    icon: Icon(Icons.person)),
                label: "Chia sẻ với tôi"),
            SpeedDialChild(
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        isDialOpen.value = !isDialOpen.value;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListSharingTo(
                                  client: cli, toMe: false, wantBack: true)));
                    },
                    icon: Icon(Icons.groups)),
                label: "Chia sẻ với người khác"),
            SpeedDialChild(
                child: IconButton(
                    onPressed: () async {
                      setState(() {
                        isDialOpen.value = !isDialOpen.value;
                      });
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        withData: true,
                      );
                      if (result != null) {
                        PlatformFile file = result.files.first;
                        uploadFile(file.name, file.bytes!);
                        _getData();
                      } else {
                        print('Không có tệp tin nào được chọn');
                      }
                    },
                    icon: Icon(Icons.upload)),
                label: "Tải lên"),
          ],
        ));
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Thông báo'),
                            content: const Text(
                              'Bạn muốn xóa file này ?',
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    deleteFile(file.name).then(
                                        (value) => Navigator.pop(context));
                                    setState(() {
                                      _getData();
                                    });
                                  },
                                  child: Text("Xác nhận")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Xác nhận")),
                            ],
                          );
                        });
                  },
                  leading: file.isDir == true
                      ? SvgPicture.asset(ImageVector.folder, height: 40)
                      : thumbnail(file),
                  title: Text(file.name ?? ''),
                  trailing:file.isDir == true ?SizedBox.shrink() : InkWell(
                      onTap: () {
                        // shareFile(file.path!.substring(1),);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListUser(
                                      cli: cli,
                                      onDone: (val) {
                                        print(val);
                                        shareFile(file.path!, val);
                                      },
                                    )));
                      },
                      child: Icon(Icons.share, size: 20)),
                  subtitle: Text(file.mTime.toString(),
                      style: TextStyle(
                          color: Color(0xF2032269),
                          fontStyle: FontStyle.italic,
                          fontSize: 13)),
                  onTap: () async {
                    if (file.isDir == true) {
                      if (file.path!.endsWith('/')) {
                        String tempPath =
                            widget.previsionUrl ?? "" + file.path!.substring(1);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FileNextCould(
                                    url: file.path,
                                    wantBack: true,
                                    title: file.name,
                                    previsionUrl: tempPath)));
                      }
                    } else {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context){
                            return Container(
                              child: Wrap(
                                children: <Widget>[
                                  ListTile(
                                      leading: Icon(Icons.remove_red_eye),
                                      title: Text('Xem'),
                                      onTap: () async {
                                        Navigator.pop(context);
                                        if (file.name!.endsWith('.pdf')) {
                                          var datas = await getContent(file.path);
                                          var acb = datas as Uint8List;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PreviewFile(title: file.name, data: acb)));
                                        } else {
                                          downloadAndOpenFile(file, file.path!.substring(1));
                                        }
                                      }
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.download),
                                    title: Text('Tải xuống'),
                                    onTap: () {
                                      downloadFile(file, file.path!.substring(1),
                                          previousPath: widget.previsionUrl);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                      );
                      // downloadFile(file, file.path!.substring(1));
                    }
                  },
                );
              } else {
                return ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Thông báo'),
                            content: const Text(
                              'Bạn muốn xóa file này ?',
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    deleteFile(file.name).then(
                                        (value) => Navigator.pop(context));
                                    setState(() {
                                      _getData();
                                    });
                                  },
                                  child: Text("Xác nhận")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Hủy")),
                            ],
                          );
                        });
                  },
                  leading: file.isDir == true
                      ? SvgPicture.asset(
                          ImageVector.folder,
                          height: 30,
                        )
                      : snapshot.data != null
                          ? Image.memory(snapshot.data as Uint8List)
                          : thumbnail(file),
                  title: Text(file.name ?? ''),
                  subtitle: Text(file.mTime.toString(),
                      style: TextStyle(
                          color: Color(0xF2032269),
                          fontStyle: FontStyle.italic,
                          fontSize: 13)),
                  trailing: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListUser(
                                      cli: cli,
                                      onDone: (val) {
                                        shareFile(file.path!, val);
                                      },
                                    )
                            ));
                      },
                      child: Icon(
                        Icons.share,
                        size: 20,
                      )),
                  onTap: () async {
                    if (file.isDir == true) {
                      String tempPath =
                          widget.previsionUrl ?? "" + file.path!.substring(1);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FileNextCould(
                                  url: file.path,
                                  wantBack: true,
                                  title: file.name,
                                  previsionUrl: tempPath)));
                    } else {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext bc){
                              return Container(
                                child: Wrap(
                                  children: <Widget>[
                                    ListTile(
                                        leading: Icon(Icons.remove_red_eye),
                                        title: Text('Xem'),
                                        onTap: () {
                                          Navigator.pop(context);

                                          downloadAndOpenFile(file, file.path!.substring(1),
                                              previousPath: widget.previsionUrl);
                                        }
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.download),
                                      title: Text('Tải xuống'),
                                      onTap: () {
                                        downloadFile(file, file.path!.substring(1),
                                            previousPath: widget.previsionUrl);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                        );
                    }
                  },
                );
              }
            },
          );
        });
  }

  void downloadAndOpenFile(webdav.File file, String direcPath,
      {String? previousPath}) async {
    if (file.name!.endsWith('.md')) {
      var datas = await getContent(file.path);
      var acb = datas as Uint8List;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PreviewMarkdown(title: file.name, data: acb)));
    } else {
      var fullPath = direcPath;
      if (previousPath != null) {
        fullPath = previousPath + direcPath;
      }
      PathUri path = PathUri.parse(fullPath);
      final bytes = await cli.webdav.get(path);
      final dir = await getApplicationDocumentsDirectory();
      final localFile = File('${dir.path}/${file.name}');
      await localFile.writeAsBytes(bytes);
      // Open the file
      OpenFile.open(localFile.path);
    }
  }

  void downloadFile(webdav.File file, String direcPath,
      {String? previousPath}) async {
    final folderName = "Nextcloud Download";
    final dir = Directory("storage/emulated/0/$folderName");

    if (await dir.exists()) {
      // thư mục đã tồn tại, không cần làm gì
    } else {
      // thư mục chưa tồn tại, tạo nó
      await dir.create();
    }
      var fullPath = direcPath;
      if (previousPath != null) {
        fullPath = previousPath + direcPath;
      }
      PathUri path = PathUri.parse(fullPath);
      final bytes = await cli.webdav.get(path);
      final localFile = File('${dir.path}/${file.name}');
      await localFile.writeAsBytes(bytes).then((value) {
        Fluttertoast.showToast(msg: "Đã tải ${file.name} về thư mục $dir",timeInSecForIosWeb: 3);
      });

  }
}