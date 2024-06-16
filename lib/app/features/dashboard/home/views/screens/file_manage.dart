import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_man/app/constans/app_constants.dart';
import 'package:file_man/app/features/dashboard/home/views/components/widget_file_manage.dart';
import 'package:file_man/app/features/dashboard/home/views/screens/new_home_screen.dart';
import 'package:file_man/app/utils/const.dart';
import 'package:file_man/app/utils/file_controller.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nextcloud/webdav.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';
import '../../../../../utils/global.dart';
import 'package:http/http.dart' as http;

class FileManage extends StatefulWidget {
  final Usage usage;

  FileManage({Key? key, required this.usage}) : super(key: key);

  @override
  State<FileManage> createState() => _FileManageState();
}

class _FileManageState extends State<FileManage> {
  late double usedStorage;

  late double totalStorage;

  final FilesController myController = Get.put(FilesController());

  String searchQuery = '';
  var gotPermission = false;
  var isMoving = false;
  var fullScreen = false;
  var isSearching = false;
  FileSystemEntity? selectedFile;

  @override
  void initState() {
    super.initState();
    usedStorage = widget.usage.totalUsed! / 1024;
    totalStorage = (widget.usage.totalUsed! + widget.usage.totalFree!) / 1024;

    getPermission();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context),
        body: FileManager(
          controller: myController.controller,
          builder: (context, snapshot) {
            final List<FileSystemEntity> entities = isSearching
                ? snapshot
                    .where((element) => element.path.contains(searchQuery))
                    .toList()
                : snapshot
                    .where((element) =>
                        element.path != '/storage/emulated/0/Android')
                    .toList();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Visibility(
                      visible: !fullScreen,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              height: 7.5.h,
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    isSearching = true;
                                    searchQuery = value;
                                    if (searchQuery.isEmpty ||
                                        searchQuery == "" ||
                                        searchQuery == " ") {
                                      isSearching = false;
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                  suffixIcon: const Icon(Icons.search),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  hintText: 'Search Files',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: Colors.grey, width: 0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${usedStorage.toStringAsFixed(2)} GB / ${totalStorage.toStringAsFixed(2)} GB",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text("Đã dùng",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                )),
                          ],
                        ),
                        CircularPercentIndicator(
                          animateFromLastPercent: true,
                          animation: true,
                          animationDuration: 1200,
                          radius: 31.0,
                          lineWidth: 10.0,
                          percent: usedStorage / totalStorage,
                          progressColor: orange,
                          backgroundColor: Color(0xD2CBB8B8),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 0),
                      itemCount: entities.length,
                      itemBuilder: (context, index) {
                        FileSystemEntity entity = entities[index];

                        return Ink(
                          color: Colors.transparent,
                          child: ListTile(
                            trailing: FileManager.isDirectory(entity)
                                ? PopupMenuButton(
                                    itemBuilder: (BuildContext context) {
                                      return <PopupMenuEntry>[
                                        PopupMenuItem(
                                          value: 'button1',
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.delete, color: orange),
                                              const Text("Delete"),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'button2',
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.rotate_left_sharp,
                                                  color: yellow),
                                              const Text("Rename"),
                                            ],
                                          ),
                                        ),
                                      ];
                                    },
                                    onSelected: (value) async {
                                      switch (value) {
                                        case 'button1':
                                          if (FileManager.isDirectory(entity)) {
                                            await entity
                                                .delete(recursive: true)
                                                .then((value) {
                                              setState(() {});
                                            });
                                            ;
                                          } else {
                                            await entity.delete().then((value) {
                                              setState(() {});
                                            });
                                            ;
                                          }

                                          break;
                                        case 'button2':
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              TextEditingController
                                                  renameController =
                                                  TextEditingController();
                                              return AlertDialog(
                                                title: Text(
                                                    "Rename ${FileManager.basename(entity)}"),
                                                content: TextField(
                                                  controller: renameController,
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await entity
                                                          .rename(
                                                        "${myController.controller.getCurrentPath}/${renameController.text.trim()}",
                                                      )
                                                          .then((value) {
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      });
                                                    },
                                                    child: const Text("Rename"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          break;
                                      }
                                    },
                                    child: const Icon(Icons.more_vert))
                                : PopupMenuButton(
                                    itemBuilder: (BuildContext context) {
                                      return <PopupMenuEntry>[
                                        PopupMenuItem(
                                          value: 'button1',
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.delete, color: orange),
                                              const Text("Delete"),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'button2',
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.rotate_left_sharp,
                                                  color: yellow),
                                              const Text("Rename"),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'button4',
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.read_more,
                                                  color: black),
                                              const Text("Share"),
                                            ],
                                          ),
                                        )
                                      ];
                                    },
                                    onSelected: (value) async {
                                      switch (value) {
                                        case 'button1':
                                          if (FileManager.isDirectory(entity)) {
                                            await entity
                                                .delete(recursive: true)
                                                .then((value) {
                                              setState(() {});
                                            });
                                            ;
                                          } else {
                                            await entity.delete().then((value) {
                                              setState(() {});
                                            });
                                            ;
                                          }

                                          break;
                                        case 'button2':
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              TextEditingController
                                                  renameController =
                                                  TextEditingController();
                                              return AlertDialog(
                                                title: Text(
                                                    "Rename ${FileManager.basename(entity)}"),
                                                content: TextField(
                                                  controller: renameController,
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await entity
                                                          .rename(
                                                        "${myController.controller.getCurrentPath}/${renameController.text.trim()}",
                                                      )
                                                          .then((value) {
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      });
                                                    },
                                                    child: const Text("Rename"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          break;

                                        case 'button4':
                                          selectedFile = entity;
                                          _readFileBytes(entity);
                                          break;
                                      }
                                    },
                                    child: const Icon(Icons.more_vert)),
                            leading: FileManager.isFile(entity)
                                ? Card(
                                    // color: yellow,
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Image.asset(
                                          "assets/3d/copy-dynamic-premium.png"),
                                    ),
                                  )
                                : Card(
                                    // color: orange,
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Image.asset(
                                          "assets/3d/folder-dynamic-color.png"),
                                    ),
                                  ),
                            title: Text(
                              FileManager.basename(
                                entity,
                                showFileExtension: true,
                              ),
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: subtitle(
                              entity,
                            ),
                            onTap: () {
                              if (FileManager.isDirectory(entity)) {
                                try {
                                  myController.controller.openDirectory(entity);
                                  // setState(() {
                                  selectedFile = entity;
                                  // });
                                } catch (e) {
                                  myController.alert(
                                      context, "Enable to open this folder");
                                }
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  void _readFileBytes(FileSystemEntity selectedFile) async {
    File file = File(selectedFile.path);
    String name = FileManager.basename(selectedFile);
    bool isLargeFile = false;

    // Kiểm tra xem file có quá lớn không giới hạn dung lượng 512MB
    await file.length().then((value) {
      if (value > 512 * 1024 * 1024) {
        isLargeFile = true;
      }
    });
    if (isLargeFile) {
      final cli = Global.client;
      var uuid = Uuid().v4();

      // Create a unique folder for the chunks
      PathUri urlChunk = PathUri.parse(
          '${ApiPath.BASE_URL}/remote.php/dav/uploads/${Global.userName}/$uuid');
      cli?.webdav.mkcol(urlChunk);
      var chunkSize = 5 * 1024 * 1024; // 5MB
      var totalChunks = (file.lengthSync() / chunkSize).ceil();
      for (var i = 0; i < totalChunks; i++) {
        // Read the entire file as bytes
        var allBytes = await file.readAsBytes();
        // Get the specific chunk
        var chunk = allBytes.sublist(i * chunkSize, (i + 1) * chunkSize);

        final urlChunkNew = PathUri.parse(
            '${ApiPath.BASE_URL}/remote.php/dav/uploads/${Global.userName}/$uuid/$i');
        await cli!.webdav.put(chunk, urlChunkNew);
        // await http.put(
        //   Uri.parse('${ApiPath.BASE_URL}/remote.php/dav/uploads/${Global.userName}/$uuid/$i'),
        //   headers: {
        //     'Authorization': 'Basic ' + base64Encode(utf8.encode('${Global.userName}:${Global.password}')),
        //     'Destination': '${ApiPath.BASE_URL}/remote.php/dav/files/${Global.userName}/$destinationPath',
        //   },
        //   body: chunk,
        // );
      }
      // Assemble the chunks
      await cli!.webdav
          .move(
              PathUri.parse(
                  "PathUri.parse('${ApiPath.BASE_URL}/remote.php/dav/uploads/${Global.userName}/$uuid"),
              PathUri.parse(
                  "${ApiPath.BASE_URL}/remote.php/dav/files/${Global.userName}/file.zip"))
          .then((value) {
        Fluttertoast.showToast(msg: "Tải lên file  $name thành công");
      });

      // try {
      //   final data = await file.openRead();
      //   List<int> bytes = [];
      //   await for (var value in data) {
      //     bytes.addAll(value);
      //   }
      //   upFile(name, Uint8List.fromList(bytes));
      //  } catch (e) {
      //    Fluttertoast.showToast(msg: "Lỗi khi tải $name lên: $e");
      //  }

      /// ngat tam thoi

      // try {
      //   final data = file.openRead();
      //   final length = await file.length();
      //   ///tạo urlss là t APiPath.baseUrl và remote.php/dav/files/user/ + name
      //    final urlss = ApiPath.BASE_URL + "/remote.php/dav/files/user/" + name;
      //   final request = http.MultipartRequest('PUT', Uri.parse(urlss));
      //   request.files.add(http.MultipartFile('file', data, length, filename: name));
      //   final response = await request.send();
      //   if (response.statusCode == 200) {
      //     Fluttertoast.showToast(msg: "Tải lên file $name thành công");
      //   } else {
      //     Fluttertoast.showToast(msg: "Lỗi khi tải $name lên: ${response.statusCode}");
      //   }
      // } catch (e) {
      //   print(e);
      //   Fluttertoast.showToast(msg: "Lỗi khi tải $name lên: $e");
      // }
      /// het ngat
    } else {
      // Đọc toàn bộ file nếu file không quá lớn
      final data = await file.readAsBytes();
      upFile(name, data);
    }
  }

  Future<void> upFile(String path, Uint8List data) async {
    final cli = Global.client;
    try {
      await cli!.webdav.put(data, PathUri.parse(path));
      Fluttertoast.showToast(msg: "Tải lên file  $path thành công");
    } catch (e) {
      Fluttertoast.showToast(msg: "Lỗi khi tải $path lên: $e");
    }
  }

  Future<void> getPermission() async {
    if (await Permission.storage.request().isGranted &&
        await Permission.accessMediaLocation.request().isGranted &&
        await Permission.manageExternalStorage.request().isGranted) {
      gotPermission = true;
      setState(() {});
    } else {
      await Permission.storage.request().then((value) {
        if (value.isGranted) {
          setState(() {
            gotPermission = true;
          });
        }
      });
    }
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      actions: [
        Visibility(
            visible: isMoving,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  selectedFile!.rename(
                      "${myController.controller.getCurrentPath}/${FileManager.basename(selectedFile)}");
                  setState(() {
                    isMoving = false;
                  });
                },
                child: Row(
                  children: const [
                    Text("Move here ",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    Icon(Icons.paste),
                  ],
                ),
              ),
            )),

        /// xem lại có cần sửa không
        Visibility(
          visible: !isMoving,
          child: PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 'button1',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.file_present,
                          color: orage2,
                        ),
                        const Text("New File"),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'button2',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.folder_open, color: orange),
                        const Text("New Folder"),
                      ],
                    ),
                  ),
                ];
              },
              onSelected: (value) {
                switch (value) {
                  case 'button1':
                    myController.createFile(
                        context, myController.controller.getCurrentPath);

                    break;
                  case 'button2':
                    myController.createFolder(context);
                    break;
                }
              },
              child: const Icon(Icons.create_new_folder_outlined)),
        ),
        Visibility(
          visible: !isMoving,
          child: IconButton(
            // onPressed: () => myController.sort(context),
            icon: const Icon(Icons.sort_rounded),
            onPressed: () {},
          ),
        ),
      ],
      title: Text(
          myController.controller.getCurrentPath == "/storage/emulated/0"
              ? "File Manager"
              : selectedFile?.path ?? 'Default Path',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () async {
          await myController.controller.goToParentDirectory().then((value) {
            if (myController.controller.getCurrentPath ==
                "/storage/emulated/0") {
              fullScreen = false;
              setState(() {});
            }
          });
        },
      ),
    );
  }
}
