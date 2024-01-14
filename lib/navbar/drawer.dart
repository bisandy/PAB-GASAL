import 'package:uas_gasal/pages/tampilanDosen.dart';
import 'package:uas_gasal/pages/tambahDosen.dart';
import '../pages/tambahBuku.dart';
import '../pages/tambahUser.dart';
import '../pages/tampilanBuku.dart';
import '../pages/tampilanUser.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).shadowColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/untag.png',
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 8.0),
                Text(
                  'Aplikasi Buku',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Buku'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBookPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Pengguna'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddUserPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Dosen'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDosenPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Laporan Buku'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DisplayBookPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment_ind),
            title: Text('Laporan Pengguna'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DisplayUserPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment_ind),
            title: Text('List Dosen'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DisplayDosenPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
