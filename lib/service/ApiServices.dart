// part of 'Services.dart';
import 'package:sistem_presensi_app/model/Absensi.dart';
import 'package:sistem_presensi_app/model/Kelas.dart';
import 'package:sistem_presensi_app/model/KelasMahasiswa.dart';
import 'package:sistem_presensi_app/model/Mahasiswa.dart';
import 'package:sistem_presensi_app/shared/Shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:io';

class ApiServices {
  //get Absensi
  static Future<List<Absensi>> getAbsensi() async {
    final response = await http.get(Uri.http(Const.baseUrl, "/api/Absensi"));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body) as List;
      final absensiList = decodedData.map((data) {
        return Absensi.fromJson(data as Map<String, dynamic>);
      }).toList();

      return absensiList;
    } else {
      throw Exception('Failed to load Absensi');
    }
  }

  //Create Absensi
  static Future<dynamic> postAbsensi(File Mahasiswa_Foto, int Kelas_Id) async {
    var url = Uri.http(Const.baseUrl, "/api/Absensi");
    var request = MultipartRequest('POST', url);

    request.fields['Kelas_Id'] = Kelas_Id.toString();

    // Add image as multipart file
    var multipartFile =
        await MultipartFile.fromPath('Mahasiswa_Foto', Mahasiswa_Foto.path);
    request.files.add(multipartFile);

    // Send the request and decode response
    var response = await request.send();
    var finalResponse = await http.Response.fromStream(response);
    if (finalResponse.statusCode == 201) {
      return finalResponse;
    } else {
      // Handle error based on status code
      return finalResponse;
    }
  }

  //get Kelas
  static Future<List<Kelas>> getKelas() async {
    final response = await http.get(Uri.http(Const.baseUrl, "/api/Kelas"));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body) as List;
      final kelasList = decodedData.map((data) {
        return Kelas.fromJson(data as Map<String, dynamic>);
      }).toList();

      return kelasList;
    } else {
      throw Exception('Failed to load Kelas');
    }
  }

  //Create Kelas
  static Future<List<Kelas>> setKelas(
      String Kelas_Nama, String Kelas_Lokasi) async {
    var url = Uri.http(Const.baseUrl, "/api/Kelas");
    var request = MultipartRequest('POST', url);

    request.fields['Kelas_Nama'] = Kelas_Nama.toString();
    request.fields['Kelas_Lokasi'] = Kelas_Lokasi.toString();

    // Send the request and decode response
    var response = await request.send();
    if (response.statusCode == 201) {
      var responseBody = await response.stream.bytesToString();
      final decodedData = jsonDecode(responseBody) as List;
      final kelasList = decodedData.map((data) {
        return Kelas.fromJson(data as Map<String, dynamic>);
      }).toList();
      return kelasList;
    } else {
      // Handle error based on status code
      throw Exception('Failed to create Kelas: ${response.statusCode}');
    }
  }

  static Future<dynamic> updateKelas(
      int Kelas_Id, String Kelas_Nama, String Kelas_Lokasi) async {
    var url =
        Uri.http(Const.baseUrl, "/api/Kelas/$Kelas_Id"); // Add ID to the URL

    // Prepare JSON data
    var data = json.encode({
      'Kelas_Nama': Kelas_Nama,
      'Kelas_Lokasi': Kelas_Lokasi,
    });

    // Create a PUT request with raw body
    var request = Request('PUT', url);
    request.headers['Content-Type'] =
        'application/json'; // Specify JSON content type

    // Set the raw body of the request
    request.body = data;

    // Send the request and decode response
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      return json.decode(responseBody);
    } else {
      // Handle error based on status code
      throw Exception('Failed to update Kelas: ${response.statusCode}');
    }
  }

  //Delete Kelas
  static Future<void> deleteKelas(int kelasId) async {
    final response = await http.delete(
      Uri.http(Const.baseUrl, "/api/Kelas/$kelasId"),
    );

    if (response.statusCode == 202) {
      print('Kelas with ID $kelasId deleted successfully.');
    } else {
      throw Exception('Failed to delete Kelas with ID $kelasId');
    }
  }

  //get Mahasiswa
  static Future<List<Mahasiswa>> getMahasiswa() async {
    final response = await http.get(Uri.http(Const.baseUrl, "/api/Mahasiswa"));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body) as List;
      final MahasiswaList = decodedData.map((data) {
        return Mahasiswa.fromJson(data as Map<String, dynamic>);
      }).toList();

      return MahasiswaList;
    } else {
      throw Exception('Failed to load Kelas');
    }
  }

  //get Mahasiswa By KelasID
  static Future<List<Mahasiswa>> getMahasiswaByKelasId(int Kelas_Id) async {
    final urlString =
        "/api/kelas-mahasiswa/" + Kelas_Id.toString() + "/mahasiswa";
    final response = await http.get(Uri.http(Const.baseUrl, urlString));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body) as List;
      final mahasiswaList = decodedData.map((data) {
        return Mahasiswa.fromJson(data as Map<String, dynamic>);
      }).toList();

      return mahasiswaList;
    } else {
      throw Exception('Failed to load Mahasiswa');
    }
  }

  //Create Absensi
  static Future<dynamic> postMahasiswa(
      File Mahasiswa_Foto, String Mahasiswa_Nama) async {
    var url = Uri.http(Const.baseUrl, "/api/Mahasiswa");
    var request = MultipartRequest('POST', url);

    request.fields['Mahasiswa_Nama'] = Mahasiswa_Nama.toString();

    // Add image as multipart file
    var multipartFile =
        await MultipartFile.fromPath('Mahasiswa_Foto', Mahasiswa_Foto.path);
    request.files.add(multipartFile);

    // Send the request and decode response
    var response = await request.send();
    var finalResponse = await http.Response.fromStream(response);
    if (finalResponse.statusCode == 201) {
      return finalResponse;
    } else {
      // Handle error based on status code
      return finalResponse;
    }
  }

  //Delete KelasaMahasiswa
  static Future<void> deleteMahasiswa(int Mahasiswa_Id) async {
    final response = await http.delete(
      Uri.http(Const.baseUrl, "/api/Mahasiswa/$Mahasiswa_Id"),
    );

    if (response.statusCode == 202) {
      print('Kelas Mahasiswa with ID $Mahasiswa_Id deleted successfully.');
    } else {
      throw Exception('Failed to delete Kelas Mahasiswa with ID $Mahasiswa_Id');
    }
  }

  //get KelasMahasiswa
  static Future<List<KelasMahasiswa>> getKelasMahasiswa() async {
    final response =
        await http.get(Uri.http(Const.baseUrl, "/api/KelasMahasiswa"));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body) as List;
      final kelasMahasiswaList = decodedData.map((data) {
        return KelasMahasiswa.fromJson(data as Map<String, dynamic>);
      }).toList();

      return kelasMahasiswaList;
    } else {
      throw Exception('Failed to load Mahasiswa');
    }
  }

  //get KelasMahasiswaByKelasId
  static Future<List<KelasMahasiswa>> getKelasMahasiswabyId(
      int Kelas_Id) async {
    final response = await http
        .get(Uri.http(Const.baseUrl, "/api/kelas-mahasiswa/$Kelas_Id"));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body) as List;
      final kelasMahasiswaList = decodedData.map((data) {
        return KelasMahasiswa.fromJson(data as Map<String, dynamic>);
      }).toList();

      return kelasMahasiswaList;
    } else {
      throw Exception('Failed to load KelasMahasiswaByKelasId');
    }
  }

  //Create KelasMahasiswa
  static Future<dynamic> setKelasMahasiswa(
      int Kelas_Id, int Mahasiswa_Id) async {
    print("setKelasMahasiswa Kelas ID:" + Kelas_Id.toString());
    print("setKelasMahasiswa Mahasiswa ID:" + Mahasiswa_Id.toString());
    var url = Uri.http(Const.baseUrl, "/api/KelasMahasiswa");
    var request = MultipartRequest('POST', url);

    request.fields['Kelas_Id'] = Kelas_Id.toString();
    request.fields['Mahasiswa_Id'] = Mahasiswa_Id.toString();

    // Send the request and decode response
    var response = await request.send();
    if (response.statusCode == 201) {
      var responseBody = await response.stream.bytesToString();
      return json.decode(responseBody);
    } else {
      // Handle error based on status code
      throw Exception(
          'Failed to create Kelas Mahasiswa: ${response.statusCode}');
    }
  }

  //Update KelasMahasiswa
  static Future<dynamic> updateKelasMahasiswa(
      int KelasMahasiswa_Id, int Kelas_id, int Mahasiswa_Id) async {
    var url = Uri.http(Const.baseUrl,
        "/api/KelasMahasiswa/$KelasMahasiswa_Id"); // Add ID to the URL

    // Prepare JSON data
    var data = json.encode({
      'Kelas_Id': Kelas_id,
      'Mahasiswa_Id': Mahasiswa_Id,
    });

    // Create a PUT request with raw body
    var request = Request('PUT', url);
    request.headers['Content-Type'] =
        'application/json'; // Specify JSON content type

    // Set the raw body of the request
    request.body = data;

    // Send the request and decode response
    var response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 409) {
      var responseBody = await response.stream.bytesToString();
      return json.decode(responseBody);
    } else {
      // Handle error based on status code
      throw Exception(
          'Failed to update Kelas Mahasiswa: ${response.statusCode}');
    }
  }

  //Delete KelasaMahasiswa
  static Future<void> deleteKelasMahasiswa(int KelasMahasiswa_Id) async {
    final response = await http.delete(
      Uri.http(Const.baseUrl, "/api/KelasMahasiswa/$KelasMahasiswa_Id"),
    );

    if (response.statusCode == 202) {
      print('Kelas Mahasiswa with ID $KelasMahasiswa_Id deleted successfully.');
    } else {
      throw Exception(
          'Failed to delete Kelas Mahasiswa with ID $KelasMahasiswa_Id');
    }
  }

  //get Absensi
  static Future<List<Absensi>> getAbsensibyId(
      int Kelas_Id, int Mahasiswa_Id) async {
    final urlString =
        "/api/Absensi/" + Kelas_Id.toString() + "/" + Mahasiswa_Id.toString();
    final response = await http.get(Uri.http(Const.baseUrl, urlString));

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final decodedData = jsonDecode(response.body) as List;
        final absensiList = decodedData.map((data) {
          return Absensi.fromJson(data as Map<String, dynamic>);
        }).toList();
        return absensiList;
      } else {
        // No data found, return empty AbsensiList
        return []; // Return empty list
      }
    } else {
      if (response.statusCode == 404) {
        // Handle specific error (Kelas Mahasiswa record not found)
        print("Debug: getAbsensibyID" +
            Kelas_Id.toString() +
            "," +
            Mahasiswa_Id.toString());
        throw Exception('Kelas Mahasiswa record not found.');
      } else {
        // Handle other errors
        throw Exception('Failed to load Absensi data.');
      }
    }
  }
}
