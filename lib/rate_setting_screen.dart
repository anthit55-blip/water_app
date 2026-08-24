import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RateSettingScreen extends StatefulWidget {
  const RateSettingScreen({super.key});
  @override
  State<RateSettingScreen> createState() => _RateSettingScreenState();
}

class _RateSettingScreenState extends State<RateSettingScreen> {
  final _price = TextEditingController(text: '10.0');
  final _minUnit = TextEditingController(text: '5');
  final _minPrice = TextEditingController(text: '50.0');
  final _db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final doc = await _db.collection('settings').doc('rate').get();
    if (doc.exists) {
      final data = doc.data()!;
      _price.text = data['price_per_unit'].toString();
      _minUnit.text = data['min_unit'].toString();
      _minPrice.text = data['min_price'].toString();
    }
  }

  Future<void> _save() async {
    await _db.collection('settings').doc('rate').set({
      'price_per_unit': double.tryParse(_price.text) ?? 10.0,
      'min_unit': int.tryParse(_minUnit.text) ?? 5,
      'min_price': double.tryParse(_minPrice.text) ?? 50.0,
      'updated_at': FieldValue.serverTimestamp(),
    });
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('บันทึกราคาสำเร็จ ✅')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ตั้งค่าราคาน้ำ'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          TextField(controller: _price, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'ราคาต่อหน่วย (บาท)', border: OutlineInputBorder())),
          const SizedBox(height: 15),
          TextField(controller: _minUnit, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'จำนวนหน่วยขั้นต่ำ', border: OutlineInputBorder())),
          const SizedBox(height: 15),
          TextField(controller: _minPrice, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'ค่าบริการขั้นต่ำ (บาท)', border: OutlineInputBorder())),
          const SizedBox(height: 25),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _save, style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)), child: const Text('บันทึกการตั้งค่า', style: TextStyle(fontSize: 18)))),
        ]),
      ),
    );
  }
}
