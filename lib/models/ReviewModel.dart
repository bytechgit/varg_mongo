class ReviewModel {
  late String profileImage;
  late String fullName;
  late double rate;
  String? commentText;

  ReviewModel({
    required this.profileImage,
    required this.fullName,
    required this.rate,
    this.commentText,
  });
}
