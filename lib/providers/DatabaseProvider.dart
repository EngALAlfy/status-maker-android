import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:status_maker/models/Saved.dart';

class DatabaseProvider extends ChangeNotifier {
  bool isError = false;
  String error;
  List<Saved> list;

  String dbName = 'saved.db';
  String savedStoreName = "saved_status1";
  Database db;

  init(context) async {
    Directory folder;

    folder = await checkFolder();

    if (folder == null) {
      isError = true;
      error = "لا يمكن الوصول للملفات .. تاكد من اعطاء الاذونات";
      notifyListeners();
      return;
    }

    try {
      // File path to a file in the current directory
      String dbPath = folder.path + "/" + dbName;
      DatabaseFactory dbFactory = databaseFactoryIo;

      // We use the database factory to open the database
      db = await dbFactory.openDatabase(dbPath);
    } catch (e) {
      isError = true;
      error = e.toString();
      notifyListeners();
    }
  }

  checkFolder() async {
    var storagePermission = await Permission.storage.request();

    if (storagePermission.isDenied) {
      EasyLoading.showError("لا يمكن حفظ الصورة بدون منح الاذونات");
      return null;
    }

    String path = await ExtStorage.getExternalStorageDirectory();
    Directory folder = Directory(path + "/صانع الحالات/.database");

    if (!folder.existsSync()) {
      await folder.create(recursive: true);
    }

    return folder;
  }

  save(context, Saved saved) async {
    await init(context);
    if (db != null) {
      StoreRef savedStore = StoreRef(savedStoreName);
      await savedStore.record(saved.id).put(db, saved.toJson());
      EasyLoading.showSuccess("تم اضافه للمحفوظات");
      getSaved(context);
    } else {
      EasyLoading.showError("حدث خطأ ما!");
    }
  }

  remove(context, key) async {
    await init(context);
    if (db != null) {
      StoreRef savedStore = StoreRef(savedStoreName);
      await savedStore.record(key).delete(db);
      EasyLoading.showSuccess("تم الحذف من المحفوظات");
      getSaved(context);
    } else {
      EasyLoading.showError("حدث خطأ ما!");
    }
  }

  getSaved(context) async {
    await init(context);
    if (db != null) {
      StoreRef savedStore = StoreRef(savedStoreName);
      var _ids = await savedStore.findKeys(db);
      print(_ids);
      var quotes = await savedStore.records(_ids).get(db);
      print(quotes);

      list = quotes
          ?.map((e) =>
              e == null ? null : Saved.fromJson(e as Map<String, dynamic>))
          ?.toList();

      if (list.isNotEmpty) {
        for (int i = 1; i <= 2; i++) {
          int index = (i * 7 - 6) < list.length
              ? (i * 7 - 6)
              : list.length;
          list.insert(index, Saved(isAd: true));
        }
      }

      notifyListeners();
    } else {
      EasyLoading.showError("حدث خطأ ما!");
    }
  }
}
