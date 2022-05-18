import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:restaurant_proto_app/Globals/core_urls.dart';
import 'package:restaurant_proto_app/services/db_service.dart';
import 'package:flutter/foundation.dart';

abstract class BaseService {
  final Dio dio = new Dio();
  late String serviceUrl;

  DbService dbService = DbService();

  BaseService(String path) {
    serviceUrl = CoreUrls.mainApiUrl + '/restaurant_proto_api/$path/';

    if(!kIsWeb){
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
  }
}
