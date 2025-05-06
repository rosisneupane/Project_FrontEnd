import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:new_ui/config.dart';
import 'package:new_ui/screen/pdf_reader_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResourceFilesScreen extends StatefulWidget {
  final String type;
  const ResourceFilesScreen({super.key, required this.type});

  @override
  State<ResourceFilesScreen> createState() => _ResourceFilesScreenState();
}

class _ResourceFilesScreenState extends State<ResourceFilesScreen> {
  List<dynamic> pdfList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPdfs();
  }

  Future<void> fetchPdfs() async {
    setState(() => isLoading = true);
    String url = AppConfig.apiUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('JWT Token not found');
    }
    final response = await http.get(
       Uri.parse("$url/media?media_type=pdf&category=${widget.type}"),
      headers: {
        'Authorization': 'Bearer $token',
      }, // adjust as needed
    );

    if (response.statusCode == 200) {
      setState(() {
        pdfList = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      // Handle error
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resources Files"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : pdfList.isEmpty
              ? Center(child: Text("No files found"))
              : ListView.builder(
                  itemCount: pdfList.length,
                  itemBuilder: (context, index) {
                    final pdf = pdfList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PdfReaderScreen(url: pdf["url"]),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 6.0),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            title: Text(
                              pdf["title"] ?? "Untitled",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
