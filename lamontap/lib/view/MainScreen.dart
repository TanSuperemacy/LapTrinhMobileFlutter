import 'package:flutter/material.dart';
import 'dart:io';

class Mainscreen extends StatefulWidget{
  @override
    _MainPageScreen createState() => _MainPageScreen();
}

class _MainPageScreen extends State<Mainscreen>{
  final _formKey = GlobalKey<FormState>();
  String? _dropdownValue;
  String? _radioValue;
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("On tap flutter")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Nhap ten",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "khong dc de trong" : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Chon tuy chon",
                  border: OutlineInputBorder(),
                ),
                  value: _dropdownValue,
                  items: ["a","b","c"].map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => _dropdownValue = val),
              ),
              SizedBox(height: 16),
              Text("Chon gioi tinh: "),
              Row(
                children: [
                  Radio<String>(
                      value: "nam",
                      groupValue: _radioValue,
                    onChanged: (val) => setState(() => _radioValue = val),
                  ),
                  Text("Nam"),
                  Radio<String>(
                    value: "nu",
                    groupValue: _radioValue,
                    onChanged: (val) => setState(() => _radioValue = val),
                  ),
                  Text("Nu"),
                  Radio<String>(
                    value: "khac",
                    groupValue: _radioValue,
                    onChanged: (val) => setState(() => _radioValue = val),
                  ),
                  Text("khac"),
                ],
              ),
              SizedBox(height: 16),
              Image.network("https://flutter.dev/assets/homepage/carousel/slide_1-bg-opaque-2e2fef3bc7a71c9f8a3a9c8f1a9e4b9e2fef3bc7a71c9f8a3a9c8f1a9e4b9e.png",
                height: 150,
              ),
              SizedBox(height: 16),
              Image.asset("assets/sample.png", height: 150),
              SizedBox(height: 16),
              _imageFile != null
                  ? Image.file(_imageFile!, height: 150)
                  : Text("Chưa chọn ảnh từ file"),
              SizedBox(height: 16),
              ElevatedButton(
                  onPressed: (){
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Form hợp lệ!")),
                      );
                    }
                  },
                  child: Text("Xác nhận")),
            ],
          ),
        ),
      ),
    );
  }
}