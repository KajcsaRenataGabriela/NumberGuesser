import 'dart:math';

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
  String _text = '';
  String _hintText = '';
  bool _hasWon = false;
  final int _numberToBeGuessed = Random().nextInt(100 - 1);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _txtController.dispose();
    super.dispose();
  }

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a number';
    }
    return '';
  }

  void showAlertBox() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('You guessed right!'),
              // Trims all unnecessary zeros from end
              content: Text('It was ${_txtController.text}.'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => const MyHomePage(title: 'Number Guesser App')));
                    },
                    child: const Text('Try again!', style: TextStyle(color: Colors.pink))),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK', style: TextStyle(color: Colors.pink)))
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    print(_numberToBeGuessed.toString() + "----------------------------------------------------");
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(title: Text(widget.title), automaticallyImplyLeading: false),
            body: Column(children: <Widget>[
              const Text("I'm thinking of a number between 1 and 100.",
                  style: TextStyle(fontSize: 30), textAlign: TextAlign.center),
              const SizedBox(height: 25),
              const Text("It's your turn to guess my number!",
                  style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
              const SizedBox(height: 25),
              if (_text.isNotEmpty)
                Text('Your tried $_text.\n$_hintText',
                    style: const TextStyle(fontSize: 20), textAlign: TextAlign.center)
              else
                const SizedBox(),
              SizedBox(
                  height: 200,
                  child: Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.pink),
                          color: Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(24)),
                      child: Column(children: <Widget>[
                        const Text('Try a number', style: TextStyle(fontSize: 32, color: Colors.pink)),
                        Form(
                            key: _formKey,
                            child: TextFormField(
                                style: const TextStyle(color: Colors.pink),
                                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                controller: _txtController,
                                maxLength: 3,
                                validator: (String? value) {
                                  return validate(value);
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  FilteringTextInputFormatter(RegExp(r'^0+(?!$)'), allow: false),
                                  // If number ir higher than 100, it will automatically convert to max value
                                  TextInputFormatter.withFunction(
                                      (TextEditingValue oldValue, TextEditingValue newValue) {
                                    if (newValue.text.isEmpty) {
                                      return newValue;
                                    }
                                    return int.parse(newValue.text) < 100
                                        ? newValue
                                        : const TextEditingValue(text: '100');
                                  })
                                ])),
                        TextButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.pink.shade100)),
                            child: Text(
                                _txtController.text.isNotEmpty && int.parse(_txtController.text) == _numberToBeGuessed
                                    ? 'Reset'
                                    : 'Guess',
                                style: const TextStyle(fontSize: 20.0, color: Colors.pink)),
                            onPressed: () {
                              setState(() {});
                              // Verify if form is not empty
                              if (!_formKey.currentState!.validate()) {
                                // Use reset implementation in case user has won
                                if (_hasWon) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const MyHomePage(title: 'Number Guesser App')));
                                } else {
                                  _text = _txtController.text;
                                  final int inputNumber = int.parse(_text);
                                  if (inputNumber == _numberToBeGuessed) {
                                    _hintText = 'You won!';
                                    showAlertBox();
                                    _hasWon = true;
                                  } else if (inputNumber < _numberToBeGuessed) {
                                    _hintText = 'Try higher!';
                                  } else {
                                    _hintText = 'Try lower';
                                  }
                                }
                              }
                            })
                      ])))
            ])));
  }
}
