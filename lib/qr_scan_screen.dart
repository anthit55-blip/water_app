import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});
  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isScanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('สแกน QR Code'), backgroundColor: Colors.blue),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (_isScanned) return;
              final code = capture.barcodes.first.rawValue;
              if (code != null) {
                setState(() => _isScanned = true);
                _controller.stop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('พบข้อมูล: $code')),
                );
                Navigator.pop(context, code);
              }
            },
          ),
          const Center(child: Text('วาง QR Code ให้อยู่ในกรอบ', style: TextStyle(color: Colors.white, fontSize: 18, backgroundColor: Colors.black45))),
        ],
      ),
    );
  }
}
