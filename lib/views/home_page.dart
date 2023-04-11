import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _txtController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _txtController.dispose();
    super.dispose();
  }

  // String _getNumberShape() {
  //   final double? number = double.tryParse(_txtController.text);
  //   if (number == null) {
  //     return 'Invalid input';
  //   }
  // }

// Validate the input value
  String? validate(String value) {
    if (value.isEmpty) {
      return 'Please enter a number';
    }

    // Regex pattern to allow digits, decimal point
    final RegExp numberPattern = RegExp(r'^\d*\.?\d{0,15}');
    if (!numberPattern.hasMatch(value)) {
      return 'Please enter a valid number';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Column(
          children: <Widget>[
            const Text("I'm thinking of a number between 1 and 100.", style: TextStyle(fontSize: 30), textAlign: TextAlign.center),
            const SizedBox(height: 25),
            const Text("It's your turn to guess my number!", style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            const SizedBox(height: 25),
            SizedBox(
              height: 200,
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.pink), color: Colors.pink.shade50, borderRadius: BorderRadius.circular(24)),
                child: Form(
                    key: _formKey,
                    child: TextFormField(
                        controller: _txtController,
                        decoration: const InputDecoration(labelText: 'Enter your number', labelStyle: TextStyle(fontSize: 32, color: Colors.pink)),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        maxLength: 3)),
              ),
            )
          ],
        ));
  }
}
