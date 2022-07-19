import 'package:flutter/material.dart';

class OAuthScreen extends StatefulWidget {
  final String details;
  const OAuthScreen({Key? key, required this.details}) : super(key: key);

  @override
  State<OAuthScreen> createState() => _OAuthScreenState();
}

class _OAuthScreenState extends State<OAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Lucy API Result"),
        ),
        body: SafeArea(child: Text(widget.details)));
  }
}
