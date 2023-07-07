import 'package:flutter/material.dart';
import 'package:scan_pay/core/enum/scan_pay_type_enum.dart';
import 'package:scan_pay/scan_pay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScanPayController.intiCamera();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeFinancial(),
    );
  }
}

class HomeFinancial extends StatefulWidget {
  const HomeFinancial({super.key});

  @override
  State<HomeFinancial> createState() => _HomeFinancialState();
}

class _HomeFinancialState extends State<HomeFinancial> {
  final ScanPayController scanPayController = ScanPayController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Financial Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                scanPayController.openScanner(
                  context,
                  onSuccess: (code) {
                    print('Scanned code: $code');
                  },
                  scanPayType: ScanPayType.qrCode,
                  accessInputField: () {
                    // Handle accessing input field
                    print('Accessing input field');
                  },
                  pageToBack: 'Previous Page',
                  colorBackground: Colors.blue,
                );
              },
              child: const Text('QrCode Scanner'),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
