import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sistem_presensi_app/service/ApiServices.dart';
import 'package:sistem_presensi_app/view/pages/Pages.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;

part 'AbsensiController.dart';
part 'KelasController.dart';
part 'HomeController.dart';
part 'MahasiswaController.dart';
