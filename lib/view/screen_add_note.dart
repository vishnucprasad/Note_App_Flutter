import 'package:flutter/material.dart';
import 'package:note_app/data/data.dart';
import 'package:note_app/data/note_model/note_model.dart';

enum ActionType {
  addNote,
  editNote,
}

class ScreenAddNote extends StatelessWidget {
  final ActionType type;
  String? id;
  ScreenAddNote({
    Key? key,
    required this.type,
    this.id,
  }) : super(key: key);

  Widget get saveButton => TextButton.icon(
        onPressed: () {
          switch (type) {
            case ActionType.addNote:
              saveNote();
              break;
            case ActionType.editNote:
              // Edit note
              break;
          }
        },
        icon: const Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: const Text(
          'Save',
          style: TextStyle(color: Colors.white),
        ),
      );

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(type.name.toUpperCase()),
        actions: [
          saveButton,
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Title',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _contentController,
                maxLines: 4,
                maxLength: 100,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Content',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveNote() async {
    final _title = _titleController.text;
    final _content = _contentController.text;

    final _newNote = NoteModel.create(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _title,
      content: _content,
    );

    final newNote = await NoteDB.instance.createNote(_newNote);

    if (newNote != null) {
      Navigator.of(_scaffoldKey.currentContext!).pop();
    } else {
      print('Error while saving note.');
    }
  }
}
