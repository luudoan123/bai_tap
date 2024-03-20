import 'dart:convert';



import 'package:dart_project/article_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
   
   
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left:16.0),
          child: Column(
            children: [
              Text( 
                DateFormat('EEE, dd MM yyyy').format(DateTime.now()),
                
               ),
          
             //title
              const Text('Explode',
            
                                
                   
                   
               ),
              // input

              const SizedBox(height: 20),

              
                Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: TextFormField(
                   
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade300,
                      filled: true,
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'SEACH FOR ACTICLE',

                    ),
                  ),
                ),
                  const SizedBox(height: 20),
                // thanh coong cụ
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 20.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Center(
                        child: Text('ALL'),
                      ),
                    ),

                  ],
                ),
            ]),
        ),
      
      ),
    
    );
  }

  Future<List<article>> getPosts() async {
    const url = "https://newsapi.org/v2/top-headlines? country=us&category=business&apiKey=26fc8d0f1f1248e28cfb5e4b09d0200d";
    final response = await http.get(Uri.parse(url));
    final body = json.decode(response.body) as Map<String, dynamic>;
    // print(body);
    final List<article> result = [];
    for (final articles in body["articles"]) {
      result.add(article(
        title: articles["title"],
        urlToImage: articles["urlToImage"],
      ));
    }
    return [];
  }
}
