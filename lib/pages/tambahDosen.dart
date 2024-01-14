import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../navbar/drawer.dart';

void main() {
  runApp(AddDosen());
}

class AddDosen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SingleChildScrollView(
        child: AddDosenPage(),
      ),
    );
  }
}

class AddDosenPage extends StatefulWidget {
  @override
  _AddDosenPageState createState() => _AddDosenPageState();
}

class _AddDosenPageState extends State<AddDosenPage> {
  List<int>? imageBytes;
  TextEditingController namaController = TextEditingController();
  TextEditingController npmController = TextEditingController();
  TextEditingController noTelpController = TextEditingController();
  String nama = '';
  String npm = '';
  String noTelp = '';

  Future<void> _selectImage(BuildContext context) async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        imageBytes = bytes;
      });
    }
  }

  Future<void> _showMessageBox() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Data Dosen Berhasil Ditambahkan"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost/pabwan/dosen/dosenapi.php'),
      );
      request.fields['nama'] = namaController.text;
      request.fields['npm'] = npmController.text;
      request.fields['no_telpon'] = noTelpController.text;
      if (imageBytes != null) {
        var imageFile = http.MultipartFile.fromBytes('foto', imageBytes!);
        request.files.add(imageFile);
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Data inserted successfully');
      } else {
        print('Error inserting data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(
        'Tambah Dosen',
        style: TextStyle(fontWeight: FontWeight.w900),
      ),
      centerTitle: true,
    ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildTextFieldCard(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldCard() {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField('Nama', namaController, 'Masukkan Nama'),
            SizedBox(
              height: 10.0,
            ),
            _buildTextField('NPM', npmController, 'Masukkan NPM'),
            SizedBox(
              height: 10.0,
            ),
            _buildTextField(
                'No. Telepon', noTelpController, 'Masukkan No. Telepon'),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hintText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        _showMessageBox();
      },
      child: Text('Submit'),
    );
  }
}