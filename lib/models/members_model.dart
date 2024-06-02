class Member {
  final String uid;
  final bool isAdmin;

  Member({
    required this.uid,
    required this.isAdmin,
  });

  // Convert a Member object into a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'isAdmin': isAdmin,
    };
  }

  // Create a Member object from a map (e.g., Firebase snapshot)
  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      uid: map['uid'],
      isAdmin: map['isAdmin'],
    );
  }
}
