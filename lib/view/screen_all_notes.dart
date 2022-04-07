import 'package:flutter/material.dart';
import 'package:note_app/data/data.dart';
import 'package:note_app/data/note_model/note_model.dart';
import 'package:note_app/view/screen_add_note.dart';

class ScreenAllNotes extends StatelessWidget {
  const ScreenAllNotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await NoteDB.instance.getAllNotes();
    });
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('ALLNOTES'),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: NoteDB.instance.noteListNotifier,
          builder: (BuildContext context, List<NoteModel> newList, _) {
            return GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              padding: const EdgeInsets.all(20),
              children: List.generate(
                newList.length,
                (index) {
                  final _note = newList[index];

                  if (_note.id == null) {
                    const SizedBox();
                  }

                  return NoteItem(
                    id: _note.id!,
                    title: _note.title ?? 'No Title',
                    content: _note.content ?? 'No Content',
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => ScreenAddNote(type: ActionType.addNote),
            ),
          );
        },
        label: const Text('New'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.greenAccent,
      ),
    );
  }
}

class NoteItem extends StatelessWidget {
  final String id;
  final String title;
  final String content;
  const NoteItem({
    Key? key,
    required this.id,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ScreenAddNote(type: ActionType.editNote, id: id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                )
              ],
            ),
            Text(
              content,
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}
