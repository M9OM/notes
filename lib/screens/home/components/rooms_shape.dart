import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:notes/utils/constants/screenSize.dart';

class RoomsShape extends StatelessWidget {
  const RoomsShape(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.subtitle});
  final String imageUrl;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
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
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                          width: 60,
                          imageUrl)),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(color: primary),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(
                        'https://i.pinimg.com/564x/f4/60/7d/f4607d55aa1fb025cc5da6f7b7cea33b.jpg'),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(
                        'https://i.pinimg.com/564x/a9/68/51/a9685154fa3f5791143c3e8a94289d9d.jpg'),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(
                        'https://i.pinimg.com/564x/1b/29/59/1b29599af9152a26df55135e70857572.jpg'),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('و ٥ اخرون')
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                  child: Container(
                      alignment: AlignmentDirectional.center,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.all(10),
                      width: ScreenSizeExtension(context).screenWidth * 0.95,
                      child: Text(
                        'انضمام',
                        style: TextStyle(color: Colors.white),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
