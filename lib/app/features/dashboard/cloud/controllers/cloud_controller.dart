part of cloud;

class CloudController extends GetxController {
  List<_FolderData> folderData = [
    _FolderData(
      label: "private document",
      totalItem: 150,
      fileType: [
        FileType.msAccess,
        FileType.other,
        FileType.msOutlook,
        FileType.msPowerPoint,
      ],
    ),
    _FolderData(
      label: "work document",
      totalItem: 150,
      fileType: [
        FileType.msWord,
        FileType.msExcel,
      ],
    ),
  ];
}
