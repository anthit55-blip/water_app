import 'package:flutter/material.dart';
import 'meter_read.dart';
import 'qr_scan_screen.dart';
import 'report_export.dart';
import 'rate_setting_screen.dart';
import 'line_notify_setting.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ผู้ดูแลระบบ — ประปาหมู่บ้าน'), backgroundColor: Colors.blue),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: [
          _item(Icons.people, 'จัดการผู้ใช้', Colors.blue, context),
          _item(Icons.qr_code, 'สแกน QR', Colors.brown, context, screen: const QrScanScreen()),
          _item(Icons.edit_note, 'บันทึกค่าน้ำ', Colors.green, context, screen: const MeterReadScreen()),
          _item(Icons.price_change, 'ตั้งค่าราคา', Colors.amber, context, screen: const RateSettingScreen()),
          _item(Icons.receipt_long, 'ออกบิล', Colors.orange, context),
          _item(Icons.payment, 'รับชำระเงิน', Colors.purple, context),
          _item(Icons.bar_chart, 'รายงาน', Colors.teal, context, screen: const ReportExportScreen()),
          _item(Icons.notifications, 'ตั้งค่า Line', Colors.green, context, screen: const LineNotifyScreen()),
          _item(Icons.handyman, 'แจ้งซ่อม', Colors.red, context),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String label, Color color, BuildContext ctx, {Widget? screen}) {
    return Card(
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: screen != null ? () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => screen!)) : null,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 16)),
        ]),
      ),
    );
  }
}
