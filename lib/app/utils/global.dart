import 'dart:typed_data';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/src/api/provisioning_api.openapi.dart';

class Global{
  static $UsersClient? user;
  static Uint8List? pfp;

  static NextcloudClient? client;

 static String? displayName;
 static String? Address;
 static String? Email ;

 static String? userName;
 static String? password;


 static double? StoragaFree;
 static double? StoragTotal;

}