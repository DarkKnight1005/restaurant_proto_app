import 'package:get_storage/get_storage.dart';
import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart'; 

class DbService {
  final box = GetStorage();

  String? getAuthToken(){
    return box.read("auth_token");
  }

  Future<void> setAuthToken(String? auth_token) async{
    await box.write("auth_token", auth_token);
  }

  Future<void> setTableNum(int table_num) async{
    await box.write("table_num", table_num);
  }

  int getTableNum(){
    return box.read("table_num") ?? 1;
  }

}
