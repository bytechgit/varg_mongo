class InboxModel {
  late String profilePhoto;
  late String name;
  late String time;
  late String lastMessage;

  InboxModel({
    required String profilePhoto,
    required String name,
    required String time,
    required String lastMessage,
  }) {
    this.profilePhoto = profilePhoto;
    this.name = name;
    this.time = time;
    this.lastMessage = lastMessage;
  }
}
