import 'package:flutter/material.dart';
import 'Widget1.dart';
import 'Widget2.dart';
import 'Widget3.dart';

void main() => runApp(FlutterSecurity());

class FlutterSecurity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Main entry point for the application.
    return MaterialApp(
      title: 'Flutter Security App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current time to determine the appropriate image for the greeting.
    DateTime currentTime = DateTime.now();
    String imageName = (currentTime.hour < 12) ? 'gm.png' : 'gn.png';

    // Build the main home page scaffold.
    return Scaffold(
      appBar: AppBar(title: Text('Home Page'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display a welcome message.
            SizedBox(height: 20),
            Text('Welcome to Flutter Security App!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF166534)), textAlign: TextAlign.center),
            // Display an image based on the time of day.
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 5, offset: Offset(0, 3))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('images/$imageName', height: 300, fit: BoxFit.cover),
              ),
            ),
            // Buttons to navigate to different widgets.
            SizedBox(height: 20),
            // Widget1 Button
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Widget1())),
              style: ElevatedButton.styleFrom(primary: Colors.white, side: BorderSide(color: Color(0xFF166534), width: 2), padding: EdgeInsets.all(16)),
              child: Column(
                children: [
                  Text('Widget 1', style: TextStyle(color: Color(0xFF166534), fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Icon(Icons.widgets, color: Color(0xFF166534), size: 40),
                  SizedBox(height: 8),
                  Text('Explore and interact with Google search results. Enter your query and see a list of results with titles, snippets, and links.', style: TextStyle(color: Color(0xFF166534), fontSize: 16), textAlign: TextAlign.center),
                ],
              ),
            ),
            // Widget2 Button
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Widget2())),
              style: ElevatedButton.styleFrom(primary: Colors.white, side: BorderSide(color: Color(0xFF166534), width: 2), padding: EdgeInsets.all(16)),
              child: Column(
                children: [
                  Text('Widget 2', style: TextStyle(color: Color(0xFF166534), fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Icon(Icons.widgets, color: Color(0xFF166534), size: 40),
                  SizedBox(height: 8),
                  Text('Generate strong and secure passwords customized to your preferences. Adjust length, include uppercase, lowercase, numbers, and symbols.', style: TextStyle(color: Color(0xFF166534), fontSize: 16), textAlign: TextAlign.center),
                ],
              ),
            ),
            // Widget3 Button
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Widget3())),
              style: ElevatedButton.styleFrom(primary: Colors.white, side: BorderSide(color: Color(0xFF166534), width: 2), padding: EdgeInsets.all(16)),
              child: Column(
                children: [
                  Text('Widget 3', style: TextStyle(color: Color(0xFF166534), fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Icon(Icons.widgets, color: Color(0xFF166534), size: 40),
                  SizedBox(height: 8),
                  Text('Generate disposable email addresses for temporary use. View received emails and read their content. ', style: TextStyle(color: Color(0xFF166534), fontSize: 16), textAlign: TextAlign.center),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
