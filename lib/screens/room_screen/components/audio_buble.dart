import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import '/utils/constants/color.dart';

class AudioBuble extends StatelessWidget {
  const AudioBuble({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RecordingDisposition>(
      stream: FlutterSoundRecorder().onProgress,
      builder: (context, snapshot) {

        final duration = snapshot.hasData?snapshot.data!.duration:Duration.zero;
        return Container(
          width: 70,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
        
              color: primary, borderRadius: BorderRadius.circular(30)),
        
        
              child: Row(
                children: [
                  Text('${duration.inSeconds} s',style: myMsgStyle,),
                  SizedBox(width: 7,),
                  Icon(Icons.play_arrow,color: Colors.black,),
                ],
              ),
        );
      }
    );
  }
}
