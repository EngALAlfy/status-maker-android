import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UtilsProvider extends ChangeNotifier {
  bool isLoaded = false;
  bool noInternet = false;

  bool isFirstOpen = true;

  bool isReviewed = false;

  bool isError = false;

  UtilsProvider() {
    init();
    addInternetListener();
  }

  init() async {
    await checkFirstOpen();
    noInternet = !await checkInternet();
    await checkReviewed();
    isLoaded = true;
    notifyListeners();
  }

  checkFirstOpen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isFirstOpen = preferences.getBool("isFirstOpen2") ?? true;
  }

  setFirstOpen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("isFirstOpen2", false);
    await checkFirstOpen();
    notifyListeners();
  }

  addInternetListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        noInternet = true;
      } else {
        noInternet = false;
      }

      notifyListeners();
    });
  }


  checkReviewed() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isReviewed = preferences.getBool("isReviewed1") ?? false;
  }

  setReviewed() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("isReviewed1", true);
    await checkReviewed();
    notifyListeners();
  }


  Future<bool> checkInternet() async {
    return await Connectivity().checkConnectivity() != ConnectivityResult.none;
  }

  Future<bool> setPermissions() async {
    return Permission.storage.request().isGranted;
  }

  Future<bool> checkPermissions() async {
    var storagePermission = await Permission.storage.request();

    if (storagePermission.isDenied) {
      EasyLoading.showError("لا يمكن تشغيل التطبيق بدون منح الاذونات");
      return false;
    } else {
      return true;
    }
  }


}
