import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../navbar/drawer.dart';
import 'tampilanDosen.dart';

class EditDosen extends StatefulWidget {
  final Dosen dosen;

  EditDosen(this.dosen);

  @override
  _EditDosenState createState() => _EditDosenState();
}

class _EditDosenState extends State<EditDosen> {
  late TextEditingController namaController;
  late TextEditingController npmController;
  late TextEditingController noTelpController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.dosen.nama);
    npmController = TextEditingController(text: widget.dosen.npm);
    noTelpController = TextEditingController(text: widget.dosen.noTelp);
  }

  Future<void> _updateDosen() async {
    try {
      var url = Uri.parse('http://localhost/pabwan/dosen/dosenupdate.php');
      var response = await http.post(url, body: {
        'id': widget.dosen.id,
        'nama': namaController.text,
        'npm': npmController.text,
        'no_telpon': noTelpController.text,
      });

      if (response.statusCode == 200) {
        print('Data updated successfully');
        Navigator.pop(context);
      } else {
        print('Error updating data. Status code: ${response.statusCode}');
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
        'Edit Dosen',
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
            _buildTextField('No. Telepon', noTelpController, 'Masukkan No. Telepon'),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hintText) {
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
        _updateDosen();
      },
      child: Text('Submit'),
    );
  }
}