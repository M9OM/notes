import 'package:flutter/material.dart';
import '/models/note_model.dart';
import '/screens/notes_screen/components/note_form.dart';

class NoteList extends StatelessWidget {
  const NoteList({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: NoteModel.noteData.length,
      itemBuilder: (context, index) {
        NoteModel noteList = NoteModel.noteData[index];
        return NoteForm(
          uid:noteList.uid,
          username: noteList.username,
          text: noteList.text,
          urlImage:noteList.urlImage,
        );
      },
    );
  }
}
