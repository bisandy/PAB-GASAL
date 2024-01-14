import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../navbar/drawer.dart';
import '../auth/bottomnavbar.dart';
import 'editDosen.dart';

class Dosen {
  final String id;
  final String nama;
  final String npm;
  final String? noTelp;

  Dosen({
    required this.id,
    required this.nama,
    required this.npm,
    required this.noTelp,
  });

  factory Dosen.fromJson(Map<String, dynamic> json) {
    return Dosen(
      id: json['id'],
      nama: json['nama'],
      npm: json['npm'],
      noTelp: json['no_telpon'],
    );
  }
}

void main() {
  runApp(DisplayDosen());
}

class DisplayDosen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SingleChildScrollView(
        child: DisplayDosenPage(),
      ),
    );
  }
}

class DisplayDosenPage extends StatefulWidget {
  @override
  _DisplayDosenPageState createState() => _DisplayDosenPageState();
}

int _currentIndex = 0;

class _DisplayDosenPageState extends State<DisplayDosenPage> {
  late Future<List<Dosen>> _dosens;
  TextEditingController _searchController = TextEditingController();

  Future<List<Dosen>> fetchDosens() async {
    final response =
        await http.get(Uri.parse('http://localhost/pabwan/dosen/dosenapi.php'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Dosen.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load dosens');
    }
  }

  Future<void> _deleteDosen(String id) async {
    try {
      var url = Uri.parse('http://localhost/pabwan/dosen/dosendelete.php');
      var response = await http.post(
        url,
        body: {'id': id},
      );

      if (response.statusCode == 200) {
        print('Dosen deleted successfully');
        setState(() {
          _dosens = fetchDosens();
        });
      } else {
        print('Failed to delete dosen. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _dosens = fetchDosens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List Dosen',
           style: TextStyle(fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/tambahdosen');
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _dosens = fetchDosens();
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search Nama Dosen...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Dosen>>(
              future: _dosens,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Dosen> filteredDosens = snapshot.data!
                      .where((dosen) =>
                          dosen.nama
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()) ||
                          dosen.npm
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()))
                      .toList();

                  return ListView.builder(
                    itemCount: filteredDosens.length,
                    itemBuilder: (context, index) {
                      var dosen = filteredDosens[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(dosen.nama),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('npm: ${dosen.npm}'),
                              Text(
                                  'No. Telepon: ${dosen.noTelp ?? 'Not Available'}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditDosen(dosen),
                                    ),
                                  );
                                  setState(() {
                                    _dosens = fetchDosens();
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deleteDosen(dosen.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/dosen');
              break;
            case 1:
              Navigator.pushNamed(context, '/penguna');
              break;
          }
        },
      ),
    );
  }
}