import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () async {
      Navigator.pushReplacementNamed(context, '/login');
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 179, 255),
        automaticallyImplyLeading: false,
      ),
      backgroundColor:  Color.fromARGB(255, 0, 179, 255),
      body: Center(
        child: Column(
          children: [
            Text(
              'UJIAN AKHIR SEMESTER',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5.0),
            Text(
              'MATAKULIAH PENGEMBANGAN TEKNOLOGI MOBILE',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 45.0),
            Container(
              height: 300,
              child: Image.asset('assets/middle.png'),
            ),
            SizedBox(height: 65.0),
            Text(
              'FAKULTAS TEKNIK',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'PRODI TEKNIK INFORMATIKA',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
             Text(
                'UNIVERSITAS 17 AGUSTUS 1945 SURABAYA',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
             Text(
              '2023',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}