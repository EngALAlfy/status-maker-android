import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:status_maker/models/ColorJson.dart';
import 'package:status_maker/models/TextAlignJson.dart';

part 'Saved.g.dart';

@JsonSerializable()
class Saved {
  String id;

  String text = "سيظهر النص هنا";

  String fontName = "";

  List<String> fontStyles = [];

  @ColorJson()
  Color bgColor = Colors.white;
  @ColorJson()
  Color fontColor = Colors.black;

  String fontDec = "none";

  double fontSize = 20.0;

  double vPadding = 50.0;

  double hPadding = 20.0;

  @TextAlignJson()
  TextAlign fontAlign = TextAlign.start;

  @JsonKey(ignore: true)
  bool isAd = false;

  Saved(
      {this.id,
      this.text,
      this.fontName,
      this.fontStyles,
      this.bgColor,
      this.fontColor,
      this.fontDec,
      this.fontSize,
      this.vPadding,
      this.hPadding,
      this.fontAlign,
      this.isAd = false});

  factory Saved.fromJson(Map<String, dynamic> json) => _$SavedFromJson(json);

  Map<String, dynamic> toJson() => _$SavedToJson(this);
}
