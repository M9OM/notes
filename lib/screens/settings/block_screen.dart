import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/screens/settings/components/block_list.dart';
import 'package:notes/ui/background.dart';
import 'package:provider/provider.dart';

class BlockScreen extends StatelessWidget {
  const BlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent,),
      body: Mybackground(screens: [
        Expanded(
          child: BlockList(
            userId: user!.uid,
          ),
        )
      ], mainAxisAlignment: MainAxisAlignment.start),
    );
  }
}
