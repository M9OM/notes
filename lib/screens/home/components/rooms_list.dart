import 'package:flutter/material.dart';
import 'package:notes/screens/home/components/rooms_shape.dart';
import 'package:notes/services/room_service.dart';
import '../../../models/rooms_model.dart';
import '/models/note_model.dart';
import '/screens/notes_screen/components/note_form.dart';

class RoomsList extends StatelessWidget {
  const RoomsList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Rooms?>>(
      stream: ChatService().getAllRooms(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If data is still loading, return a loading indicator
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // If there's an error with the stream, display the error message
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // If there's no data or the data list is empty, display a message
          return Center(child: Text('No rooms found'));
        } else {
          // If data is available, build the ListView with rooms
          List<Rooms?> roomsList = snapshot.data!;

          return ListView.builder(
            itemCount: roomsList.length,
            itemBuilder: (context, index) {
              return RoomsShape(
                roomId: roomsList[index]!.roomId,
                imageUrl: roomsList[index]!.avtarRoomUrl,
                title: roomsList[index]!.roomName,
                subtitle: roomsList[index]!.roomType,
                membersData: roomsList[index]!.membersData,
              );
            },
          );
        }
      },
    );
  }
}
