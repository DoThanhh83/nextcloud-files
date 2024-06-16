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

  static clearURLData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('baseUrl');
  }
  static void clearUserData() {
    final prefs =  SharedPreferences.getInstance();
    prefs.then((value) => value.remove('username'));
  }

  static void clearPassData() {
    final prefs =  SharedPreferences.getInstance();
    prefs.then((value) => value.remove('password'));
  }

  static Future<void> loadFilesTest( NextcloudClient client ) async {
    final data = await client.dashboard.dashboardApi.getWidgetItemsV2();
    print(data.body.toJson());
    final jsondata = data.body.toJson();
    final test = jsondata['ocs']['data']['recommendations'];

    // Data data1 = Data.fromJson(jsondata['ocs']['data']['recommendations']);

    print(test);
    Map<String, dynamic> jsonMap = test;


  }


}

extension NextcloudClientExtension on NextcloudClient {
  static final Uri defaultNextcloudUri = Uri.parse(Url_default);
  static final String Url_default = ApiPath.BASE_URL;

  static const String reproducibleSalt = r'D';

  static NextcloudClient? withSavedDetails() {
    String url = Url_default;
    return NextcloudClient(
      url.isNotEmpty ? Uri.parse(url) : defaultNextcloudUri,
      // loginName: username,
      // password: ncPassword,
    );
  }
}

