import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/controllers/loading_controller.dart';
import 'package:notes/models/user_model.dart';
import 'package:notes/route/route_screen.dart';
import 'package:notes/screens/room_screen/room_screen.dart';
import 'package:notes/services/room_service.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:notes/utils/constants/lang/str_extntion.dart';
import 'package:notes/utils/constants/lang/translate_constat.dart';
import 'package:notes/utils/constants/screenSize.dart';
import 'package:provider/provider.dart';

class RoomsShape extends StatelessWidget {
  const RoomsShape(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.subtitle,
      required this.roomId,
      this.membersData});
  final String imageUrl;
  final String title;
  final String subtitle;
  final String roomId;
  final List<UserModel>? membersData;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final loadingController = Provider.of<LoadingController?>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: ScreenSizeExtension(context).screenWidth * 0.95,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.09)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                          width: 60, 'assets/avatar/$imageUrl.jpeg')),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(color: primary),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ...List.generate(
                    membersData!.length > 3 ? 3 : membersData!.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage(
                            'assets/avatar/${membersData![index].photoURL!}.jpeg'),
                      ),
                    ),
                  ),
                  if (membersData!.length > 3)
                    Text('  ${TranslationConstants.and.t(context)} ${membersData!.length - 3} ${TranslationConstants.others.t(context)}'),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async{
                  loadingController!.loading(true);
                await  ChatService().joinRoom(roomId, user!.uid);
                  navigateScreenWithoutGoBack(
                      context, RoomScreen(roomId: roomId));

                   loadingController.loading(false);

                },
                child: Center(
                    child: Container(
                        alignment: AlignmentDirectional.center,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.all(10),
                        width: ScreenSizeExtension(context).screenWidth * 0.95,
                        child:  Text(
                         TranslationConstants.join.t(context),
                          style: TextStyle(color: Colors.white),
                        ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
