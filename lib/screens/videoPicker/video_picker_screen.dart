import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/controllers/youtube_controller.dart';
import 'package:notes/ui/background.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as youtube;

class VideoPickerScreen extends StatefulWidget {
  @override
  _VideoPickerScreenState createState() => _VideoPickerScreenState();
}

class _VideoPickerScreenState extends State<VideoPickerScreen> {
  TextEditingController _searchController = TextEditingController();
  List<youtube.Video> _searchResults = [];
  bool loading = false;
  Future _searchVideos(String query) async {
    youtube.YoutubeExplode ytExplode = youtube.YoutubeExplode();
    var searchList = await ytExplode.search.getVideos(query);

    setState(() {
      _searchResults = searchList;
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
    final youtubeController = Provider.of<YoutubeController>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(72, 0, 0, 0),
        title: const Text('اختيار مقطع'),
      ),
      body: Mybackground(
        screens: [
          SizedBox(
            height: 130,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن فيديو',
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
                        child: Icon(
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
            Expanded(
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
                    onTap: () {
                      youtubeController.setVideoId(video.thumbnails.videoId);

                      Navigator.pop(context, video);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(10),
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
                                      video.thumbnails.highResUrl,
                                    )),
                                SizedBox(
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
                                        style: TextStyle(
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
