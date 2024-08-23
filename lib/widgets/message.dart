import 'package:flutter/material.dart';

class Messages extends StatefulWidget{
  final  List<Map<String,dynamic>> messages;
  const Messages({super.key, required this.messages});

  @override
  State<Messages> createState() => _MessageState();
}

class _MessageState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}