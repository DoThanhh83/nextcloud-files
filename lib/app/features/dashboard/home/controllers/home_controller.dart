part of home;

class HomeController extends GetxController {
  final user = _User(name: "");

  int deviceAvailableSize = 0;
  int deviceTotalSize = 0;

  @override
  void onInit() {
    super.onInit();
    updateUsage().then((value) {
      update();
      _usage.value = _Usage(
        totalFree: deviceAvailableSize,
        totalUsed: deviceTotalSize,
      );
    });
  }

  late Rx<_Usage> _usage = Rx<_Usage>(_Usage(totalFree: 0, totalUsed: 0));


  Future<void> updateUsage() async {
    Future.delayed(Duration(seconds: 1)).then((value) async {
      await DiskSpace.getFreeDiskSpace.then((value) {
        deviceAvailableSize = value!.toInt();
      });
      await DiskSpace.getTotalDiskSpace.then((value) {
        deviceTotalSize = value!.toInt();
      });
    });
    print("xxxxxxxx");
    print(deviceAvailableSize);
    print(deviceTotalSize);
    update();
  }

  final recent = [
    FileDetail(
      name: "powerpoint.pptx",
      size: 5000000,
      type: FileType.msPowerPoint,
    ),
    FileDetail(
      name: "word.docx",
      size: 10000000,
      type: FileType.msWord,
    ),
    FileDetail(
      name: "access.accdb",
      size: 2000000,
      type: FileType.msAccess,
    ),
    FileDetail(
      name: "excel.xlsx ",
      size: 3000000,
      type: FileType.msExcel,
    ),
    FileDetail(
      name: "outlook.pst",
      size: 400000,
      type: FileType.msOutlook,
    ),
    FileDetail(
      name: "videos.mp4",
      size: 4090000,
      type: FileType.other,
    ),
  ];
}
