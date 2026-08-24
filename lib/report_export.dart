import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class ReportExportScreen extends StatefulWidget {
  const ReportExportScreen({super.key});
  @override
  State<ReportExportScreen> createState() => _ReportExportScreenState();
}

class _ReportExportScreenState extends State<ReportExportScreen> {
  final _db = FirebaseFirestore.instance;
  bool _isExporting = false;

  Future<void> _exportPdf() async {
    setState(() => _isExporting = true);
    try {
      final snapshot = await _db.collection('meter_reads').orderBy('read_date', descending: true).get();
      final data = snapshot.docs;

      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('รายงานการอ่านมิเตอร์น้ำ', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['บ้านเลขที่', 'เดือนก่อน', 'เดือนนี้', 'หน่วยที่ใช้', 'วันที่'],
                data: data.map((doc) {
                  final d = doc.data();
                  return [
                    d['house_no'] ?? '-',
                    d['prev_read']?.toString() ?? '-',
                    d['current_read']?.toString() ?? '-',
                    d['units']?.toString() ?? '-',
                    d['read_date'] != null ? DateFormat('dd/MM/yyyy').format((d['read_date'] as Timestamp).toDate()) : '-',
                  ];
                }).toList(),
              ),
            ],
          ),
        ),
      );

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/รายงานค่าน้ำ.pdf');
      await file.writeAsBytes(await pdf.save());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ส่งออกสำเร็จ! ที่: ${file.path}')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ผิดพลาด: $e')));
      }
    } finally {
      setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('รายงาน & ส่งออก'), backgroundColor: Colors.blue),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf, size: 24),
                label: const Text('ส่งออกรายงาน PDF', style: TextStyle(fontSize: 18)),
                onPressed: _isExporting ? null : _exportPdf,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
              ),
            ),
            const SizedBox(height: 20),
            if (_isExporting) const CircularProgressIndicator(),
          ]),
        ),
      ),
    );
  }
}

