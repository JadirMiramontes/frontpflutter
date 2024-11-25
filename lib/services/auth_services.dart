import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthServices extends ChangeNotifier {
  final String _baseUrl = 'login2024jadirm.somee.com';
  final storage = FlutterSecureStorage();

  String? _userName;
  String? get userName => _userName;

  Future<String?> createUser(String email, String password, String userName) async {
  final Map<String, dynamic> authData = {
    'Email': email,
    'Password': password,
    'UserName': userName // Aseguramos que el nombre de usuario se incluya
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
    _userName = decodeResp['userName'] ?? userName;
    notifyListeners();
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
    'Password': password,
  };

  final url = Uri.http(_baseUrl, '/api/Cuentas/Login');

  final resp = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(authData),
  );

  if (resp.statusCode == 200) {
    final decodeResp = json.decode(resp.body);
    if (decodeResp.containsKey('token')) {
      await storage.write(key: 'token', value: decodeResp['token']);
      _userName = decodeResp['userName'] ?? 'Usuario'; // Por si en algún momento se añade.
      notifyListeners();
      return null;
    }
  } else if (resp.statusCode == 400) {
    final errorResponse = json.decode(resp.body);
    return errorResponse['Error'] ?? "Credenciales incorrectas.";
  }

  return "Ocurrió un error inesperado. Intenta de nuevo.";
}



  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future logout() async {
    await storage.delete(key: 'token');
    _userName = null;
    notifyListeners();
  }
}