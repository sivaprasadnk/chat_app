// import 'package:chatapp/presentation/message_provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class SocketService {
//   static IO.Socket? socket;
//   static connect(String userId, Ref) {
//     var uri = 'https://chatappbackend-production-54a7.up.railway.app/';

//     socket = IO.io(
//       uri,
//       IO.OptionBuilder().setTransports(["websocket"]).build(),
//     );
//     socket!.connect();
//     socket!.emit('signin', userId);
//     socket!.onConnect((data) {
//       socket!.on("message", (msg) {

//       });
//     });
//     //   socket!.on("message", (msg) {
//     //     ref.read(messageProvider.notifier).addMessage(newMessage);
//     //     setMessage('destination', msg['message']);
//     //   });
//     // });
//     // socket!.onConnect((data) {
//     //   debugPrint("connected");
//     //   socket.on("message", (msg) {
//     //     // setMessage('destination', msg['message']);
//     //     var hr = DateTime.now().hour.toString();
//     //     var min = DateTime.now().minute.toString();
//     //     setMessage('destination', msg['message'], hr, min);
//     //   });
//     // });
//   }
// }
