class RoomsModel {
  final String imageUrl;
  final String title;
  final String subtitle;

   RoomsModel({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

static List<RoomsModel> roomsList = [
  RoomsModel(
    imageUrl:
        'https://i.pinimg.com/564x/5f/6b/50/5f6b50ae839f59f5f002d25eb0e42a44.jpg',
    title: 'نقاش حول البرمجة',
    subtitle: 'يتابعون فيديو',
  ),
  RoomsModel(
    imageUrl:
        'https://i.pinimg.com/474x/d4/30/1f/d4301f1c66da24156712b78ecd64507f.jpg',
    title: 'نجرب اللعبة ذي',
    subtitle: 'يتابعون فيديو',
  ),
  RoomsModel(
    imageUrl:
        'https://i.pinimg.com/474x/95/46/96/954696ddda353c1884f259b4576c1e07.jpg',
    title: 'نقاش حول الذكاء الاصطناعي',
    subtitle: 'يستمعون',
  ),
  RoomsModel(
    imageUrl:
        'https://i.pinimg.com/474x/f3/3a/3d/f33a3d54caf67aaed7b95678ec58e51b.jpg',
    title: 'ويش يعني json ؟',
    subtitle: 'يتابعون فيديو',
  ),
  RoomsModel(
    imageUrl:
        'https://i.pinimg.com/474x/f0/82/2e/f0822eea56a4765019741ba64f704846.jpg',
    title: 'تعالوا نطبخ',
    subtitle: 'يستمعون',
  ),
];
}
