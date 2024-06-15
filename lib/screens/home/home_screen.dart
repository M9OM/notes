import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:notes/controllers/loading_controller.dart';
import 'package:notes/screens/add_room/add_room.dart';
import 'package:notes/screens/auth/login_screen.dart';
import 'package:notes/screens/room_screen/room_screen.dart';
import 'package:notes/services/auth_service.dart';
import 'package:notes/services/follow_service.dart';
import 'package:provider/provider.dart';
import '../../controllers/user_stream_controller.dart';
import '../../models/user_model.dart';
import '../../route/route_screen.dart';
import '../../ui/background.dart';
import '../../utils/constants/assets_constants.dart';
import '../../utils/constants/color.dart';
import 'components/drawer.dart';
import 'components/rooms_list.dart';











class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
        final loadingController = Provider.of<LoadingController?>(context);

    if (user == null) {
      // إذا كان المستخدم null، يمكنك إعادة توجيهه إلى شاشة تسجيل الدخول أو إظهار رسالة خطأ
      return const LoginScreen();
    }
    return ModalProgressHUD(
      inAsyncCall: loadingController!.isloading,
      color : Colors.black,
      blur : 5.0,
      opacity: 0.5,
      progressIndicator: CupertinoActivityIndicator(radius:15) ,
      child: Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          surfaceTintColor: Colors.black.withOpacity(0.9),
          backgroundColor: Colors.black.withOpacity(0.1),
          iconTheme: const IconThemeData(
              color:
                  Colors.white), // Set the icon color to white or any other color
          title: SvgPicture.asset(
            AssetsConstants.logoSvg,
            color: primary,
            width: 35,
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                          HapticFeedback.mediumImpact();
      
                _scaffoldKey.currentState?.openDrawer();
              },
              child: UserStreamBuilder(
                uid: user!.uid,
                builder: (context, snapshot) {
                  UserModel userData = snapshot.data!;
      
                  return CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/avatar/${userData.photoURL!}.jpeg'),
                  );
                  // ignore: prefer_const_constructors
                },
                loading: const CircleAvatar(),
              ),
            ),
          ),
          actions: [
            // IconButton(
            //   icon: const Icon(Icons.search, color: Colors.white),
            //   onPressed: () async {
            //     List<UserModel> failedFollowers =
            //         await FollowService().getFollowersData(user.uid);
      
            //     List<String> email = [];
            //     for (var i = 0; i < failedFollowers.length; i++) {
            //       email.add(failedFollowers[i].email.toString());
            //     }
      
            //     print(email);
            //   },
            // ),
          ],
        ),
        drawer: const MyDrawer(),
        body: Mybackground(
          mainAxisAlignment: MainAxisAlignment.center,
          screens: const [
            
                      SizedBox(height: 130,),
      
            Expanded(child: RoomsList())],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add, size: 30, color: Colors.black),
          onPressed: () {
                      HapticFeedback.mediumImpact();
      
            navigateToCreateRoomScreen(context, const AddRoomScreen());
          },
        ),
      ),
    );
  }
}
