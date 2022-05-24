class MajstorModel {
  String UID;
  String? city;
  String fullName;
  String? streetAddress;
  String? phoneNumber;
  List<String>? occupation;
  String? description;
  double? rate;
  int? reviewsNumber;
  int? recommendationNumber;
  String? profilePicture;
  String? primaryOccupation;

  MajstorModel(
      {required this.UID,
      this.city,
      required this.fullName,
      this.streetAddress,
      this.phoneNumber,
      this.occupation,
      this.description,
      this.rate = 0,
      this.reviewsNumber,
      this.recommendationNumber,
      this.profilePicture,
      this.primaryOccupation});
  Map<String, dynamic> toMap() {
    return {
      'UID': UID,
      'fullName': fullName,
      'city': city,
      'streetAddress': streetAddress,
      'phoneNumber': phoneNumber,
      'occupation': occupation,
      'rate': rate,
      'reviewsNumber': reviewsNumber,
      'recommendationNumber': recommendationNumber,
      'profilePicture': profilePicture,
      'primaryOccupation': primaryOccupation
    };
  }

  MajstorModel.fromMap(Map<String, dynamic> map)
      : UID = map["UID"],
        city = map["city"],
        fullName = map["fullName"],
        streetAddress = map["streetAddress"],
        phoneNumber = map["phoneNumber"],
        occupation = (((map["occupation"] ?? []) as List<dynamic>)
            .map((e) => e.toString())
            .toList()),
        description = map["description"],
        rate = ((map["rate"]) ?? 0).toDouble(),
        reviewsNumber = map["reviewsNumber"],
        recommendationNumber = map["recommendationNumber"],
        profilePicture = map["profilePicture"],
        primaryOccupation = map["primaryOccupation"];
}
