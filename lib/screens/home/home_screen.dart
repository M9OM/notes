import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:notes/controllers/loading_controller.dart';
import 'package:notes/screens/add_room/add_room.dart';
import 'package:notes/screens/auth/login_screen.dart';
import 'package:notes/screens/home/components/room_list/room_general.dart';
import 'package:notes/screens/home/components/room_list/room_home.dart';
import 'package:notes/services/auth_service.dart';
import 'package:notes/services/follow_service.dart';
import 'package:notes/ui/avatar_widget.dart';
import 'package:notes/utils/constants/lang/str_extntion.dart';
import 'package:notes/utils/constants/lang/translate_constat.dart';
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
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this); // Initialize TabController
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final loadingController = Provider.of<LoadingController?>(context);

    if (user == null) {
      return const LoginScreen();
    }

    return ModalProgressHUD(
      inAsyncCall: loadingController!.isloading,
      color: Colors.black,
      blur: 5.0,
      opacity: 0.5,
      progressIndicator: CupertinoActivityIndicator(radius: 15),
      child: Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          surfaceTintColor: Colors.black.withOpacity(0.9),
          backgroundColor: Colors.black.withOpacity(0.1),
          iconTheme: const IconThemeData(color: Colors.white),
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
                uid: user.uid,
                builder: (context, snapshot) {
                  UserModel userData = snapshot.data!;
                  return AvatarWidget(
                      radius: 20, photoURL: userData!.photoURL!);
                },
                loading: const CircleAvatar(),
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: Container(
              color: Colors.black12,
              child: TabBar(
                controller: _tabController, // Assign TabController to TabBar
                indicatorColor: primary,
                labelColor: primary,
                unselectedLabelColor: Colors.white,
                tabs: [
                  Tab(text: TranslationConstants.for_you.t(context)),
                  Tab(text: TranslationConstants.following.t(context)),
                ],
              ),
            ),
          ),
        ),
        drawer: const MyDrawer(),
        body: Mybackground(
          mainAxisAlignment: MainAxisAlignment.center,
          screens: [
            SizedBox(height: 170),
            Expanded(
              child: TabBarView(
                controller:
                    _tabController, // Assign TabController to TabBarView
                children: const [
                  RoomsGeneralList(),
                  RoomHomeList(), // Replace with your new widget
                ],
              ),
            ),
          ],
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
