import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIO extends GetxController {
  late IO.Socket socket;

  SocketIO() {
    socket = IO.io("http://100.101.167.63:3000/", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": true,
    });

    socket.on('connect', (data) {
      print("SOCKET_IO_CONNECTED: " + socket.connected.toString());
    });
  }
}
