
class NoteModel {
  final String uid, username, text, urlImage;

  NoteModel(
      {required this.uid,
      required this.username,
      required this.text,
      required this.urlImage});

  static List<NoteModel> noteData = [
    NoteModel(
        uid: '2',
        username: 'ali',
        text: 'حرر ياخي اليوم',
        urlImage: 'https://cdn-icons-png.flaticon.com/512/249/249378.png'),
    NoteModel(
        uid: '3',
        username: 'ahmed',
        text: 'هل هناك أحد يريد اللعب؟',
        urlImage: 'https://cdn-icons-png.flaticon.com/512/8490/8490264.png'),
    NoteModel(
        uid: '1',
        username: 'yasser',
        text: 'انا ياسر احب البرمجة!',
        urlImage: 'https://cdn-icons-png.flaticon.com/512/249/249413.png'),
    NoteModel(
        uid: '4',
        username: 'fatima',
        text: 'أنا مشغولة بالدراسة',
        urlImage: 'https://cdn-icons-png.flaticon.com/512/194/194936.png'),
    NoteModel(
        uid: '5',
        username: 'khaled',
        text: 'من يريد الذهاب إلى السينما الليلة؟',
        urlImage: 'https://cdn-icons-png.flaticon.com/512/236/236831.png'),
    NoteModel(
        uid: '6',
        username: 'mariam',
        text: 'أحببت الكتاب الجديد الذي قرأته',
        urlImage: 'https://cdn-icons-png.flaticon.com/512/206/206854.png'),
    NoteModel(
        uid: '7',
        username: 'sarah',
        text: 'أنا أتعلم البرمجة',
        urlImage: 'https://cdn-icons-png.flaticon.com/512/2922/2922510.png'),
    NoteModel(
        uid: '8',
        username: 'yousef',
        text: 'مباراة كرة القدم كانت رائعة!',
        urlImage: 'https://cdn-icons-png.flaticon.com/512/2922/2922529.png'),
    NoteModel(
        uid: '9',
        username: 'Layla',
        text: 'أحببت الحفلة البارحة',
        urlImage: 'https://cdn-icons-png.flaticon.com/512/2922/2922506.png'),
    NoteModel(
        uid: '10',
        username: 'Amr',
        text: 'أحتاج مساعدة في مشروع العمل',
        urlImage: 'https://cdn-icons-png.flaticon.com/512/2922/2922504.png'),
  ];
}
