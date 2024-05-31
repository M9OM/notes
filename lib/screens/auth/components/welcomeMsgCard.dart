import 'package:flutter/material.dart';
import '/utils/constants/color.dart';

class WelcomeMsg extends StatelessWidget {
  const WelcomeMsg({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 300,
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
                bottomRight: Radius.circular(40))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ترحيب',
              style: myMsgStyle,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "مرحبًا بك في تطبيقنا! هنا، يمكنك الانضمام إلى أشخاص يشاركونك نفس اهتماماتك وشغفك. ادخل غرفنا العشوائية واستمتع بالتواصل مع مجتمعنا المتنوع. نحن متحمسون لرؤيتك تنخرط وتستفيد من تجربتك هنا.",
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
