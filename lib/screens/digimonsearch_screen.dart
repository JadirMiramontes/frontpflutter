import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DigimonSearchScreen extends StatefulWidget {
  const DigimonSearchScreen({super.key});

  @override
  _DigimonSearchScreenState createState() => _DigimonSearchScreenState();
}

class _DigimonSearchScreenState extends State<DigimonSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String>? _digimonNames;
  List<String>? _digimonImages;
  List<String>? _digimonLevels;
  final List<String> _levels = ['Rookie', 'Champion', 'Ultimate', 'Mega'];
  String? _selectedLevel;

  Future<void> _searchDigimonByName(String name) async {
    final response =
        await http.get(Uri.parse('https://digimon-api.vercel.app/api/digimon/name/$name'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        setState(() {
          _digimonNames = [data[0]['name']];
          _digimonImages = [data[0]['img']];
          _digimonLevels = [data[0]['level']];
        });
      } else {
        _clearResults();
      }
    } else {
      throw Exception('Error al buscar el Digimon');
    }
  }

  Future<void> _searchDigimonByLevel(String level) async {
    final response =
        await http.get(Uri.parse('https://digimon-api.vercel.app/api/digimon/level/$level'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        setState(() {
          _digimonNames = data.map((d) => d['name'] as String).toList();
          _digimonImages = data.map((d) => d['img'] as String).toList();
          _digimonLevels = data.map((d) => d['level'] as String).toList();
        });
      } else {
        _clearResults();
      }
    } else {
      throw Exception('Error al buscar el Digimon');
    }
  }

  void _clearResults() {
    setState(() {
      _digimonNames = null;
      _digimonImages = null;
      _digimonLevels = null;
    });
  }

  void _clearFields() {
    _controller.clear();
    setState(() {
      _selectedLevel = null;
    });
    _clearResults();
  }

  void _search() {
    if (_controller.text.isNotEmpty) {
      _searchDigimonByName(_controller.text);
    } else if (_selectedLevel != null) {
      _searchDigimonByLevel(_selectedLevel!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Digimons'),
        backgroundColor: const Color.fromARGB(253, 252, 147, 11),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Busca tu Digimon favorito', style: TextStyle(fontSize: 24)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del Digimon',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Selecciona el nivel del Digimon:', style: TextStyle(fontSize: 20)),
              DropdownButton<String>(
                value: _selectedLevel,
                hint: const Text('Selecciona un nivel'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLevel = newValue;
                  });
                  _search();
                },
                items: _levels.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: _search,
                child: const Text('Buscar'),
              ),
              const SizedBox(height: 20),
              _digimonNames == null || _digimonNames!.isEmpty
                  ? const Text('No se encontraron Digimons')
                  : Column(
                      children: List.generate(
                        _digimonNames!.length,
                        (index) {
                          return ListTile(
                            title: Text(_digimonNames![index]),
                            subtitle: Text(_digimonLevels![index] ?? 'Nivel desconocido'),
                            leading: Image.network(_digimonImages![index] ?? ''),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
