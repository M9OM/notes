import 'package:flutter/material.dart';
import 'package:notes/screens/home/components/rooms_shape.dart';
import '../../../models/rooms_model.dart';
import '/models/note_model.dart';
import '/screens/notes_screen/components/note_form.dart';

class RoomsList extends StatelessWidget {
  const RoomsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: RoomsModel.roomsList.length,
      itemBuilder: (context, index) {
        RoomsModel roomsList = RoomsModel.roomsList[index];
        return  RoomsShape(
          imageUrl: roomsList.imageUrl,
          title: roomsList.title,
          subtitle:roomsList.subtitle,
        );
      },
    );
  }
}
