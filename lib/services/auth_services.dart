import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthServices extends ChangeNotifier {
  final String _baseUrl = 'login2024jadirm.somee.com';
  //final String _baseUrl = 'localhost:44353';
  final storage = FlutterSecureStorage();

  String? _userName;
  String? _userId; // Agregar el UUID del usuario
  String? get userName => _userName;
  String? get userId => _userId; // Acceder al UUID del usuario

  // Crear usuario y almacenar UUID y correo
  Future<String?> createUser(String email, String password, String userName) async {
    final Map<String, dynamic> authData = {
      'Email': email,
      'Password': password,
      'NombreUsuario': userName // Aseguramos que el nombre de usuario se incluya
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
      _userId = decodeResp['userId']; // Almacenar el UUID
      await storage.write(key: 'userId', value: _userId); // Guardar UUID
      await storage.write(key: 'email', value: email); // Guardar email
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

  // Iniciar sesión y almacenar UUID y correo
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
        _userId = decodeResp['userId']; // Almacenar UUID
        await storage.write(key: 'email', value: email); // Guardar email

        // Imprimir el token en la consola
        //print('Token recibido: ${decodeResp['token']}'); // Aquí imprimimos el token

        notifyListeners();
        return null;
      }
    } else if (resp.statusCode == 400) {
      final errorResponse = json.decode(resp.body);
      return errorResponse['Error'] ?? "Credenciales incorrectas.";
    }

    return "Ocurrió un error inesperado. Intenta de nuevo.";
  }

  // Leer el token de almacenamiento
  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  // Leer el correo del usuario
  Future<String> readEmail() async {
    return await storage.read(key: 'email') ?? '';
  }

  // Cerrar sesión
  Future logout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'userId'); // Eliminar UUID
    await storage.delete(key: 'email'); // Eliminar email
    _userName = null;
    _userId = null; // Limpiar el UUID en memoria
    notifyListeners();
  }
}
