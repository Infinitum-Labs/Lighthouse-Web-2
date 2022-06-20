library core.data_handling;

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:idb_shim/idb_browser.dart';
import 'package:idb_shim/idb_client.dart';
import 'package:lighthouse_web/core/core.dart';

import 'dart:convert';

part './storage/object_caching_system.dart';
part './storage/storage.dart';
part './transfer/http_client.dart';
