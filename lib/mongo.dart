import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';

late Db mongoClient;

class mongo {
  Future<void> pom() async {
    mongoClient = await Db.create(
        "mongodb+srv://ByTech:ByTech123!@cluster0.dc7pw.mongodb.net:27018/varg");
    await mongoClient.open();
    listen();
  }

  void listen() {
    var stream = mongoClient.collection('Chat').watch(<Map<String, Object>>[
      {
        r'$match': {'operationType': 'update'}
      }
    ]);

    var controller = stream.listen((changeEvent) {
      inspect(changeEvent);
    });
  }
}
