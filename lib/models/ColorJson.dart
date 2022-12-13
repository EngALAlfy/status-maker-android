import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

class ColorJson implements JsonConverter<Color, int> {
  const ColorJson();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color color) => color.value;
}