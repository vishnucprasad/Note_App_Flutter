import 'package:json_annotation/json_annotation.dart';
import 'package:note_app/data/note_model/note_model.dart';

part 'get_all_notes_response.g.dart';

@JsonSerializable()
class GetAllNotesResponse {
  @JsonKey(name: 'data')
  List<NoteModel> data;

  GetAllNotesResponse({this.data = const []});

  factory GetAllNotesResponse.fromJson(Map<String, dynamic> json) {
    return _$GetAllNotesResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$GetAllNotesResponseToJson(this);
}
