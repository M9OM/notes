import 'package:flutter/material.dart';
import '/controllers/loading_controller.dart';
import '/services/auth_service.dart';
import '/ui/background.dart';
import 'package:provider/provider.dart';

import 'components/note_list.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Mybackground(
        mainAxisAlignment  : MainAxisAlignment.center,
        screens: [
        const SizedBox(
          height: 50,
        ),
        Row(
          children: [
            Consumer<LoadingController>(
                builder: (context, authController, child) {
              return IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () async {
                    authController.loading(true);
                    await AuthService().signOut();
                    authController.loading(false);
                  });
            }),
          ],
        ),
        const Expanded(child: NoteList())
      ]),
    );
  }
}
