import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const WaterApp());

class WaterApp extends StatelessWidget {
  const WaterApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'ระบบประปาหมู่บ้าน',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
    home: const WaterHome(),
  );
}

class WaterHome extends StatefulWidget {
  const WaterHome({super.key});
  @override State<WaterHome> createState() => _WaterHomeState();
}

class _WaterHomeState extends State<WaterHome> {
  late final WebViewController controller;
  String? error;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() => loading = true),
        onPageFinished: (_) => setState(() => loading = false),
        onWebResourceError: (e) {
          if (e.isForMainFrame ?? false) {
            setState(() { loading = false; error = e.description; });
          }
        },
      ));
    load();
  }

  Future<void> load() async {
    try {
      final html = await rootBundle.loadString('assets/app.html');
      await controller.loadHtmlString(
        html,
        baseUrl: 'https://appassets.androidplatform.net/assets/',
      );
    } catch (e) {
      setState(() { loading = false; error = '$e'; });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Stack(children: [
      if (error == null) WebViewWidget(controller: controller),
      if (loading) const Center(child: CircularProgressIndicator()),
      if (error != null) Center(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.error_outline, size: 56),
          const SizedBox(height: 12),
          const Text('เปิดระบบไม่สำเร็จ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(error!, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(onPressed: load, child: const Text('ลองใหม่')),
        ]),
      )),
    ])),
  );
}
