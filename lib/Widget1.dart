import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';


class Widget1 extends StatefulWidget {
  @override
  _Widget1State createState() => _Widget1State();
}


class _Widget1State extends State<Widget1> {

  List<Map<String, dynamic>> searchResults = [];

  // Controller for the query input field.
  TextEditingController queryController = TextEditingController();

  // manage loading state and error messages.
  bool isLoading = false;
  String errorMessage = '';


  @override
  void initState() {
    super.initState();
    fetchData('react'); 
  }

  // fetch search results based on the provided query.
  Future<void> fetchData(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    // Google Custom Search API key and custom search engine ID.
    final apiKey = 'AIzaSyBCAHGfup1kQgl1LVm2-NhtN9T7J3TS1oo';
    final cx = '12fb9a073f01d41aa';

    // API URL for Google Custom Search.
    final apiUrl = 'https://www.googleapis.com/customsearch/v1?key=$apiKey&cx=$cx&q=$query';

    try {
      // Fetch data from the API.
      final response = await http.get(Uri.parse(apiUrl));
      final data = jsonDecode(response.body);

      // Update state with search results.
      setState(() {
        searchResults = (data['items'] as List<dynamic>).cast<Map<String, dynamic>>() ?? [];
        isLoading = false;
      });
    } catch (error) {
      // Handle errors and update state.
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching data. Please try again.';
      });
      print('Error fetching data: $error');
    }
  }

  // open a URL in the default browser.
  void _openUrlInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Search Results'),
        backgroundColor: Color(0xFF166534),
      ),
      body: Column(
        children: [
          // Search input field and button.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: queryController,
                    decoration: InputDecoration(
                      labelText: 'Enter your query',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF166534)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF166534)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    fetchData(queryController.text);
                  },
                  child: Text('Search'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF166534),
                    onPrimary: Colors.white
                  ),
                ),
              ],
            ),
          ),
          // Loading indicator or error message.
          if (isLoading)
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF166534)),
            )
          else if (errorMessage.isNotEmpty)
            Text(errorMessage, style: TextStyle(color: Colors.red))
          else
            // Display search results.
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final result = searchResults[index];
                  final title = result['title'];
                  final snippet = result['snippet'];
                  final link = result['link'];
                  final imageUrl =
                      result['pagemap']?['cse_thumbnail']?[0]?['src'] ?? '';

                  return ListTile(
                    title: Text(title ?? 'No title'),
                    subtitle: Text(snippet ?? 'No snippet'),
                    onTap: () {
                      _openUrlInBrowser(link);
                    },
                    leading: imageUrl != null && imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : SizedBox.shrink(),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
