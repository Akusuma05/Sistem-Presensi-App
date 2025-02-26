import 'package:intl/intl.dart';
import 'package:sistem_presensi_app/model/Absensi.dart';
import 'package:sistem_presensi_app/model/Kelas.dart';
import 'package:sistem_presensi_app/model/KelasMahasiswa.dart';
import 'package:sistem_presensi_app/model/Mahasiswa.dart';
import 'package:sistem_presensi_app/model/MahasiswaSudahAbsen.dart';
import 'package:sistem_presensi_app/shared/Shared.dart';
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
  static Future<List<Kelas>> setKelas(String Kelas_Nama, String Kelas_Lokasi,
      String Kelas_Id_varchar, DateTime Jam_Mulai, DateTime Jam_Selesai) async {
    var url = Uri.http(Const.baseUrl, "/api/Kelas");
    var request = MultipartRequest('POST', url);

    var Jam_Mulai_Tanpa_Tanggal = DateFormat.Hms().format(Jam_Mulai);
    var Jam_Selesai_Tanpa_Tanggal = DateFormat.Hms().format(Jam_Selesai);
    print(
        'DEBUG APIService setKelas: "Jam_Mulai_Tanpa_Tanggal is $Jam_Mulai_Tanpa_Tanggal"');
    print(
        'DEBUG APIService setKelas: "Jam_Selesai_Tanpa_Tanggal is $Jam_Selesai_Tanpa_Tanggal"');

    request.fields['Kelas_Nama'] = Kelas_Nama.toString();
    request.fields['Kelas_Lokasi'] = Kelas_Lokasi.toString();
    request.fields['Kelas_Id_varchar'] = Kelas_Id_varchar.toString();
    request.fields['Jam_Mulai'] = Jam_Mulai_Tanpa_Tanggal.toString();
    request.fields['Jam_Selesai'] = Jam_Selesai_Tanpa_Tanggal.toString();

    // Send the request and decode response
    var response = await request.send();
    if (response.statusCode == 201) {
      var responseBody = await response.stream.bytesToString();
      final decodedData = jsonDecode(responseBody) as List;
      final kelasList = decodedData.map((data) {
        return Kelas.fromJson(data as Map<String, dynamic>);
      }).toList();

      print('DEBUG APIService setKelas: "Kelas added successfully."');
      return kelasList;
    } else {
      // Handle error based on status code
      print('DEBUG APIService deleteKelas: Failed to Add Kelas response Code:' +
          response.statusCode.toString());
      return [];
    }
  }

  static Future<dynamic> updateKelas(
      int Kelas_Id,
      String Kelas_Nama,
      String Kelas_Lokasi,
      String Kelas_Id_varchar,
      DateTime Jam_Mulai,
      DateTime Jam_Selesai) async {
    var url =
        Uri.http(Const.baseUrl, "/api/Kelas/$Kelas_Id"); // Add ID to the URL

    var Jam_Mulai_Tanpa_Tanggal = DateFormat.Hms().format(Jam_Mulai);
    var Jam_Selesai_Tanpa_Tanggal = DateFormat.Hms().format(Jam_Selesai);
    print(
        'DEBUG APIService updateKelas: "Jam_Mulai_Tanpa_Tanggal is $Jam_Mulai_Tanpa_Tanggal"');
    print(
        'DEBUG APIService updateKelas: "Jam_Selesai_Tanpa_Tanggal is $Jam_Selesai_Tanpa_Tanggal"');
    // Prepare JSON data
    var data = json.encode({
      'Kelas_Nama': Kelas_Nama,
      'Kelas_Lokasi': Kelas_Lokasi,
      'Kelas_Id_varchar': Kelas_Id_varchar,
      'Jam_Mulai': Jam_Mulai_Tanpa_Tanggal,
      'Jam_Selesai': Jam_Selesai_Tanpa_Tanggal
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
      return response;
    } else {
      // Handle error based on status code
      throw Exception('Failed to update Kelas: ${response.statusCode}');
    }
  }

  //Delete Kelas
  static Future<dynamic> deleteKelas(int kelasId) async {
    final response = await http.delete(
      Uri.http(Const.baseUrl, "/api/Kelas/$kelasId"),
    );

    if (response.statusCode == 202) {
      print(
          'DEBUG APIService deleteKelas: "Kelas with ID $kelasId deleted successfully."');
      return response;
    } else {
      print(
          'DEBUG APIService deleteKelas: Failed to delete Kelas with ID $kelasId response Code:' +
              response.statusCode.toString() +
              '\n response body:' +
              response.body);
      return response;
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
      File mahasiswaFoto, String mahasiswaNIM, String mahasiswaNama) async {
    var url = Uri.http(Const.baseUrl, "/api/Mahasiswa");
    var request = MultipartRequest('POST', url);

    request.fields['Mahasiswa_NIM'] = mahasiswaNIM.toString();
    request.fields['Mahasiswa_Nama'] = mahasiswaNama.toString();

    // Add image as multipart file
    var multipartFile =
        await MultipartFile.fromPath('Mahasiswa_Foto', mahasiswaFoto.path);
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

  //Update Mahasiswa
  static Future<dynamic> updateMahasiswa(File? mahasiswaFoto,
      String mahasiswaNama, int mahasiswaId, int mahasiswaNIM) async {
    var url = Uri.http(Const.baseUrl, "/api/Mahasiswa/$mahasiswaId");

    var request = MultipartRequest('POST', url);

    request.headers['X-HTTP-Method-Override'] = 'PUT';

    request.fields['Mahasiswa_NIM'] = mahasiswaNIM.toString();
    request.fields['Mahasiswa_Nama'] = mahasiswaNama.toString();

    if (mahasiswaFoto != null) {
      var multipartFile =
          await MultipartFile.fromPath('Mahasiswa_Foto', mahasiswaFoto.path);
      request.files.add(multipartFile);
    }

    var response = await request.send();
    var finalResponse = await http.Response.fromStream(response);
    if (finalResponse.statusCode == 200) {
      print(
          'DEBUG APIService updateMahasiswa: "Mahasiswa with Id $mahasiswaNIM updated successfully."');
      return finalResponse;
    } else {
      print(
          'DEBUG APIService deleteMahasiswa: Failed to delete Mahasiswa with ID $mahasiswaNIM response Code:' +
              finalResponse.statusCode.toString() +
              '\n response body:' +
              finalResponse.body);
      return null;
    }
  }

  //Delete KelasaMahasiswa
  static Future<dynamic> deleteMahasiswa(int mahasiswaId) async {
    final response = await http.delete(
      Uri.http(Const.baseUrl, "/api/Mahasiswa/$mahasiswaId"),
    );

    if (response.statusCode == 202) {
      print(
          'DEBUG APIService deleteMahasiswa: "Mahasiswa with Id $mahasiswaId deleted successfully."');
      return response;
    } else {
      print(
          'DEBUG APIService deleteMahasiswa: Failed to delete Mahasiswa with ID $mahasiswaId response Code:' +
              response.statusCode.toString() +
              '\n response body:' +
              response.body);
      return response;
    }
  }

  //Deteksi Mahasiswa
  static Future<dynamic> deteksiMahasiswa(File Mahasiswa_Foto) async {
    var url = Uri.http(Const.baseUrl, "/api/Absensi/Detect");
    var request = MultipartRequest('POST', url);

    // Add image as multipart file
    var multipartFile =
        await MultipartFile.fromPath('Mahasiswa_Foto', Mahasiswa_Foto.path);
    request.files.add(multipartFile);

    // Send the request and decode response
    var response = await request.send();
    var finalResponse = await http.Response.fromStream(response);
    if (finalResponse.statusCode == 202) {
      return finalResponse;
    } else {
      // Handle error based on status code
      print('Error: ${finalResponse.statusCode}');
      print('Response body: ${finalResponse.body}');
      return finalResponse;
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
      // var responseBody = await response.stream.bytesToString();
      return response;
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

  //get Mahasiswa Yang Sudah Absen
  static Future<List<MahasiswaSudahAbsen>> getMahasiswaSudahAbsen(
      int Kelas_Id) async {
    final urlString = "api/get-Absensi-bykelas/" + Kelas_Id.toString();
    final response = await http.get(Uri.http(Const.baseUrl, urlString));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body) as List;
      final mahasiswaList = decodedData.map((data) {
        return MahasiswaSudahAbsen.fromJson(data as Map<String, dynamic>);
      }).toList();
      return mahasiswaList;
    } else {
      throw Exception('Failed to load Mahasiswa');
    }
  }

  //Delete KelasaMahasiswa
  static Future<dynamic> deleteAbsensi(int absensiId) async {
    final response = await http.delete(
      Uri.http(Const.baseUrl, "/api/Absensi/$absensiId"),
    );

    if (response.statusCode == 202) {
      print(
          'DEBUG APIService deleteAbsensi: Absensi with ID $absensiId deleted successfully.');
      return response;
    } else {
      print(
          'DEBUG APIService deleteAbsensi: Failed to delete Absensi with ID $absensiId response Code:' +
              response.statusCode.toString() +
              '\n response body:' +
              response.body);
      return response;
    }
  }
}
