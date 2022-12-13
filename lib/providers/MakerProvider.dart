import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import 'package:status_maker/utils/Config.dart';

class MakerProvider extends ChangeNotifier {
  String _text = "سيظهر النص هنا";

  String _fontName = "";

  List<String> _fontStyles = [];

  Color _bgColor = Colors.white;
  Color _fontColor = Colors.black;

  String _fontDec = "none";

  double _fontSize = 20.0;

  double _vPadding = 50.0;

  double _hPadding = 20.0;

  TextAlign _fontAlign = TextAlign.start;

  List<S2Choice<String>> fonts = Config.FONTS.keys
      .map<S2Choice<String>>((e) => S2Choice(value: e, title: Config.FONTS[e]))
      .toList();

  List<S2Choice<String>> decs = [];

  List<S2Choice<String>> styles = [
    S2Choice(title: "ثقيل", value: "bold"),
    S2Choice(title: "مائل", value: "italic"),
    S2Choice(title: "خط في الاعلي", value: "overline"),
    S2Choice(title: "خط في الوسط", value: "lineThrough"),
    S2Choice(title: "حط في الاسفل", value: "underline"),
  ];

  List<S2Choice<TextAlign>> aligns = [
    S2Choice(value: TextAlign.start, title: "البداية"),
    S2Choice(value: TextAlign.center, title: "المنتصف"),
    S2Choice(value: TextAlign.justify, title: "محاذاه"),
    S2Choice(value: TextAlign.end, title: "النهاية"),
  ];

  MakerProvider() {
    decs = List.generate(14, (index) => index)
        .map<S2Choice<String>>(
            (e) => S2Choice(value: "$e", title: textDec("$e", "زخرفة حروف $e")))
        .toList();
  }

  List<String> get fontStyles => _fontStyles;

  set fontStyles(List<String> value) {
    _fontStyles = value;
    notifyListeners();
  }

  double get vPadding => _vPadding;

  set vPadding(double value) {
    _vPadding = value;
    notifyListeners();
  }

  String get text => textDec(_fontDec, _text);

  set text(String value) {
    _text = value;
    notifyListeners();
  }

  TextAlign get fontAlign => _fontAlign;

  set fontAlign(TextAlign value) {
    _fontAlign = value;
    notifyListeners();
  }

  String get fontDec => _fontDec;

  set fontDec(String value) {
    _fontDec = value;
    notifyListeners();
  }

  Color get fontColor => _fontColor;

  set fontColor(Color value) {
    _fontColor = value;
    notifyListeners();
  }

  Color get bgColor => _bgColor;

  set bgColor(Color value) {
    _bgColor = value;
    notifyListeners();
  }

  String get fontName => _fontName;

  set fontName(String value) {
    _fontName = value;
    notifyListeners();
  }

  double get fontSize => _fontSize;

  set fontSize(double value) {
    _fontSize = value;
    notifyListeners();
  }

  String textDec(dec, String value) {
    switch (dec) {
      case "1":
        return value.characters.map((e) {
          if (Config.flip1.containsKey(e)) {
            return Config.flip1[e];
          }
          return e;
        }).join();
        break;
      case "2":
        return value.characters.map((e) {
          if (Config.flip2.containsKey(e)) {
            return Config.flip2[e];
          }
          return e;
        }).join();
        break;
      case "3":
        return value.characters.map((e) {
          if (Config.flip3.containsKey(e)) {
            return Config.flip3[e];
          }
          return e;
        }).join();
        break;
      case "4":
        return value.characters.map((e) {
          if (Config.flip4.containsKey(e)) {
            return Config.flip4[e];
          }
          return e;
        }).join();
        break;
      case "5":
        return value.characters.map((e) {
          if (Config.flip5.containsKey(e)) {
            return Config.flip5[e];
          }
          return e;
        }).join();
        break;
      case "6":
        return value.characters.map((e) {
          if (Config.flip6.containsKey(e)) {
            return Config.flip6[e];
          }
          return e;
        }).join();
        break;
      case "7":
        return value.characters.map((e) {
          if (Config.flip7.containsKey(e)) {
            return Config.flip7[e];
          }
          return e;
        }).join();
        break;
      case "8":
        return value.characters.map((e) {
          if (Config.flip8.containsKey(e)) {
            return Config.flip8[e];
          }
          return e;
        }).join();
        break;
      case "9":
        return value.characters.map((e) {
          if (Config.flip9.containsKey(e)) {
            return Config.flip9[e];
          }
          return e;
        }).join();
        break;
      case "10":
        return value.characters.map((e) {
          if (Config.flip10.containsKey(e)) {
            return Config.flip10[e];
          }
          return e;
        }).join();
        break;
      case "11":
        return value.characters.map((e) {
          if (Config.flip11.containsKey(e)) {
            return Config.flip11[e];
          }
          return e;
        }).join();
        break;
      case "12":
        return value.characters.map((e) {
          if (Config.flip12.containsKey(e)) {
            return Config.flip12[e];
          }
          return e;
        }).join();
        break;
      case "13":
        return value.characters.map((e) {
          if (Config.flip13.containsKey(e)) {
            return Config.flip13[e];
          }
          return e;
        }).join();
        break;
      case "none":
      default:
        return value;
    }
  }

  double get hPadding => _hPadding;

  set hPadding(double value) {
    _hPadding = value;
    notifyListeners();
  }

}
