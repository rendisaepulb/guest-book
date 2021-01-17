import 'package:flutter/material.dart';

import 'guest_model.dart';

class NewGuestPage extends StatefulWidget {
  NewGuestPage({Key key}) : super(key: key);

  @override
  _NewGuestPageState createState() => _NewGuestPageState();
}

class _NewGuestPageState extends State<NewGuestPage> {
  String _name = '';
  String _address = '';

  void _save() {
    final guest = Guest(
      name: _name,
      address: _address,
      arrivalDate: DateTime.now(),
    );

    Navigator.pop(context, guest);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Tamu'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _name.isEmpty && _address.isEmpty ? null : _save,
        tooltip: 'Simpan',
        child: Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            TextFormField(
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              autofillHints: <String>[AutofillHints.name],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Nama',
                hintText: 'Sumardi',
              ),
              validator: (val) {
                if (val.isEmpty) return 'Harap diisi';
                return null;
              },
              onChanged: (val) {
                setState(() {
                  _name = val;
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.streetAddress,
              textInputAction: TextInputAction.done,
              autofillHints: <String>[AutofillHints.addressState],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: 'Alamat',
                hintText: 'Muara',
              ),
              validator: (val) {
                if (val.isEmpty) return 'Harap diisi';
                return null;
              },
              onChanged: (val) {
                setState(() {
                  _address = val;
                });
              },
              onFieldSubmitted: (value) {
                _save();
              },
            ),
          ],
        ),
      ),
    );
  }
}
