import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../navbar/drawer.dart';
import '../auth/bottomnavbar.dart';
import 'editUser.dart';

class User {
  final String id;
  final String nama;
  final String alamat;
  final String? tglDaftar;
  final String? noTelp;
  final String? foto;

  User({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.tglDaftar,
    required this.noTelp,
    required this.foto,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        nama: json['nama'],
        alamat: json['alamat'],
        tglDaftar: json['tgl_daftar'],
        noTelp: json['no_telpon'],
        foto: json['foto']);
  }
}

void main() {
  runApp(DisplayUser());
}

class DisplayUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SingleChildScrollView(
        child: DisplayUserPage(),
      ),
    );
  }
}

class DisplayUserPage extends StatefulWidget {
  @override
  _DisplayUserPageState createState() => _DisplayUserPageState();
}

int _currentIndex = 1;

class _DisplayUserPageState extends State<DisplayUserPage> {
  late Future<List<User>> _users;
  TextEditingController _searchController = TextEditingController();

  Future<List<User>> fetchUsers() async {
    final response =
        await http.get(Uri.parse('http://localhost/pabwan/user/userapi.php'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => User.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  List<User> _searchUsers(List<User> users, String query) {
    return users
        .where((user) =>
            user.nama.toLowerCase().contains(query.toLowerCase()) ||
            user.alamat.toLowerCase().contains(query.toLowerCase()) ||
            (user.noTelp != null &&
                user.noTelp!.toLowerCase().contains(query.toLowerCase())))
        .toList();
  }

  Future<void> _deleteUser(String id) async {
    try {
      var url = Uri.parse('http://localhost/pabwan/user/userdelete.php');
      var response = await http.post(
        url,
        body: {'id': id},
      );

      if (response.statusCode == 200) {
        print('User deleted successfully');
        setState(() {
          _users = fetchUsers();
        });

      } else {
        print('Failed to delete user. Status code: ${response.statusCode}');

      }
    } catch (error) {
      print('Error: $error');

    }
  }

  @override
  void initState() {
    super.initState();
    _users = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Laporan Pengguna',
           style: TextStyle(fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/tambahpenguna');
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
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search Nama Mahasiswa...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _users = fetchUsers().then((users) => _searchUsers(users, _searchController.text));
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: _users,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var user = snapshot.data![index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: user.foto != null &&
                                  Uri.parse(
                                          'http://localhost/pabwan/user/${user.foto!}')
                                      .isAbsolute
                              ? Image.network(
                                  'http://localhost/pabwan/user/${user.foto!}',
                                  width: 50, 
                                  height: 50, 
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons
                                  .image),
                          title: Text(user.nama),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Alamat: ${user.alamat}'),
                              Text(
                                  'No. Telepon: ${user.noTelp ?? 'Not Available'}'),
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
                                      builder: (context) => EditUser(user),
                                    ),
                                  );

                                  setState(() {
                                    _users = fetchUsers();
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deleteUser(user.id);
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