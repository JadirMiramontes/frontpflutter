import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front/models/user_model.dart'; // Importa el modelo de usuario

class AuthServices extends ChangeNotifier {
  final String _baseUrl = 'login2024jadirm.somee.com';
  final storage = FlutterSecureStorage();

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'Email': email,
      'Password': password
    };

    final url = Uri.http(_baseUrl, '/api/Cuentas/Registrar');

    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(authData),
    );

    Map<dynamic, dynamic> decodeResp;
    if (resp.body.contains('code')) {
      List<dynamic> decodeResp2 = json.decode(resp.body);
      if (decodeResp2[0].containsKey('description')) {
        print('Error en Password: ${decodeResp2[0]['description']}');
        return decodeResp2[0]['description'];
      }
    }
    decodeResp = json.decode(resp.body);

    if (decodeResp.containsKey('token')) {
      await storage.write(key: 'token', value: decodeResp['token']);
      return null;
    } else if (decodeResp.containsKey('errors')) {
      final errors = decodeResp['errors'];
      if (errors.containsKey('Email')) {
        print('Error en Email: ${errors['Email'][0]}');
        return errors['Email'][0];
      }
      if (errors.containsKey('Password')) {
        print('Error en Password: ${errors['Password'][0]}');
        return errors['Password'][0];
      }
    } else {
      return decodeResp['error'];
    }
    return null;
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'Email': email,
      'Password': password
    };

    final url = Uri.http(_baseUrl, '/api/Cuentas/Login');

    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(authData),
    );

    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    if (decodeResp.containsKey('token')) {
      await storage.write(key: 'token', value: decodeResp['token']);
      return null;
    } else if (decodeResp.containsKey('errors')) {
      final errors = decodeResp['errors'];
      if (errors.containsKey('Email')) {
        print('Error en Email: ${errors['Email'][0]}');
        return errors['Email'][0];
      }
      if (errors.containsKey('Password')) {
        print('Error en Password: ${errors['Password'][0]}');
        return errors['Password'][0];
      }
    } else {
      return decodeResp['error'];
    }
    return null;
  }

  // Método para obtener la información del usuario
  Future<UserModel?> getUserInfo() async {
    final token = await storage.read(key: 'token');
    if (token == null) return null;

    final url = Uri.http(_baseUrl, '/api/Cuentas/RenovarToken');

    final resp = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (resp.statusCode == 200) {
      final Map<String, dynamic> decodeResp = json.decode(resp.body);
      return UserModel.fromJson(decodeResp);
    } else {
      return null; // Manejar el error según sea necesario
    }
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future logout() async {
    await storage.delete(key: 'token');
  }
}
