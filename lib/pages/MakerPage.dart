import 'dart:io';
import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:clipboard/clipboard.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:screenshot/screenshot.dart';
import 'package:smart_select/smart_select.dart';
import 'package:social_share/social_share.dart';
import 'package:status_maker/models/Saved.dart';
import 'package:status_maker/providers/AdsProvider.dart';
import 'package:status_maker/providers/DatabaseProvider.dart';
import 'package:status_maker/providers/MakerProvider.dart';
import 'package:status_maker/utils/Config.dart';
import 'package:uuid/uuid.dart';

class MakerPage extends StatelessWidget {
  final ScreenshotController screenshotController = ScreenshotController();
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MakerProvider makerProvider =
        Provider.of<MakerProvider>(context, listen: false);
    AdsProvider adsProvider = Provider.of<AdsProvider>(context, listen: false);

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Config.ACCENT_COLOR,
                      width: 1,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Config.ACCENT_COLOR,
                      width: 1,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(5),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                hintText: "ادخل النص هنا ..",
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.paste,
                      color: Config.ACCENT_COLOR,
                    ),
                    onPressed: () async {
                      var past = await FlutterClipboard.paste();
                      textEditingController.text = past;
                      makerProvider.text = past;
                    }),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              onChanged: (value) {
                makerProvider.text = value;
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          textCard(context, makerProvider),
          SizedBox(
            height: 20,
          ),
          adsProvider.getBanner(size: AdmobBannerSize.BANNER),
          fontSize(),
          Divider(),
          vPadding(),
          Divider(),
          hPadding(),
          Divider(),
          fontStyles(makerProvider),
          Divider(),
          adsProvider.getBanner(size: AdmobBannerSize.MEDIUM_RECTANGLE),
          Divider(),
          fontName(makerProvider),
          Divider(),
          fontDec(makerProvider),
          Divider(),
          adsProvider.getBanner(size: AdmobBannerSize.MEDIUM_RECTANGLE),
          Divider(),
          fontAlign(makerProvider),
          Divider(),
          fontColor(context, makerProvider),
          Divider(),
          adsProvider.getBanner(size: AdmobBannerSize.MEDIUM_RECTANGLE),
          Divider(),
          bgColor(context, makerProvider),
          Divider(),
          adsProvider.getBanner(size: AdmobBannerSize.MEDIUM_RECTANGLE),
        ],
      ),
    );
  }

  Widget textCard(context, MakerProvider makerProvider) {
    return Card(
      elevation: 5,
      borderOnForeground: true,
      margin: EdgeInsets.only(bottom: 5, top: 10, left: 10, right: 10),
      child: Container(
        child: Column(
          children: [
            quoteBody(),
            iconsBar(context, makerProvider),
          ],
        ),
      ),
    );
  }

  Widget iconsBar(context, MakerProvider makerProvider) {
    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        IconButton(
            icon: Icon(Icons.save_outlined),
            onPressed: () {
              Provider.of<DatabaseProvider>(context, listen: false).save(
                  context,
                  Saved(
                    id: Uuid().v1(),
                    fontSize: makerProvider.fontSize,
                    bgColor: makerProvider.bgColor,
                    fontAlign: makerProvider.fontAlign,
                    fontColor: makerProvider.fontColor,
                    fontDec: makerProvider.fontDec,
                    fontName: makerProvider.fontName,
                    fontStyles: makerProvider.fontStyles,
                    hPadding: makerProvider.hPadding,
                    text: makerProvider.text,
                    vPadding: makerProvider.vPadding,
                  ));
            }),
        IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              Provider.of<AdsProvider>(context, listen: false).getFullScreen();
              SocialShare.copyToClipboard(makerProvider.text ?? "لا يوجد نص")
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

  Widget quoteBody() {
    return Screenshot(
      controller: screenshotController,
      child: Consumer<MakerProvider>(
        builder: (context, provider, child) {
          List<TextDecoration> textDecorations = [];

          if (provider.fontStyles.contains("overline")) {
            textDecorations.add(TextDecoration.overline);
          }
          if (provider.fontStyles.contains("lineThrough")) {
            textDecorations.add(TextDecoration.lineThrough);
          }
          if (provider.fontStyles.contains("underline")) {
            textDecorations.add(TextDecoration.underline);
          }

          return Container(
            decoration: BoxDecoration(
              color: provider.bgColor ?? Colors.white70,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4), topRight: Radius.circular(4)),
            ),
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: provider.vPadding, horizontal: provider.hPadding),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(FontAwesome.quote_right,
                        color: provider.fontColor ?? Colors.black),
                  ],
                ),
                Center(
                  child: Text(
                    provider.text ?? "لا يوجد نص",
                    textAlign: provider.fontAlign,
                    style: TextStyle(
                        decoration: TextDecoration.combine(textDecorations),
                        fontStyle: provider.fontStyles.contains("italic")
                            ? FontStyle.italic
                            : FontStyle.normal,
                        fontWeight: provider.fontStyles.contains("bold")
                            ? FontWeight.w800
                            : FontWeight.normal,
                        fontSize: provider.fontSize ?? 35,
                        fontFamily: provider.fontName ?? "hor",
                        color: provider.fontColor ?? Colors.black),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(FontAwesome.quote_left,
                        color: provider.fontColor ?? Colors.black),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget fontStyles(makerProvider) {
    return SmartSelect<String>.multiple(
      title: 'ستايل الخط',
      value: makerProvider.fontStyles,
      choiceItems: makerProvider.styles,
      modalType: S2ModalType.bottomSheet,
      choiceType: S2ChoiceType.checkboxes,
      modalConfirm: true,
      onChange: (state) {
        makerProvider.fontStyles = state.value;
      },
      choiceTitleBuilder: (context, choice, searchText) {
        return Text(
          choice.title,
          style: TextStyle(
              fontStyle: choice.value == "italic"
                  ? FontStyle.italic
                  : FontStyle.normal,
              decoration: choice.value == "overline"
                  ? TextDecoration.overline
                  : choice.value == "lineThrough"
                      ? TextDecoration.lineThrough
                      : choice.value == "underline"
                          ? TextDecoration.underline
                          : TextDecoration.none,
              fontWeight:
                  choice.value == "bold" ? FontWeight.w800 : FontWeight.normal),
        );
      },
      choiceStyle: const S2ChoiceStyle(activeColor: Config.ACCENT_COLOR),
      tileBuilder: (context, state) {
        return S2Tile.fromState(
          state,
          isTwoLine: true,
          trailing: Icon(Icons.keyboard_arrow_left_rounded),
        );
      },
    );
  }

  Widget fontName(makerProvider) {
    return SmartSelect<String>.single(
      title: 'نوع الخط',
      value: makerProvider.fontName,
      choiceItems: makerProvider.fonts,
      choiceStyle: const S2ChoiceStyle(activeColor: Config.ACCENT_COLOR),
      modalType: S2ModalType.bottomSheet,
      choiceType: S2ChoiceType.radios,
      onChange: (state) {
        makerProvider.fontName = state.value;
      },
      choiceTitleBuilder: (context, choice, searchText) {
        return Text(
          choice.title,
          style: TextStyle(fontFamily: choice.value, fontSize: 20),
        );
      },
      tileBuilder: (context, state) {
        return S2Tile.fromState(
          state,
          isTwoLine: true,
          trailing: Icon(Icons.keyboard_arrow_left_rounded),
        );
      },
    );
  }

  Widget fontColor(context, makerProvider) {
    return ListTile(
      onTap: () => fontColorDialog(context, makerProvider),
      title: Text("لون الخط"),
      trailing: CircleAvatar(
        backgroundColor: makerProvider.fontColor,
        radius: 15,
      ),
    );
  }

  Widget fontAlign(makerProvider) {
    return SmartSelect<TextAlign>.single(
      title: 'مكان النص',
      value: makerProvider.fontAlign,
      choiceItems: makerProvider.aligns,
      modalType: S2ModalType.bottomSheet,
      choiceType: S2ChoiceType.radios,
      onChange: (state) {
        makerProvider.fontAlign = state.value;
      },
      choiceStyle: const S2ChoiceStyle(activeColor: Config.ACCENT_COLOR),
      tileBuilder: (context, state) {
        return S2Tile.fromState(
          state,
          isTwoLine: true,
          trailing: Icon(Icons.keyboard_arrow_left_rounded),
        );
      },
    );
  }

  Widget fontSize() {
    return Column(
      children: [
        Text("حجم الخط"),
        Consumer<MakerProvider>(
          builder: (context, provider, child) {
            return Slider(
              max: 70,
              min: 15,
              value: provider.fontSize,
              onChanged: (value) {
                provider.fontSize = value.roundToDouble();
              },
            );
          },
        ),
      ],
    );
  }

  Widget fontDec(makerProvider) {
    return SmartSelect<String>.single(
      title: 'الزخرفة',
      value: makerProvider.fontDec,
      choiceItems: makerProvider.decs,
      modalType: S2ModalType.bottomSheet,
      choiceType: S2ChoiceType.radios,
      onChange: (state) {
        makerProvider.fontDec = state.value;
      },
      choiceStyle: const S2ChoiceStyle(activeColor: Config.ACCENT_COLOR),
      choiceTitleBuilder: (context, choice, searchText) {
        return Text(
          choice.title,
          style: TextStyle(fontFamily: choice.value, fontSize: 20),
        );
      },
      tileBuilder: (context, state) {
        return S2Tile.fromState(
          state,
          isTwoLine: true,
          trailing: Icon(Icons.keyboard_arrow_left_rounded),
        );
      },
    );
  }

  Widget bgColor(context, makerProvider) {
    return ListTile(
      onTap: () => bgColorDialog(context, makerProvider),
      title: Text("لون الخلفية"),
      trailing: CircleAvatar(
        backgroundColor: makerProvider.bgColor,
        radius: 15,
      ),
    );
  }

  Widget vPadding() {
    return Column(
      children: [
        Text("المسافة الراسية"),
        Consumer<MakerProvider>(
          builder: (context, provider, child) {
            return Slider(
              max: 120,
              min: 0,
              value: provider.vPadding,
              onChanged: (value) {
                provider.vPadding = value.roundToDouble();
              },
            );
          },
        ),
      ],
    );
  }

  Widget hPadding() {
    return Column(
      children: [
        Text("المسافة الافقيه"),
        Consumer<MakerProvider>(
          builder: (context, provider, child) {
            return Slider(
              max: 70,
              min: 0,
              value: provider.hPadding,
              onChanged: (value) {
                provider.hPadding = value.roundToDouble();
              },
            );
          },
        ),
      ],
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

  fontColorDialog(context, makerProvider) {
    MaterialColor white = MaterialColor(
      Colors.white.value,
      <int, Color>{
        500: Colors.white,
      },
    );

    MaterialColor black = MaterialColor(
      Colors.black.value,
      <int, Color>{
        500: Colors.black,
      },
    );

    List<ColorSwatch> colors = [];
    colors.addAll(Colors.primaries);
    colors.add(white);
    colors.add(Colors.grey);
    colors.add(black);

    Alert(
      context: context,
      content: Container(
        child: Container(
          child: MaterialColorPicker(
            onColorChange: (Color color) {
              makerProvider.fontColor = color;
            },
            onlyShadeSelection: true,
            circleSize: 50,
            onMainColorChange: (value) {
              makerProvider.fontColor = value;
            },
            selectedColor: makerProvider.fontColor,
            colors: colors,
          ),
          height: 250,
        ),
        width: double.infinity,
      ),
      title: "اختر لون",
      buttons: [
        DialogButton(
            child: Text(
              "تم",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            }),
        DialogButton(
            color: Colors.red,
            child: Text(
              "الغاء",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            }),
      ],
    ).show();
  }

  bgColorDialog(context, makerProvider) {
    MaterialColor white = MaterialColor(
      Colors.white.value,
      <int, Color>{
        500: Colors.white,
      },
    );

    MaterialColor black = MaterialColor(
      Colors.black.value,
      <int, Color>{
        500: Colors.black,
      },
    );

    List<ColorSwatch> colors = [];
    colors.addAll(Colors.primaries);
    colors.add(white);
    colors.add(Colors.grey);
    colors.add(black);
    Alert(
      context: context,
      content: Container(
        child: Container(
          child: MaterialColorPicker(
            onColorChange: (Color color) {
              makerProvider.bgColor = color;
            },
            onlyShadeSelection: true,
            circleSize: 50,
            colors: colors,
            onMainColorChange: (value) {
              makerProvider.bgColor = value;
            },
            selectedColor: makerProvider.bgColor,
          ),
          height: 250,
        ),
        width: double.infinity,
      ),
      title: "اختر لون",
      buttons: [
        DialogButton(
            child: Text(
              "تم",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            }),
        DialogButton(
            color: Colors.red,
            child: Text(
              "الغاء",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            }),
      ],
    ).show();
  }
}
