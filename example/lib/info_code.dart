import 'package:flutter/material.dart';

class InfoCode extends StatefulWidget {
  const InfoCode({super.key, required this.code});
  final String code;

  @override
  State<InfoCode> createState() => _InfoCodeState();
}

class _InfoCodeState extends State<InfoCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Code'),
      ),
      body: Center(
        child: Text(widget.code),
      ),
    );
  }
}
