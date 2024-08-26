import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:heathmate/screens/responsemodel.dart';
import 'package:http/http.dart' as http;

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  late final TextEditingController promptController;
  String responseText = '';
  late ResponseModel _responseModel;
  String api="sk-IvKm-VSdNKZ2gs8R3LVjN1tjKMZFc0RYrzXHDLhRV3T3BlbkFJx1scWhCkheFrBpGmB0ZQaZ5EKF7AYlz5krPjWlUTsA";

  @override
  void initState() {
    promptController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: const Text("ChatBot"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PromptBldr(responseTxt: responseText),
          TextFormFieldBldr(
            promptController: promptController,
            btnFun: completionFun,
          ),
        ],
      ),
    );
  }

  completionFun() async {
    setState(() => responseText = "Loading...");

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $api',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          'messages': [
          {'role': 'user', 'content': 'Hello, how are you?'},
          {'role': 'assistant', 'content': promptController.text},
        ],
          "max_tokens": 250,
          "temperature": 0.7,
          "top_p": 1,
        
     
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        setState(() {
          responseText = responseData['choices'][0]['message']['content'] ?? 'No response';
        });
      }   else if (response.statusCode == 429) {
      print('Error 429: Too many requests. Please slow down.');
    }else {
        setState(() {
          responseText = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        responseText = 'Failed to load response: $e';
      });
    }
  }
}


class PromptBldr extends StatelessWidget {
  const PromptBldr({super.key, required this.responseTxt});
  final String responseTxt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Text(
              responseTxt,
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFormFieldBldr extends StatelessWidget {
  const TextFormFieldBldr({
    super.key,
    required this.promptController,
    required this.btnFun,
  });

  final TextEditingController promptController;
  final Function btnFun;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 50),
        child: Row(
          children: [
            Flexible(
              child: TextFormField(
                cursorColor: Colors.white,
                controller: promptController,
                autofocus: true,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: "Ask me anything",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                ),
              ),
            ),
            Container(
              color: Colors.white24,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: () => btnFun(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
