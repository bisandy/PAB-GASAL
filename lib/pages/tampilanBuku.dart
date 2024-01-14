import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../navbar/drawer.dart';
import 'editBuku.dart';

class Buku {
  final String id;
  final String noIsbn;
  final String nama;
  final String harga;
  final String hargaProduksi;
  final String? tglCetak;
  final String? jenis;
  final String? kondisi;

  Buku({
    required this.id,
    required this.noIsbn,
    required this.nama,
    required this.tglCetak,
    required this.jenis,
    required this.harga,
    required this.kondisi,
    required this.hargaProduksi,
  });

  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      id: json['id'],
      noIsbn: json['no_isbn'],
      nama: json['nama_pengarang'],
      tglCetak: json['tgl_cetak'],
      jenis: json['jenis'],
      harga: json['harga'],
      kondisi: json['kondisi'],
      hargaProduksi: json['harga_produksi'],
    );
  }
}

void main() {
  runApp(DisplayBook());
}

String _getKondisi(Buku buku) {
  List<String> kondisi = [];
  if (buku.kondisi == '1') {
    kondisi.add('Baik');
  } else {
    kondisi.add('Rusak');
  }

  return kondisi.join(', ');
}

class DisplayBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SingleChildScrollView(
        child: DisplayBookPage(),
      ),
    );
  }
}

class DisplayBookPage extends StatefulWidget {
  @override
  _DisplayBookPageState createState() => _DisplayBookPageState();
}

class _DisplayBookPageState extends State<DisplayBookPage> {
  // ignore: unused_field
  late List<Buku> _filteredBooks = [];
  TextEditingController _searchController = TextEditingController();
  late Future<List<Buku>> _books;

  Future<List<Buku>> fetchBooks() async {
    final response = await http
        .get(Uri.parse('http://localhost/pabwan/buku/tambahtampil.php'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Buku.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<void> _deleteBook(String id) async {
    try {
      var url = Uri.parse('http://localhost/pabwan/buku/hapus.php');
      var response = await http.post(
        url,
        body: {'id': id},
      );

      if (response.statusCode == 200) {
        print('Book deleted successfully');
        setState(() {
          _books = fetchBooks();
        });
      } else {
        print('Failed to delete book. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<List<Buku>> _searchBooks(String query) async {
    var allBooks = await fetchBooks();
    if (query.isEmpty) {
      return allBooks;
    } else {
      return allBooks
          .where(
              (book) => book.noIsbn.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _books = fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Laporan Buku',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/tambahbuku');
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search No ISBN...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _books = _searchBooks(value);
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Buku>>(
              future: _books,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var book = snapshot.data![index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(book.nama),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('No. ISBN: ${book.noIsbn}'),
                              Text('Tanggal Cetak: ${book.tglCetak}'),
                              Text('Jenis: ${book.jenis}'),
                              Text('Harga: ${book.harga}'),
                              Text('Harga Produksi: ${book.hargaProduksi}'),
                              Text('Kondisi: ${_getKondisi(book)}'),
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
                                      builder: (context) => EditBook(book),
                                    ),
                                  );
                                  setState(() {
                                    _books = fetchBooks();
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deleteBook(book.id);
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
    );
  }
}