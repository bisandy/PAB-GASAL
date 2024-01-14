import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../navbar/drawer.dart';
import 'tampilanBuku.dart';

class EditBook extends StatefulWidget {
  final Buku book;

  EditBook(this.book);

  @override
  _EditBookState createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  TextEditingController isbnController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController hargaProduksiController = TextEditingController();
  String isbn = '';
  String nama = '';
  String harga = '';
  String hargaProduksi = '';
  DateTime? selectedDate;
  String? selectedJenis;
  String? selectedKondisi;

  @override
  void initState() {
    super.initState();
    isbnController = TextEditingController(text: widget.book.noIsbn);
    namaController = TextEditingController(text: widget.book.nama);
    hargaController = TextEditingController(text: widget.book.harga);
    hargaProduksiController = TextEditingController(text: widget.book.hargaProduksi);
    selectedDate = (widget.book.tglCetak != null
        ? DateTime.parse(widget.book.tglCetak!)
        : null)!;
    selectedJenis = widget.book.jenis!;
    selectedKondisi = widget.book.kondisi!;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _updateBook() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost/pabwan/buku/update.php'),
      );

      request.fields['id'] = widget.book.id;
      request.fields['no_isbn'] = isbnController.text;
      request.fields['nama'] = namaController.text;
      request.fields['harga'] = hargaController.text;
      request.fields['harga_produksi'] = hargaProduksiController.text;
      request.fields['tgl_cetak'] = selectedDate != null
          ? '${selectedDate?.year}-${selectedDate?.month.toString().padLeft(2, '0')}-${selectedDate?.day.toString().padLeft(2, '0')}'
          : '';
      request.fields['jenis'] = selectedJenis!;
      request.fields['kondisi'] = selectedKondisi!;

      var response = await request.send();

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
        'Edit Buku',
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
            _buildContainer(_buildDatePicker()),
            _buildContainer(_buildComboBox()),
            _buildContainer(_buildRadioButtonGroup()),
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
            _buildTextField('No. ISBN', isbnController, 'Masukkan No. ISBN'),
            SizedBox(height: 10.0,),
            _buildTextField('Nama Pengarang', namaController, 'Masukkan Nama Pengarang'),
            SizedBox(height: 10.0,),
            _buildTextField('Harga', hargaController, 'Masukkan Harga'),
            SizedBox(height: 10.0,),
            _buildTextField('Harga Produksi', hargaProduksiController, 'Masukkan Harga Produksi'),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer(Widget child) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: child,
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

  Widget _buildDatePicker() {
    return Row(
      children: <Widget>[
        Text(
          'Tanggal Cetak',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(width: 16.0),
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: Text(selectedDate == null
              ? 'Pilih Tanggal'
              : '${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}'),
        ),
      ],
    );
  }

  Widget _buildComboBox() {
    return Row(
      children: <Widget>[
        Text(
          'Jenis',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(width: 86.0),
        DropdownButton<String>(
          value: selectedJenis,
          onChanged: (String? newValue) {
            setState(() {
              selectedJenis = newValue!;
            });
          },
          items: <String>['Teknik', 'Seni', 'Ekonomi', 'Humaniora']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRadioButtonGroup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Kondisi',
          style: TextStyle(fontSize: 16.0),
        ),
        Row(
          children: <Widget>[
            Radio(
              value: 'Baik',
              groupValue: selectedKondisi,
              onChanged: (String? value) {
                setState(() {
                  selectedKondisi = value!;
                });
              },
            ),
            Text('Baik'),

            SizedBox(width: 20.0),
            Radio(
              value: 'Rusak',
              groupValue: selectedKondisi,
              onChanged: (String? value) {
                setState(() {
                  selectedKondisi = value!;
                });
              },
            ),
            Text('Rusak'),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        _updateBook();
      },
      child: Text('Submit'),
    );
  }
}