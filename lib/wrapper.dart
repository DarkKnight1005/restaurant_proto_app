import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_proto_app/notifiers.dart/account_notifier.dart';
import 'package:restaurant_proto_app/notifiers.dart/basket_notifier.dart';
import 'package:restaurant_proto_app/notifiers.dart/home_notifier.dart';
import 'package:restaurant_proto_app/notifiers.dart/ordered_notifier.dart';
import 'package:restaurant_proto_app/pages/home.dart';
import 'package:restaurant_proto_app/pages/intro.dart';
import 'package:restaurant_proto_app/widgets/Loading.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);

    return FutureBuilder(
      future: accountNotifier.isLogedIn,
      // initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.data!){
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => HomeNotifier()),
                ChangeNotifierProvider(create: (context) => BasketNotifier()),
                ChangeNotifierProvider(create: (context) => OrderNotifier()),
              ],
              child: Home()
            );
          }else{
            return IntroScreen();
          }
        }else{
          return Loading();
        }
        
      },
    );
  }
}