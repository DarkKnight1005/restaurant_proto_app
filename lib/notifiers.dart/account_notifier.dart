import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:restaurant_proto_app/models/auth_dto.dart';
import 'package:restaurant_proto_app/services/API/account_service.dart';
import 'package:restaurant_proto_app/services/db_service.dart';

class AccountNotifier extends ChangeNotifier {

  AuthDTO _authDTO = new AuthDTO(tableNum: 1);
  DbService dbService = DbService();

  Future<bool> get isLogedIn async{

    bool _isLogedIn = false;

    _checkLocalStorage();

    if(this._authDTO.authToken != null && !JwtDecoder.isExpired(this._authDTO.authToken!)){
      _isLogedIn = true;
      _isLogedIn = await AccountService().getAuthUser();
    }else{
      updateAuthToken(null, needNotify: false);
    }

    return _isLogedIn;
  }

  void doNotify(){
    notifyListeners();
  }

  void _checkLocalStorage(){
    this._authDTO.authToken = dbService.getAuthToken();
  }

  void updateAuthToken(String? newToken, {bool needNotify = true}){
    dbService.setAuthToken(newToken);
    this._authDTO = AuthDTO(tableNum: 1);
    if (needNotify) notifyListeners();
  }

  void logOut(){
    this.updateAuthToken(null);
  }

  AuthDTO get authDTO => _authDTO;
}
