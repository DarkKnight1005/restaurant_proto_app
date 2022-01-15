import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_proto_app/models/auth_dto.dart';
import 'package:restaurant_proto_app/notifiers.dart/account_notifier.dart';
import 'package:restaurant_proto_app/services/API/base_service.dart';
import 'package:restaurant_proto_app/services/db_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class AccountService extends BaseService {
  AccountService() : super('auth');

  Future<AuthDTO?> auth(AccountNotifier accountNotifier) async {
    AuthDTO? _response;
    try {
      
      var _options = new Options(contentType: 'application/json');

      int tableNum = dbService.getTableNum();

      tz.initializeTimeZones();
      var frankfurt = tz.getLocation('Europe/London');
      DateTime date = tz.TZDateTime.now(frankfurt);
      int minutes = date.minute;
      int days = date.day;
      int hours = date.hour;
      minutes += ((days ~/ 2) + hours + 41 + tableNum);
      var _pass1 = String.fromCharCode(minutes);
      var _pass2 = String.fromCharCode(minutes + 1);

      var _dioResponse = await dio.post(
        serviceUrl,
        options: _options,
        data: {
          "tableNum": tableNum,
          "password": _pass1 + _pass2,
        }
      );
      _response = AuthDTO.fromMap(_dioResponse.data);
      accountNotifier.updateAuthToken(_response.authToken);
    } catch (e) {
      debugPrint(e.toString());
      return _response;
    }
  }
}