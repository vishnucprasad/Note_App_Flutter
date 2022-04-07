// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_notes_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllNotesResponse _$GetAllNotesResponseFromJson(Map<String, dynamic> json) =>
    GetAllNotesResponse(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => NoteModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GetAllNotesResponseToJson(
        GetAllNotesResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
