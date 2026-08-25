import 'package:flutter/material.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('บ้านเลขที่ 123/4 — ประปาหมู่บ้าน'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          const Card(child: ListTile(title: Text('นายสุข สบาย'), subtitle: Text('มิเตอร์: M0089'))),
          const SizedBox(height: 16),
          Card(color: Colors.blue.shade50, child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(children: [
              Text('บิลเดือนล่าสุด — สิงหาคม 2568', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('18.5 หน่วย', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('ค่าน้ำ: 185.00 บาท', style: TextStyle(fontSize: 26, color: Colors.red, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Chip(label: Text('ยังไม่ชำระ'), backgroundColor: Colors.orange),
            ]),
          )),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: ElevatedButton.icon(icon: const Icon(Icons.history), label: const Text('ประวัติ'), onPressed: () {})),
            const SizedBox(width: 10),
            Expanded(child: ElevatedButton.icon(icon: const Icon(Icons.report_problem), label: const Text('แจ้งปัญหา'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange), onPressed: () {})),
          ]),
          const SizedBox(height: 15),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(icon: const Icon(Icons.payment), label: const Text('ชำระเงิน', style: TextStyle(fontSize: 18)), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.all(14)), onPressed: () {})),
        ]),
      ),
    );
  }
}
