import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_proto_app/models/auth_dto.dart';
import 'package:restaurant_proto_app/notifiers.dart/account_notifier.dart';
import 'package:restaurant_proto_app/services/API/account_service.dart';
import 'package:restaurant_proto_app/widgets/home/floating_button.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen({Key? key}) : super(key: key);
  
  AccountNotifier? accountNotifier;

  @override
  Widget build(BuildContext context) {

    accountNotifier = Provider.of<AccountNotifier>(context);

    return Scaffold(
      body: Center(
        child: Container(
          // height: 100,
          width: MediaQuery.of(context).size.width * 0.35,
          child: FloatingButton(
            onPressed: () async{
              await AccountService().auth(accountNotifier!);
            },
            title: "Menu"
          ),
        ),
      ),
    );
  }
}