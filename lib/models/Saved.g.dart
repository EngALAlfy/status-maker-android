// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Saved.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Saved _$SavedFromJson(Map<String, dynamic> json) {
  return Saved(
    id: json['id'] as String,
    text: json['text'] as String,
    fontName: json['fontName'] as String,
    fontStyles: (json['fontStyles'] as List)?.map((e) => e as String)?.toList(),
    bgColor: const ColorJson().fromJson(json['bgColor'] as int),
    fontColor: const ColorJson().fromJson(json['fontColor'] as int),
    fontDec: json['fontDec'] as String,
    fontSize: (json['fontSize'] as num)?.toDouble(),
    vPadding: (json['vPadding'] as num)?.toDouble(),
    hPadding: (json['hPadding'] as num)?.toDouble(),
    fontAlign: const TextAlignJson().fromJson(json['fontAlign'] as int),
  );
}

Map<String, dynamic> _$SavedToJson(Saved instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'fontName': instance.fontName,
      'fontStyles': instance.fontStyles,
      'bgColor': const ColorJson().toJson(instance.bgColor),
      'fontColor': const ColorJson().toJson(instance.fontColor),
      'fontDec': instance.fontDec,
      'fontSize': instance.fontSize,
      'vPadding': instance.vPadding,
      'hPadding': instance.hPadding,
      'fontAlign': const TextAlignJson().toJson(instance.fontAlign),
    };
