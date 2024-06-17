import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/models/user_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:notes/screens/home/components/rooms_shape.dart';
import 'package:notes/services/room_service.dart';
import 'package:notes/models/rooms_model.dart';

class RoomsGeneralList extends StatefulWidget {
  const RoomsGeneralList({super.key});

  @override
  _RoomsGeneralListState createState() => _RoomsGeneralListState();
}

class _RoomsGeneralListState extends State<RoomsGeneralList> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<Rooms?> _roomsGeneralList = [];
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  Future<void> _fetchRooms({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() {
        _lastDocument = null;
        _hasMore = true;
      });
    }

    RoomService roomService = RoomService();
    List<DocumentSnapshot> roomSnapshots =
        await roomService.getRooms(startAfter: _lastDocument, limit: 5);

    List<Rooms?> newRooms = [];
    for (var roomSnapshot in roomSnapshots) {
      Rooms room =
          Rooms.fromFirestore(roomSnapshot.data() as Map<String, dynamic>);

      List<UserModel> membersData = [];
      for (var member in room.membersId) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(member.uid)
            .get();
        if (userSnapshot.exists) {
          UserModel user = UserModel.fromFirestore(
              userSnapshot.data() as Map<String, dynamic>);
          user.isAdmin = member.isAdmin ?? false;
          membersData.add(user);
        }
      }

      room.membersData = membersData;
      newRooms.add(room);
    }

    if (roomSnapshots.isNotEmpty) {
      _lastDocument = roomSnapshots.last;
    } else {
      _hasMore = false;
    }

    setState(() {
      if (isRefresh) {
        _roomsGeneralList = newRooms;
      } else {
        _roomsGeneralList.addAll(newRooms);
      }
    });

    if (isRefresh) {
      _refreshController.refreshCompleted();
    } else {
      _refreshController.loadComplete();
    }
  }

  void _onRefresh() async {
    HapticFeedback.mediumImpact();

    await _fetchRooms(isRefresh: true);
    HapticFeedback.mediumImpact();
  }

  void _onLoading() async {
    if (_hasMore) {
      await _fetchRooms();
    } else {
      _refreshController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: _refreshController,
    header: CustomHeader(
        builder: (BuildContext context, RefreshStatus? mode) {
          Widget body;
          if (mode == RefreshStatus.refreshing) {
            body = CupertinoActivityIndicator();
          } else {
            body = CupertinoActivityIndicator();
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else {
            body = SizedBox.shrink();
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),     
      
      
       onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.builder(
        itemCount: _roomsGeneralList.length,
        itemBuilder: (context, index) {
          final room = _roomsGeneralList[index];
          if (room == null) {
            return ListTile(title: Text('Room not found'));
          } 


          return RoomsShape(
            roomId: room.roomId,
            imageUrl: room.avtarRoomUrl,
            title: room.roomName,
            subtitle: room.roomType,
            membersData: room.membersData,
          );
        },
      ),
    );
  }
}

