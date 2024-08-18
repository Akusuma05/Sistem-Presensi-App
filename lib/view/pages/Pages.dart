import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:camera/camera.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:sistem_presensi_app/controller/Controllers.dart';
import 'package:sistem_presensi_app/main.dart';
import 'package:sistem_presensi_app/model/Absensi.dart';
import 'package:sistem_presensi_app/model/Kelas.dart';
import 'package:sistem_presensi_app/model/KelasMahasiswa.dart';
import 'package:sistem_presensi_app/model/Mahasiswa.dart';
import 'package:sistem_presensi_app/model/MahasiswaSudahAbsen.dart';
import 'package:sistem_presensi_app/shared/Shared.dart';
import 'package:sistem_presensi_app/view/widgets/Widgets.dart';
import 'package:sistem_presensi_app/service/ApiServices.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:multi_dropdown/multiselect_dropdown.dart';

part 'Absensi/AbsensiView.dart';
part 'Absensi/AddAbsensi.dart';
part 'Absensi/EditAbsensi.dart';
part 'Kelas/AddKelas.dart';
part 'Kelas/EditKelas.dart';
part 'Kelas/KelasView.dart';
part 'Home.dart';
part 'Mahasiswa/AddMahasiswaView.dart';
part 'Mahasiswa/EditMahasiswa.dart';
part 'Mahasiswa/MahasiswaDetails.dart';
part 'Mahasiswa/MahasiswaView.dart';
part 'Mahasiswa/CameraViewMahasiswa.dart';
part 'Homepage.dart';
