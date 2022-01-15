import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_proto_app/notifiers.dart/account_notifier.dart';
import 'package:restaurant_proto_app/notifiers.dart/basket_notifier.dart';
import 'package:restaurant_proto_app/notifiers.dart/home_notifier.dart';
import 'package:restaurant_proto_app/notifiers.dart/ordered_notifier.dart';
import 'package:restaurant_proto_app/pages/home.dart';
import 'package:restaurant_proto_app/services/main_configuration.dart';
import 'package:restaurant_proto_app/wrapper.dart';

void main() async{
  
  await MainConfiguration.configureApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AccountNotifier()),
        ChangeNotifierProvider(create: (context) => HomeNotifier()),
        ChangeNotifierProvider(create: (context) => BasketNotifier()),
        ChangeNotifierProvider(create: (context) => OrderNotifier()),
      ],
      child: const MyApp()
    ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
    );
  }
}