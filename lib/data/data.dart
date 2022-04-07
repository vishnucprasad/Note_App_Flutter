import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:note_app/data/get_all_notes_response/get_all_notes_response.dart';
import 'package:note_app/data/note_model/note_model.dart';
import 'package:note_app/data/url.dart';

abstract class ApiCalls {
  Future<NoteModel?> createNote(NoteModel value);
  Future<List<NoteModel>> getAllNotes();
  Future<NoteModel?> update(NoteModel value);
  Future<void> deleteNote(String id);
}

class NoteDB extends ApiCalls {
  // Singleton //

  NoteDB._internal();

  static NoteDB instance = NoteDB._internal();

  NoteDB factory() {
    return instance;
  }

  // Singleton //

  final dio = Dio();
  final url = Url();

  ValueNotifier<List<NoteModel>> noteListNotifier = ValueNotifier([]);

  @override
  Future<NoteModel?> createNote(NoteModel value) async {
    dio.options = BaseOptions(
      baseUrl: url.baseUrl,
      responseType: ResponseType.plain,
    );
    try {
      final _result = await dio.post(
        url.addNote,
        data: value.toJson(),
      );
      final _resultAsJson = jsonDecode(_result.data);
      final _newNote = NoteModel.fromJson(
        _resultAsJson as Map<String, dynamic>,
      );
      noteListNotifier.value.insert(0, _newNote);
      noteListNotifier.notifyListeners();
      return _newNote;
    } on DioError catch (e) {
      print(e.response?.data);
      print(e);
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    // TODO: implement deleteNote
    throw UnimplementedError();
  }

  @override
  Future<List<NoteModel>> getAllNotes() async {
    dio.options = BaseOptions(
      baseUrl: url.baseUrl,
      responseType: ResponseType.plain,
    );
    final _result = await dio.get(url.getAllNotes);
    if (_result.data != null) {
      final _resultAsJson = jsonDecode(_result.data);
      final getNoteResponse = GetAllNotesResponse.fromJson(_resultAsJson);
      noteListNotifier.value.clear();
      noteListNotifier.value.addAll(getNoteResponse.data.reversed);
      noteListNotifier.notifyListeners();
      return getNoteResponse.data;
    } else {
      noteListNotifier.value.clear();
      return [];
    }
  }

  @override
  Future<NoteModel?> update(NoteModel value) async {
    // TODO: implement update
    throw UnimplementedError();
  }
}
