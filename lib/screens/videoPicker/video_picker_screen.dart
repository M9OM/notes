import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/controllers/youtube_controller.dart';
import 'package:notes/services/room_service.dart';
import 'package:notes/ui/background.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:notes/utils/constants/lang/str_extntion.dart';
import 'package:notes/utils/constants/lang/translate_constat.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as youtube;

class VideoPickerScreen extends StatefulWidget {
  @override
  const VideoPickerScreen({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  final String roomId;

  _VideoPickerScreenState createState() => _VideoPickerScreenState();
}

class _VideoPickerScreenState extends State<VideoPickerScreen> {
  TextEditingController _searchController = TextEditingController();
  List<youtube.Video> _searchResults = [];
  bool loading = false;

  Future<void> _searchVideos(String query) async {
    youtube.YoutubeExplode ytExplode = youtube.YoutubeExplode();
    var searchList = await ytExplode.search.getVideos(query);

    setState(() {
      // Filter out live videos
      _searchResults = searchList.where((video) => !video.isLive).toList();
    });
    ytExplode.close();
  }

  String getChannelProfilePictureUrl(String channelId) {
    // Replace this with actual implementation to get the channel's profile picture URL
    return 'https://via.placeholder.com/150';
  }

  @override
  void initState() {
    _searchVideos('قرآن');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(72, 0, 0, 0),
        title: Text(TranslationConstants.select_clip.t(context)),
      ),
      body: Mybackground(
        mainAxisAlignment: MainAxisAlignment.start,
        screens: [
          const SizedBox(
            height: 130,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primary)),
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                hintText: TranslationConstants.search_video.t(context),
                suffixIcon: InkWell(
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });
                    await _searchVideos(_searchController.text);

                    setState(() {
                      loading = false;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          weight: 30,
                          size: 30,
                          Icons.search,
                          color: Colors.black,
                        )),
                  ),
                ),
              ),
            ),
          ),
          if (loading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  var video = _searchResults[index];
                  return InkWell(
                    onTap: () async {
                      await ChatService().setVideo(widget.roomId, '');

                      ChatService()
                          .setVideo(widget.roomId, video.thumbnails.videoId);
                      Navigator.pop(context, video);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    GetThemeData(context).theme.highlightColor),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      fit: BoxFit.cover,
                                      video.thumbnails.highResUrl,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        video.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(video.author),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                  //  ListTile(
                  //   leading: Image.network(video.thumbnails.highResUrl),
                  //   title: Text(video.title),
                  //   onTap: () {
                  //     youtubeController
                  //         .setVideoId(video.thumbnails.videoId);

                  //     Navigator.pop(context, video);
                  //   },
                  // );
                },
              ),
            ),
        ],
      ),
    );
  }
}
