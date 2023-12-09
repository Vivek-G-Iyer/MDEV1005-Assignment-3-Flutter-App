import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'dart:math';


class Widget2 extends StatefulWidget {
  @override
  _Widget2State createState() => _Widget2State();
}


class _Widget2State extends State<Widget2> {
  // Properties for managing password generation options.
  String generatedPassword = '';
  int passwordLength = 12;
  bool includeUppercase = true;
  bool includeLowercase = true;
  bool includeNumbers = true;
  bool includeSymbols = true;

  //  generate a password based on selected options.
  void generatePassword() {
    String validChars = '';

    if (includeUppercase) validChars += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (includeLowercase) validChars += 'abcdefghijklmnopqrstuvwxyz';
    if (includeNumbers) validChars += '0123456789';
    if (includeSymbols) validChars += '!@#\$%^&*()-_=+';

    if (validChars.isEmpty) {
      validChars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    }

    String password = '';
    final Random random = Random();

    for (int i = 0; i < passwordLength; i++) {
      password += validChars[random.nextInt(validChars.length)];
    }

    setState(() {
      generatedPassword = password;
    });
  }

  // copy the generated password to the clipboard.
  void copyToClipboard() {
    FlutterClipboard.copy(generatedPassword)
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Password copied to clipboard'),
                  ],
                ),
                duration: Duration(seconds: 2),
              ),
            ))
        .catchError((error) => print('Error: $error'));
  }

  // Build method for rendering the UI.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Generator'),
        backgroundColor: Color(0xFF166534),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the generated password.
            Text(
              'Generated Password:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF166534)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SelectableText(
                generatedPassword,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
            // Button to generate a password and copy it to the clipboard.
            ElevatedButton(
              onPressed: () {
                generatePassword();
                copyToClipboard();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF166534)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: Text('Generate Password and Copy to Clipboard'),
            ),
            SizedBox(height: 16),
            // Slider for selecting password length.
            Row(
              children: [
                Text('Password Length: $passwordLength', style: TextStyle(color: Color(0xFF166534))),
                Expanded(
                  child: Slider(
                    value: passwordLength.toDouble(),
                    min: 6,
                    max: 20,
                    onChanged: (value) {
                      setState(() {
                        passwordLength = value.toInt();
                      });
                    },
                  ),
                ),
              ],
            ),
            // Checkboxes for password generation options.
            CheckboxListTile(
              title: Text('Include Uppercase', style: TextStyle(color: Color(0xFF166534))),
              value: includeUppercase,
              onChanged: (value) {
                setState(() {
                  includeUppercase = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Include Lowercase', style: TextStyle(color: Color(0xFF166534))),
              value: includeLowercase,
              onChanged: (value) {
                setState(() {
                  includeLowercase = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Include Numbers', style: TextStyle(color: Color(0xFF166534))),
              value: includeNumbers,
              onChanged: (value) {
                setState(() {
                  includeNumbers = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Include Symbols', style: TextStyle(color: Color(0xFF166534))),
              value: includeSymbols,
              onChanged: (value) {
                setState(() {
                  includeSymbols = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
