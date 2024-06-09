import 'dart:io';

import 'package:file_man/app/constans/app_constants.dart';
import 'package:file_man/app/features/dashboard/home/views/screens/file_manage.dart';
import 'package:file_man/app/utils/file_controller.dart';
import 'package:file_man/app/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({Key? key}) : super(key: key);

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  late FilesController myController ;
  String searchQuery = '';
  var gotPermission = false;
  var isMoving = false;
  var fullScreen = false;
  var isSearching = false;
  late FileSystemEntity selectedFile;

  List<FileSystemEntity> entities = [];
  late Usage usage ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myController = Get.put(FilesController());
    usage = Usage(totalFree: Global.StoragaFree, totalUsed: Global.StoragTotal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              _title(),
              SizedBox(width: 10),
              _emoji(),
            ],
          ),
        ),
        body:
        // SingleChildScrollView(
        //   child:
          // Column(children: [
            // Padding(
            //   padding: const EdgeInsets.all(15),
            //   child: StorageChart(),
            // ),
            // GestureDetector(
            //   onTap: () {
            //     Get.to(() => FileManage());
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.all(10),
            //     child: Icon(Icons.file_copy),
            //   ),
            // ),

            // FileManager(
            //   controller: myController.controller,
            //   builder: (context, snapshot) {
            //     myController.calculateSize(snapshot);
            //       entities = isSearching
            //         ? snapshot
            //         .where((element) => element.path.contains(searchQuery))
            //         .toList()
            //         : snapshot
            //         .where((element) =>
            //     element.path != '/storage/emulated/0/Android')
            //         .toList();
            //     return Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Column(
            //         children: [
            //           Visibility(
            //               visible: !fullScreen,
            //               child: Column(
            //                 children: [
            //                   Padding(
            //                     padding: const EdgeInsets.all(10.0),
            //                     child: SizedBox(
            //                       height: 100,
            //                       child: TextField(
            //                         onChanged: (value) {
            //                           setState(() {
            //                             isSearching = true;
            //                             searchQuery = value;
            //                             if (searchQuery.isEmpty ||
            //                                 searchQuery == "" ||
            //                                 searchQuery == " ") {
            //                               isSearching = false;
            //                             }
            //                           });
            //                         },
            //                         decoration: InputDecoration(
            //                           suffixIcon: const Icon(Icons.search),
            //                           filled: true,
            //                           fillColor: Colors.grey[200],
            //                           hintText: 'Search Files',
            //                           border: OutlineInputBorder(
            //                             borderRadius: BorderRadius.circular(16.0),
            //                             borderSide: BorderSide.none,
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                   Padding(
            //                     padding: const EdgeInsets.all(8.0),
            //                     child: Row(
            //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Text("Recent Files",
            //                             style: TextStyle(
            //                               fontSize: 16,
            //                               fontWeight: FontWeight.w600,
            //                             )),
            //                         InkWell(
            //                           onTap: () {
            //                             fullScreen = true;
            //                             setState(() {});
            //                           },
            //                           child: Text(
            //                             "See All",
            //                             style: TextStyle(
            //                               color: Colors.grey,
            //                               fontSize: 16,
            //                             ),
            //                           ),
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                 ],
            //               )),
            //           Expanded(
            //             child: ListView.builder(
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 2, vertical: 0),
            //               itemCount: entities.length,
            //               itemBuilder: (context, index) {
            //                 FileSystemEntity entity = entities[index];
            //
            //                 return Ink(
            //                   color: Colors.transparent,
            //                   child: ListTile(
            //                     trailing: PopupMenuButton(
            //                         itemBuilder: (BuildContext context) {
            //                           return <PopupMenuEntry>[
            //                             PopupMenuItem(
            //                               value: 'button1',
            //                               child: Row(
            //                                 mainAxisAlignment:
            //                                 MainAxisAlignment.spaceBetween,
            //                                 children: [
            //                                   Icon(Icons.delete, color: orange),
            //                                   const Text("Delete"),
            //                                 ],
            //                               ),
            //                             ),
            //                             PopupMenuItem(
            //                               value: 'button2',
            //                               child: Row(
            //                                 mainAxisAlignment:
            //                                 MainAxisAlignment.spaceBetween,
            //                                 children: [
            //                                   Icon(Icons.rotate_left_sharp,
            //                                       color: yellow),
            //                                   const Text("Rename"),
            //                                 ],
            //                               ),
            //                             ),
            //                             PopupMenuItem(
            //                               value: 'button3',
            //                               child: Row(
            //                                 mainAxisAlignment:
            //                                 MainAxisAlignment.spaceBetween,
            //                                 children: [
            //                                   Icon(Icons.move_down_rounded,
            //                                       color: black),
            //                                   const Text("Move"),
            //                                 ],
            //                               ),
            //                             )
            //                           ];
            //                         },
            //                         onSelected: (value) async {
            //                           switch (value) {
            //                             case 'button1':
            //                               if (FileManager.isDirectory(entity)) {
            //                                 await entity
            //                                     .delete(recursive: true)
            //                                     .then((value) {
            //                                   setState(() {});
            //                                 });
            //                                 ;
            //                               } else {
            //                                 await entity.delete().then((value) {
            //                                   setState(() {});
            //                                 });
            //                                 ;
            //                               }
            //
            //                               break;
            //                             case 'button2':
            //                               showDialog(
            //                                 context: context,
            //                                 builder: (context) {
            //                                   TextEditingController
            //                                   renameController =
            //                                   TextEditingController();
            //                                   return AlertDialog(
            //                                     title: Text(
            //                                         "Rename ${FileManager.basename(entity)}"),
            //                                     content: TextField(
            //                                       controller: renameController,
            //                                     ),
            //                                     actions: [
            //                                       TextButton(
            //                                         onPressed: () {
            //                                           Navigator.pop(context);
            //                                         },
            //                                         child: const Text("Cancel"),
            //                                       ),
            //                                       TextButton(
            //                                         onPressed: () async {
            //                                           await entity
            //                                               .rename(
            //                                             "${myController.controller.getCurrentPath}/${renameController.text.trim()}",
            //                                           )
            //                                               .then((value) {
            //                                             Navigator.pop(context);
            //                                             setState(() {});
            //                                           });
            //                                         },
            //                                         child: const Text("Rename"),
            //                                       ),
            //                                     ],
            //                                   );
            //                                 },
            //                               );
            //
            //                               break;
            //                             case 'button3':
            //                               selectedFile = entity;
            //                               setState(() {
            //                                 isMoving = true;
            //                               });
            //                               break;
            //                           }
            //                         },
            //                         child: const Icon(Icons.more_vert)),
            //                     leading: FileManager.isFile(entity)
            //                         ? Card(
            //                       color: yellow,
            //                       elevation: 0,
            //                       child: Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Image.asset(
            //                             "assets/3d/copy-dynamic-premium.png"),
            //                       ),
            //                     )
            //                         : Card(
            //                       color: orange,
            //                       elevation: 0,
            //                       child: Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Image.asset(
            //                             "assets/3d/folder-dynamic-color.png"),
            //                       ),
            //                     ),
            //                     title: Text(
            //                       FileManager.basename(
            //                         entity,
            //                         showFileExtension: true,
            //                       ),
            //                       style: TextStyle(
            //                         fontStyle: FontStyle.italic,
            //                         fontSize: 14,
            //                         fontWeight: FontWeight.w500,
            //                       ),
            //                     ),
            //                     subtitle: subtitle(
            //                       entity,
            //                     ),
            //                     onTap: () async {
            //                       if (FileManager.isDirectory(entity)) {
            //                         try {
            //                           myController.controller.openDirectory(entity);
            //                         } catch (e) {
            //                           myController.alert(
            //                               context, "Enable to open this folder");
            //                         }
            //                       }
            //                     },
            //                   ),
            //                 );
            //               },
            //             ),
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            // ),

        FileManage(usage: usage,),
          // ]),
        // )
    );
  }

  Widget _title() {
    return Text(
      "Hello ${Global.displayName ?? ""}",
      style: TextStyle(fontSize: 20),
    );
  }

  Widget _emoji() {
    return SizedBox(
      width: 20,
      child: Image.asset(
        ImageRaster.wavingHandEmoji,
        height: 20,
        width: 20,
      ),
    );
  }
}

