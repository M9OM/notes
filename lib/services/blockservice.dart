import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/models/user_model.dart';

class BlockService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> blockUser(String currentUserId, String userIdToBlock) async {
    try {
      await _db.collection('users').doc(currentUserId).update({
        'blockedUsers': FieldValue.arrayUnion([userIdToBlock]),
      });
    } catch (e) {
      print("Error blocking user: $e");
    }
  }

  Future<void> unblockUser(String currentUserId, String userIdToUnblock) async {
    try {
      await _db.collection('users').doc(currentUserId).update({
        'blockedUsers': FieldValue.arrayRemove([userIdToUnblock]),
      });
    } catch (e) {
      print("Error unblocking user: $e");
    }
  }

  Stream<bool> isBlocked(String currentUserId, String userIdToCheck) {
    return _db.collection('users').doc(currentUserId).snapshots().map((doc) {
      List blockedUsers = doc.data()?['blockedUsers'] ?? [];
      return blockedUsers.contains(userIdToCheck);
    });
  }


    Future<List<UserModel>> getblockData(String userId) async {
    DocumentSnapshot docSnapshot =
        await _db.collection('users').doc(userId).get();
    List<String> block = List<String>.from(docSnapshot['blockedUsers'] ?? []);
    List<UserModel> blockData = [];

    for (String followerId in block) {
      DocumentSnapshot blocknapshot =
          await _db.collection('users').doc(followerId).get();
      if (blocknapshot.exists) {
        blockData.add(UserModel.fromFirestore(
            blocknapshot.data() as Map<String, dynamic>));
      }
    }

    return blockData;
  }
}
