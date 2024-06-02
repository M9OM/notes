import 'package:flutter/material.dart';
import '../../room_screen/room_screen.dart';
import '/utils/constants/color.dart';
import '/utils/constants/screenSize.dart';

class NoteForm extends StatefulWidget {
  final String uid, username, text, urlImage;

  NoteForm({
    Key? key,
    required this.uid,
    required this.username,
    required this.text,
    required this.urlImage,
  }) : super(key: key);

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30,
        left: 20,
        right: 20,
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          SizedBox(
            height: 250,
          ),
          Container(
            width: ScreenSizeExtension(context).screenWidth * 0.7,
            height: ScreenSizeExtension(context).screenWidth * 0.65,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 35, 35, 35),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.username + '@'),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _switchValue = !_switchValue;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _switchValue
                              ? primary
                              : GetThemeData(context).theme.highlightColor,
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: _switchValue ? Colors.red : null,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RoomScreen(
                                    roomId: '',
                                  )),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: GetThemeData(context).theme.highlightColor,
                        ),
                        child: Icon(Icons.chat_bubble),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: 150,
            child: CircleAvatar(
              backgroundColor: primary,
              radius: 55,
              child: ClipOval(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Image.network(
                    widget.urlImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
