import 'dart:io';
import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';
import 'package:status_maker/models/Saved.dart';
import 'package:status_maker/providers/AdsProvider.dart';
import 'package:status_maker/providers/DatabaseProvider.dart';
import 'package:status_maker/widgets/IsEmptyWidget.dart';
import 'package:status_maker/widgets/IsErrorWidget.dart';
import 'package:status_maker/widgets/IsLoadingWidget.dart';

class SavedPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Provider.of<DatabaseProvider>(context , listen: false).getSaved(context);

    return Consumer<DatabaseProvider>(
      builder: (context, value, child) {
        if (value.isError) {
          return IsErrorWidget(
            error: value.error,
          );
        }
        if (value.list == null) {
          return IsLoadingWidget();
        }

        if (value.list.isEmpty) {
          return IsEmptyWidget();
        }

        return ListView.builder(itemBuilder: (context, index) {
          if(value.list.elementAt(index).isAd){
            return Provider.of<AdsProvider>(context , listen: false).getBanner(size: AdmobBannerSize.MEDIUM_RECTANGLE);
          }
          return TextCard(saved:value.list.elementAt(index));
        },itemCount: value.list.length,);
      },
    );
  }

}

class TextCard extends StatelessWidget {
  final Saved saved;
  final ScreenshotController screenshotController = ScreenshotController();

  TextCard({Key key, this.saved}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return textCard(context, saved);
  }


  Widget textCard(context , saved) {
    return Card(
      elevation: 5,
      borderOnForeground: true,
      margin: EdgeInsets.only(bottom: 5, top: 10, left: 10, right: 10),
      child: Container(
        child: Column(
          children: [
            quoteBody(saved),
            iconsBar(context, saved),
          ],
        ),
      ),
    );
  }

  Widget iconsBar(context , saved) {
    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        IconButton(
            icon: Icon(Icons.delete_forever_outlined),
            onPressed: () {
              Provider.of<DatabaseProvider>(context, listen: false).remove(context, saved.id);
            }),
        IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              Provider.of<AdsProvider>(context, listen: false).getFullScreen();
              SocialShare.copyToClipboard(saved.text ?? "لا يوجد نص")
                  .then((value) => EasyLoading.showSuccess("تم النسخ"));
            }),
        IconButton(
            icon: Icon(FontAwesome.download),
            onPressed: () {
              EasyLoading.show();
              var pixel = 2.0;
              if (window.devicePixelRatio > 2) {
                pixel = window.devicePixelRatio;
              }
              Provider.of<AdsProvider>(context, listen: false).getReward();
              screenshotController
                  .capture(pixelRatio: pixel)
                  .then((File image) async {
                await saveImageFile(image);
              });
            }),
        IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              EasyLoading.show();
              var pixel = 2.0;
              if (window.devicePixelRatio > 2) {
                pixel = window.devicePixelRatio;
              }

              screenshotController
                  .capture(pixelRatio: pixel)
                  .then((File image) async {
                EasyLoading.dismiss(animation: true);
                SocialShare.shareOptions(
                    "https://play.google.com/store/apps/details?id=com.alalfy.quotes_app",
                    imagePath: image.path);
              });
            }),
      ],
    );
  }

  Widget quoteBody(Saved saved) {
    List<TextDecoration> textDecorations = [];

    if (saved.fontStyles.contains("overline")) {
      textDecorations.add(TextDecoration.overline);
    }
    if (saved.fontStyles.contains("lineThrough")) {
      textDecorations.add(TextDecoration.lineThrough);
    }
    if (saved.fontStyles.contains("underline")) {
      textDecorations.add(TextDecoration.underline);
    }

    return Screenshot(
      controller: screenshotController,
      child:

      Container(
        decoration: BoxDecoration(
          color: saved.bgColor ?? Colors.white70,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4), topRight: Radius.circular(4)),
        ),
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            vertical: saved.vPadding, horizontal: saved.hPadding),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(FontAwesome.quote_right,
                    color: saved.fontColor ?? Colors.black),
              ],
            ),
            Center(
              child: Text(
                saved.text ?? "لا يوجد نص",
                textAlign: saved.fontAlign,
                style: TextStyle(
                    decoration: TextDecoration.combine(textDecorations),
                    fontStyle: saved.fontStyles.contains("italic")
                        ? FontStyle.italic
                        : FontStyle.normal,
                    fontWeight: saved.fontStyles.contains("bold")
                        ? FontWeight.w800
                        : FontWeight.normal,
                    fontSize: saved.fontSize ?? 35,
                    fontFamily: saved.fontName ?? "hor",
                    color: saved.fontColor ?? Colors.black),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(FontAwesome.quote_left,
                    color: saved.fontColor ?? Colors.black),
              ],
            ),
          ],
        ),
      ),
    );
  }

  saveImageFile(File image) async {
    File file;

    try {
      Directory folder = await checkFolder();

      if (folder == null) {
        return;
      }

      file = await File(folder.path + "/" + image.path.split("/").last)
          .writeAsBytes(image.readAsBytesSync());
    } catch (e) {}

    if (file != null) {
      EasyLoading.showSuccess("تم الحفظ بنجاح");
    } else {
      EasyLoading.showError("حدث خطأ ما!");
    }

    return file;
  }

  checkFolder() async {
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



}
