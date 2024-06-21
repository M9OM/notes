import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/ads_model.dart';

class AdService {
  Future<List<AdModel>> fetchAds() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('ads').orderBy('time', descending: true).get();
    return snapshot.docs.map((doc) => AdModel.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
  }
}
