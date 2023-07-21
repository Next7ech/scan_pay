import 'package:flutter/material.dart';
import 'package:scan_pay/scan_pay.dart';

import 'info_code_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  final ScanPay scanPay = ScanPay();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Financial Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) {
                  return scanPay(
                    context,
                    scanPayType: ScanPayType.barcode,
                    maxDetectedCode: 50,
                    minDetectedCode: 40,
                    backgroundColor: Colors.black.withOpacity(0.5),
                    detectorPrimaryColor: Colors.white,
                    detectorSecondaryColor: Colors.red,
                    primaryColor: Colors.red,
                    secondaryColor: Colors.white,
                    helpText: 'Scan Slip',
                    digitableBoletoPage: () => const Text('Digitable Boleto'),
                    titleButtonText: 'Cancel',
                    titleButtonTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 16),
                    helpTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 16),
                    onSuccess: (code) {
                      navigateToInfoCode(context, code);
                    },
                  );
                },
              ),
            );
          },
          child: const Text('Scan Slip'),
        ),
      ),
    );
  }

  void navigateToInfoCode(BuildContext context, String code) {
    if (checkCode(code)) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => InfoCode(code: code),
        ),
      );
    } else {
      print("O código tem mais de 20 zeros. Navegação não permitida.");
    }
  }

  bool checkCode(String code) {
    int count = 0;
    for (int i = 0; i < code.length; i++) {
      if (code[i] == '0') {
        count++;
      }
    }
    if (count > 20) {
      return false;
    } else {
      return true;
    }
  }
}
