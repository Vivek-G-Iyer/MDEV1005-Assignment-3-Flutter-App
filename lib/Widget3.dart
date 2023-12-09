import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';

void main() {
  runApp(MaterialApp(
    home: Widget3(),
  ));
}

class Widget3 extends StatefulWidget {
  @override
  _Widget3State createState() => _Widget3State();
}

class _Widget3State extends State<Widget3> {
  String _email = '';
  bool _isLoading = false;
  List<ReceivedEmail> _receivedEmails = [];
  ReceivedEmail? _selectedEmail;
  String _emailBody = '';

  Future<void> _generateEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('https://www.1secmail.com/api/v1/?action=genRandomMailbox'));
      final data = jsonDecode(response.body);
      final temporaryEmail = data[0];

      setState(() {
        _email = temporaryEmail;
      });

      _checkNewEmails(temporaryEmail);
    } catch (error) {
      print('Error fetching email address: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkNewEmails(String mail) async {
    final emailAddress = mail;
    if (emailAddress.isEmpty) return;

    try {
      final username = emailAddress.split('@')[0];
      final domain = emailAddress.split('@')[1];

      final response = await http
          .get(Uri.parse('https://www.1secmail.com/api/v1/?action=getMessages&login=$username&domain=$domain'));
      final data = jsonDecode(response.body);
      final emails = data;

      setState(() {
        _receivedEmails = emails.map<ReceivedEmail>((email) => ReceivedEmail.fromJson(email)).toList();
      });
    } catch (error) {
      print('Error fetching emails: $error');
    }
  }

  void _copyToClipboard() {
    final tempEmailInput = TextEditingController(text: _email);
    Clipboard.setData(ClipboardData(text: tempEmailInput.text));
  }

  void _refreshEmails() {
    _checkNewEmails(_email);
  }

  void _viewEmailBody(ReceivedEmail currentEmail) async {
    final emailAddress = _email;
    final username = emailAddress.split('@')[0];
    final domain = emailAddress.split('@')[1];

    setState(() {
      _selectedEmail = currentEmail;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://www.1secmail.com/api/v1/?action=readMessage&login=$username&domain=$domain&id=${currentEmail.id}'));
      final data = jsonDecode(response.body);

      setState(() {
        _emailBody = data['body'];
      });
    } catch (error) {
      print('Error fetching email body: $error');
    }
  }

  void _closeEmailBody() {
    setState(() {
      _selectedEmail = null;
      _emailBody = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disposable Email App'),
        backgroundColor: Color(0xFF166534),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Generated Email Address:',
              style: TextStyle(color: Color(0xFF166534)),
            ),
            Text(
              _email,
              style: TextStyle(color: Color(0xFF166534)),
            ),
           Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Expanded( // Wrap the first button with Expanded
      child: ElevatedButton(
        onPressed: _generateEmail,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFF166534)),
           foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
        child: Text(_isLoading ? 'Generating...' : 'Generate Email'),
      ),
    ),
    Expanded( // Wrap the second button with Expanded
      child: ElevatedButton(
        onPressed: _refreshEmails,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFF166534)),
           foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
        child: Text('Refresh Emails'),
      ),
    ),
    Expanded( // Wrap the third button with Expanded
      child: ElevatedButton(
        onPressed: _copyToClipboard,
        style: ButtonStyle(
           foregroundColor: MaterialStateProperty.all(Colors.white),
          backgroundColor: MaterialStateProperty.all(Color(0xFF166534)),
        ),
        child: Text('Copy Email'),
      ),
    ),
  ],
),

            SizedBox(height: 16),
            Text(
              'Received Emails',
              style: TextStyle(color: Color(0xFF166534)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _receivedEmails.length,
                itemBuilder: (context, index) {
                  ReceivedEmail receivedEmail = _receivedEmails[index];
                  return ListTile(
                    title: Text('Subject: ${receivedEmail.subject}', style: TextStyle(color: Color(0xFF166534))),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('From: ${receivedEmail.from}', style: TextStyle(color: Color(0xFF166534))),
                      ],
                    ),
                    onTap: () => _viewEmailBody(receivedEmail),
                  );
                },
              ),
            ),
            if (_selectedEmail != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Email Subject: ${_selectedEmail!.subject}', style: TextStyle(color: Color(0xFF166534))),
                      Text('Email From: ${_selectedEmail!.from}', style: TextStyle(color: Color(0xFF166534))),
                      Text('Email Date: ${_selectedEmail!.date}', style: TextStyle(color: Color(0xFF166534))),
                      Text(
                        'Email Body:',
                        style: TextStyle(color: Color(0xFF166534)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Html(data: _emailBody),
                      ),
                      ElevatedButton(
                        onPressed: _closeEmailBody,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Color(0xFF166534)),
                          minimumSize: MaterialStateProperty.all(Size(120, 40)), // Adjusted button size
                        ),
                        child: Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ReceivedEmail {
  final String id;
  final String from;
  final String subject;
  final DateTime date;

  ReceivedEmail({
    required this.id,
    required this.from,
    required this.subject,
    required this.date,
  });

  factory ReceivedEmail.fromJson(Map<String, dynamic> json) {
    return ReceivedEmail(
      id: json['id'].toString(),
      from: json['from'],
      subject: json['subject'],
      date: DateTime.parse(json['date']),
    );
  }
}
