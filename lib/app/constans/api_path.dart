part of app_constants;

/// all endpoint api
class ApiPath {
  // Example :
  static String BASE_URL = "http://192.168.1.13:8080";
  // static const product = "$_BASE_URL/product";
  static saveURLData(String url) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('baseUrl', url);
  }

  static Future<String> readURLData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('baseUrl') ?? "http://192.168.1.13:8080";
  }

  static saveUserData(String username) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }

  static Future<String> readUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }


  static savePassData(String pass) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('password', pass);
  }

  static Future<String> readPassData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('password') ?? '';
  }



  static Future<void> loadFiles( NextcloudClient client ) async {
    final data = await client.dashboard.dashboardApi.getWidgetItemsV2();
    print(data.body.toJson());
    final jsondata = data.body.toJson();
    final test = jsondata['ocs']['data']['recommendations'];

    // Data data1 = Data.fromJson(jsondata['ocs']['data']['recommendations']);

    print(test);
    Map<String, dynamic> jsonMap = test;

    List<dynamic> jsonItems = jsonMap['items'];
    print("day la file trashbin $jsonItems");
    // final data1 = await client.filesTrashbin.preview.getPreview();
    // print(data1.body);

    /// khhôg có gì để hiển thị file ( chỉ có chuyển sở hữu , xem trước thumbnail  ,vvv )
    // print("day la file ");
    final data2 = await client.files.api.getThumbnail(x: 30, y: 30, file: "file");
    // final data31 = await client.filesSharing.shareapi.createShare(path: ,permissions: ,shareType:0 ,shareWith: "");
    print(data2.body);

    // print("day la webDav ");
    PathUri path =  PathUri.parse("remote.php/dav/files/admin/");
    final data3 = await client.webdav.getStream(path) ;
    print("daay la $data3");

  }
}

extension NextcloudClientExtension on NextcloudClient {
  static final Uri defaultNextcloudUri = Uri.parse(Url_default);
  static final String Url_default = ApiPath.BASE_URL;

  static const String reproducibleSalt = r'8MnPs64@R&mF8XjWeLrD';

  static NextcloudClient? withSavedDetails() {
    String url = Url_default;
    return NextcloudClient(
      url.isNotEmpty ? Uri.parse(url) : defaultNextcloudUri,
      // loginName: username,
      // password: ncPassword,
    );
  }
}