class StorageChart extends StatefulWidget {
  const StorageChart({Key? key}) : super(key: key);

  @override
  State<StorageChart> createState() => _StorageChartState();
}

class _StorageChartState extends State<StorageChart> {
  late Usage usage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usage = Usage(totalFree: Global.StoragaFree, totalUsed: Global.StoragTotal);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // chart
        IntrinsicHeight(
          child: CircularPercentIndicator(
            radius: 150,
            lineWidth: 25,
            animation: true,
            percent: (getUsedPercent()) / 100,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _percentText(),
                _subtitleText("used"),
              ],
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Theme.of(context).primaryColor,
            backgroundColor: Colors.grey[300]!,
          ),
        ),

        SizedBox(height: 20),

        // usage information
        Row(
          children: [
            Spacer(),
            Flexible(
              flex: 4,
              child: _indicatorUsage(
                color: Colors.grey[300]!,
                title: (usage.totalFree! / 1024).toStringAsFixed(2) + " GB",
                subtitle: "Khả dụng",
              ),
            ),
            Flexible(
              flex: 4,
              child: _indicatorUsage(
                color: Theme.of(context).primaryColor,
                title: (usage.totalUsed! / 1024).toStringAsFixed(2) + " GB",
                subtitle: "Đã dùng",
              ),
            ),
            // Spacer(),
          ],
        )
      ],
    );
  }

  Widget _percentText() {
    return Text(
      "${getUsedPercent().toStringAsFixed(2)}%",
      // "",
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w600,
        color: Theme.of(Get.context!).primaryColor,
      ),
    );
  }

  Widget _indicatorUsage({
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 8,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(subtitle, style: Theme.of(Get.context!).textTheme.bodySmall),
          ],
        )
      ],
    );
  }

  Widget _subtitleText(String text) {
    return Text(
      text,
      style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(fontSize: 14),
    );
  }

  double getUsedPercent() {
    num _maxStorage = (usage.totalFree != null ? usage.totalFree! : 0) +
        (usage.totalUsed != null ? usage.totalUsed! : 0);
    return ((usage.totalUsed != null ? usage.totalUsed! : 0) / _maxStorage) *
        100;
  }
}

class Usage {
  double? totalFree;
  double? totalUsed;

  Usage({this.totalFree, this.totalUsed});
}
