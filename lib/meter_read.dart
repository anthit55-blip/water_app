import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MeterReadScreen extends StatefulWidget {
  const MeterReadScreen({super.key});
  @override
  State<MeterReadScreen> createState() => _MeterReadScreenState();
}

class _MeterReadScreenState extends State<MeterReadScreen> {
  final _houseNo = TextEditingController();
  final _current = TextEditingController();
  final _prev = TextEditingController();
  File? _image;
  final _picker = ImagePicker();
  final _db = FirebaseFirestore.instance;

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _save() async {
    final house = _houseNo.text.trim();
    final curr = double.tryParse(_current.text) ?? 0;
    final prev = double.tryParse(_prev.text) ?? 0;
    final unit = curr - prev;

    await _db.collection('meter_reads').add({
      'house_no': house,
      'current_read': curr,
      'prev_read': prev,
      'units': unit,
      'read_date': FieldValue.serverTimestamp(),
      'image_path': _image?.path,
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('บันทึกสำเร็จ ✅')));
      _houseNo.clear();
      _current.clear();
      _prev.clear();
      setState(() => _image = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('บันทึกค่าน้ำ'), backgroundColor: Colors.blue),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          TextField(controller: _houseNo, decoration: const InputDecoration(labelText: 'บ้านเลขที่', border: OutlineInputBorder())),
          const SizedBox(height: 15),
          TextField(controller: _prev, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'เลขมิเตอร์เดือนก่อน', border: OutlineInputBorder())),
          const SizedBox(height: 15),
          TextField(controller: _current, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'เลขมิเตอร์เดือนนี้', border: OutlineInputBorder())),
          const SizedBox(height: 15),
          ListTile(
            title: const Text('ถ่ายรูปมิเตอร์'),
            trailing: const Icon(Icons.camera_alt),
            onTap: _pickImage,
          ),
          if (_image != null) Image.file(_image!, height: 150),
          const SizedBox(height: 25),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _save, style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)), child: const Text('บันทึกข้อมูล', style: TextStyle(fontSize: 18)))),
        ]),
      ),
    );
  }
}
