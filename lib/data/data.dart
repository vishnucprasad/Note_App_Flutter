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
  final dio = Dio();
  final url = Url();

  // Singleton //

  NoteDB._internal() {
    dio.options = BaseOptions(
      baseUrl: url.baseUrl,
      responseType: ResponseType.plain,
    );
  }

  static NoteDB instance = NoteDB._internal();

  NoteDB factory() {
    return instance;
  }

  // Singleton //

  ValueNotifier<List<NoteModel>> noteListNotifier = ValueNotifier([]);

  @override
  Future<NoteModel?> createNote(NoteModel value) async {
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
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    final _result = await dio.delete(url.deleteNote.replaceFirst('{id}', id));

    if (_result.data == null) {
      return;
    }

    final _index = noteListNotifier.value.indexWhere((note) => note.id == id);

    if (_index == -1) {
      return;
    }

    noteListNotifier.value.removeAt(_index);
    noteListNotifier.notifyListeners();
  }

  @override
  Future<List<NoteModel>> getAllNotes() async {
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
    final _result = await dio.put(url.updateNote, data: value.toJson());
    if (_result.data == null) {
      return null;
    }

    // find index
    final _index =
        noteListNotifier.value.indexWhere((note) => note.id == value.id);
    if (_index == -1) {
      return null;
    }

    // remove from index
    noteListNotifier.value.removeAt(_index);

    // add note in that index
    noteListNotifier.value.insert(_index, value);
    noteListNotifier.notifyListeners();
    return value;
  }

  NoteModel? getNoteById(String id) {
    try {
      return noteListNotifier.value.firstWhere((note) => note.id == id);
    } catch (_) {
      return null;
    }
  }
}
