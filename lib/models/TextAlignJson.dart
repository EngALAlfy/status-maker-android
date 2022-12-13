import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

class TextAlignJson implements JsonConverter<TextAlign, int> {
  const TextAlignJson();

  @override
  TextAlign fromJson(int index) => TextAlign.values.elementAt(index);

  @override
  int toJson(TextAlign textAlign) => textAlign.index;
}
