import 'package:flutter/material.dart';
import 'package:restaurant_proto_app/notifiers.dart/account_notifier.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketController {

  IO.Socket? socket;
  AccountNotifier accountNotifier;

  SocketController({required this.accountNotifier}){
    socket = IO.io('http://207.154.247.34:7388', IO.OptionBuilder()
      .setTransports(['websocket'])
      .setQuery({'tableNum': accountNotifier.authDTO.tableNum})
      .build());
    socket!.onConnect((_) {
      debugPrint('Connected to Socket');
    });
   socket!.on('closeSession', (data) {
      debugPrint("closeSession");
      accountNotifier.logOut();
    });
    socket!.onDisconnect((_) => print('disconnect'));
  }
}