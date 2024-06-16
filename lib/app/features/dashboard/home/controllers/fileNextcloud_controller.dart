
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mime/mime.dart';
import 'package:nextcloud/files_sharing.dart';
import 'package:nextcloud/webdav.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;
import 'package:nextcloud/nextcloud.dart';

import '../views/screens/preview_markdown.dart';

class FileNextCloudController {
  late webdav.Client client;
  late NextcloudClient cli;

  FileNextCloudController(this.client, this.cli);

  Future<Uint8List?>? getContent(String? name,{String? previsionUrl} ) async {
    if (name!.startsWith('/')) {
      name = name.substring(1);
    }
    if (previsionUrl != null) {
      final ppah = previsionUrl + name;
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
  Future<void> shareFile(String path, String userName, {int? permission}) async {
    ///permission 19 :  edit
    final fileShare = await cli.filesSharing.shareapi.createShare(
        path: path.substring(1),
        permissions: permission ?? 19,
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

  Future<void> deleteFile(String? nameFile,{String? previsionUrl} ) async {
    if (previsionUrl != null) {
      final ppah = previsionUrl + nameFile!;
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

  void uploadFile(String? nameFile, Uint8List localData,{String? previsionUrl} ) {
    if (previsionUrl != null) {
      final ppah = previsionUrl + nameFile!;
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


  Future<List<webdav.File>> getData({String? dirPath}) {
    return client.readDir(dirPath?? "/");
  }

  void downloadAndOpenFile(BuildContext context , webdav.File file, String direcPath, {String? previousPath}) async {
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
      // // Open the file
      // OpenFile.open(localFile.path);

      if (Platform.isIOS) {
        OpenFile.open(localFile.path, type: lookupMimeType(file.name ?? ""), uti: 'public.data');
      } else {
        OpenFile.open(localFile.path);
      }
    }
  }

  void downloadFile(webdav.File file, String direcPath, {String? previousPath}) async {

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