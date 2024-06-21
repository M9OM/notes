import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/ads_model.dart';
import 'package:notes/utils/constants/color.dart';
import 'package:notes/utils/constants/screenSize.dart';
import 'package:url_launcher/url_launcher.dart';

class AdsShape extends StatelessWidget {
  const AdsShape({
    Key? key,
    required this.ad,
  }) : super(key: key);

  final AdModel ad;
  Future<void> _launchUrl(String _url) async {
    final Uri url = Uri.parse(_url);

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: ScreenSizeExtension(context).screenWidth * 0.95,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.09),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: ad.imageUrl.contains('http')
                            ? CachedNetworkImage(
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: primary.withOpacity(0.3),
                                  width: 65,
                                  height: 65,
                                ),
                                width: 65,
                                height: 65,
                                imageUrl: ad.imageUrl,
                              )
                            : Image.asset(
                                fit: BoxFit.fill,
                                width: 65,
                                height: 65,
                                'assets/avatar/${ad.imageUrl}.jpeg',
                              ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth:
                                  ScreenSizeExtension(context).screenWidth *
                                      0.6, // Adjust width to avoid overflow
                            ),
                            child: Text(
                              ad.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                overflow:
                                    TextOverflow.ellipsis, // Prevent overflow
                              ),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth:
                                  ScreenSizeExtension(context).screenWidth *
                                      0.6, // Adjust width to avoid overflow
                            ),
                            child: Text(
                              ad.subtitle,
                              style: TextStyle(
                                color: primary,
                                overflow:
                                    TextOverflow.ellipsis, // Prevent overflow
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: const Text(
                        'Ad',
                        style: TextStyle(color: Colors.black, fontSize: 10),
                      )),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  _launchUrl(ad.url);
                },
                child: Center(
                  child: Container(
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(10),
                    width: ScreenSizeExtension(context).screenWidth * 0.95,
                    child: const Text(
                      'Go',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
