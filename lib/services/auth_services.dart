import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthServices extends ChangeNotifier {
  //aqui va la url de somee
  final String _baseUrl = 'login2024jadirm.somee.com';
  final storage = new FlutterSecureStorage();

  //Este metodo puede regresar un string vacio, asincrono porque iremos a la bd a leer la info para crear al usuario
  Future<String?> createUser(String email, String password)
  async{
    final Map<String,dynamic> authData = {
      'Email': email,
      'Password': password
    };

    //Se crea la URL para la API REGISTRAR
    final url = Uri.http(_baseUrl, '/api/Cuentas/Registrar');

    /*Conectamos, lo que regrese el back lo almacena esta variable. Consume el servicio y codifica a json.*/
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(authData),
      );

      //Decodificar la respuesta
      Map<dynamic,dynamic> decodeResp;
      if(resp.body.contains('code')){
        List<dynamic> decodeResp2 = json.decode(resp.body);
        if(decodeResp2[0].containsKey('description')){
          print('Error en Password: ${decodeResp2[0]['description']}');
          return decodeResp2[0]['description'];
        }
      }
      decodeResp = json.decode(resp.body);

      //Si en decoderesp hay tokens, se regresan y se escriben en el dispositivo movil
      if(decodeResp.containsKey('token')){
        await storage.write(key: 'token', value: decodeResp['token']);
        return null;
      }
      else if(decodeResp.containsKey('errors')){
        final errors = decodeResp['errors'];
        if(errors.containsKey('Email')){
          print('Error en Email: ${errors['Email'][0]}');
          return errors['Email'][0];
        }
        if(errors.containsKey('Password')){
          print('Error en Password: ${errors['Password'][0]}');
          return errors['Password'][0];
        }
      } else {
        return decodeResp['error'];
      } return null;
  }

  Future<String?> login(String email, String password) async{
    final Map<String,dynamic> authData = {
      'Email': email,
      'Password': password
    };
    
    //API PARA LOGIN
    final url = Uri.http(_baseUrl, '/api/Cuentas/Login');

    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(authData),
    );

    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    if(decodeResp.containsKey('token')){
      await storage.write(key: 'token', value: decodeResp['token']);
      return null;
    }
    else if (decodeResp.containsKey('errors')){
      final errors = decodeResp['errors'];
      if (errors.containsKey('Email')) {
        print('Error en Email: ${errors['Email'][0]}');
        return errors['Email'][0];
      }
      if (errors.containsKey('Password')) {
        print('Error en Password: ${errors['Password'][0]}');
        return errors['Password'][0];
      }
    }
    else {
      return decodeResp['error'];
    }
    return null; 
  } 

  //Para verificar si la cuenta aun esta activa, si no existe nada regresa vacio, lo cual significa que no esta autenticado
  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  //logout
  Future logout() async {
    //await storage.deleteAll();
    await storage.delete(key: 'token');
  }
}