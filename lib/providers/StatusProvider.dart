import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';

class StatusProvider extends ChangeNotifier {
  List<FileSystemEntity> statusList;
  List<FileSystemEntity> statusBizList;
  bool isError = false;
  String error;

  checkWhatsAppFolder() async {
    var storagePermission = await Permission.storage.request();

    if (storagePermission.isDenied) {
      EasyLoading.showError("لا يمكن حفظ الصورة بدون منح الاذونات");
      isError = true;
      error = "لا يمكن الوصول للملفات .. تاكد من اعطاء الاذونات";
      notifyListeners();
      return;
    }

    String path = await ExtStorage.getExternalStorageDirectory();
    Directory folder = Directory(path + "/WhatsApp/Media/.Statuses");


    if (!folder.existsSync()) {
      isError = true;
      error = "لا يمكن الوصول لملف واتس اب تأكد من تثبيتة";
      notifyListeners();
      return;
    }

    List list = folder.listSync();
    if(list.length <= 1){
      isError = true;
      error = "لا يوجد حالات .. تاكد من مشاهدة الحالات اولا في واتس اب";
      notifyListeners();
      return;
    }

    statusList = list.where((element) => !element.path.contains("nomedia")).toList();

    notifyListeners();
  }

  checkWhatsAppBizFolder() async {
    var storagePermission = await Permission.storage.request();

    if (storagePermission.isDenied) {
      EasyLoading.showError("لا يمكن حفظ الصورة بدون منح الاذونات");
      isError = true;
      error = "لا يمكن الوصول للملفات .. تاكد من اعطاء الاذونات";
      notifyListeners();
      return;
    }

    String path = await ExtStorage.getExternalStorageDirectory();
    Directory folder = Directory(path + "/WhatsApp Business/Media/.Statuses");

    if (!folder.existsSync()) {
      isError = true;
      error = "لا يمكن الوصول لملف واتس اب تأكد من تثبيتة";
      notifyListeners();
      return;
    }

    List list = folder.listSync();
    if(list.length <= 1){
      isError = true;
      error = "لا يوجد حالات .. تاكد من مشاهدة الحالات اولا في واتس اب";
      notifyListeners();
      return;
    }

    statusBizList = list.where((element) => !element.path.contains("nomedia")).toList();

    notifyListeners();
  }

  checkAppFolder() async {
    var storagePermission = await Permission.storage.request();

    if (storagePermission.isDenied) {
      EasyLoading.showError("لا يمكن حفظ الصورة بدون منح الاذونات");
      return null;
    }

    String path = await ExtStorage.getExternalStorageDirectory();
    Directory folder = Directory(path + "/صانع الحالات");

    if (!folder.existsSync()) {
      await folder.create(recursive: true);
    }

    return folder;
  }

  Future saveStatus(FileSystemEntity file) async {
    Directory folder = await checkAppFolder();

    if (folder == null) {
      EasyLoading.showError("لا يمكن الوصول للملفات");
      return;
    }

    return (file as File)
        .copySync(folder.path + "/" + file.path.split("/").last);
  }
}
