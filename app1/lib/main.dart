import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: NewsApp(),
  ));
}

class NewsApp extends StatefulWidget {
  @override
  _NewsAppState createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> with SingleTickerProviderStateMixin {
  late List data;
  late TabController _tabController;
  String query = 'Real Estate';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    data = [];


    fetchData();
  }

  fetchData() async {
    http.Response response;
    response = await http.get(Uri.parse('https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=26fc8d0f1f1248e28cfb5e4b09d0200d'));

    setState(() {
      var articles = jsonDecode(response.body)['articles'];
      data = articles != null ? List.from(articles) : [];
      data.removeWhere((item) => item['title'] == null || item['urlToImage'] == null);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Đặt kích thước tối thiểu cho Column
          children: <Widget>[
            Text(
              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),

            SizedBox(height: 8),
            Text(
              'Explode',

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch(context: context, delegate: ArticleSearch());
              if (result != null && result != query) {
                setState(() {
                  query = result;
                  fetchData();
                });
              }
            },
          ),
        ],

        bottom: TabBar(

          controller: _tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50), // this rounds the corners
            color: Colors.black,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          labelPadding: EdgeInsets.all(0.002),
          tabs: [
            Tab(child: Container(width: 100, child: Align(alignment: Alignment.center, child: Text('All')))), // thay đổi kích thước tab ở đây
            Tab(child: Container(width: 100, child: Align(alignment: Alignment.center, child: Text('Yahoo Finance')))), // thay đổi kích thước tab ở đây
            Tab(child: Container(width: 100, child: Align(alignment: Alignment.center, child: Text('investors')))), // thay đổi kích thước tab ở đây
          ],
        ),
      ),
      
      body: data != null
          ? TabBarView(
        controller: _tabController,
        children: [
          // All tab
          ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(article: data[index]),
                    ),
                  );
                },
                leading: Container(
                  width: 100,
                  height: 100,
                  child: Image.network(
                    data[index]['urlToImage'] ,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  data[index]['description'] ,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                subtitle: Text(

                  data[index]['title'] ,
                  style: TextStyle(fontSize: 16 ),
                  overflow: TextOverflow.ellipsis,

                ),
              );
            },
          ),

          // Stock Market tab
          ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              if (data[index]['title'].contains('Yahoo Finance')) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(article: data[index]),
                      ),
                    );
                  },
                  leading: Container(
                    width: 100,
                    height: 100,
                    child: Image.network(
                      data[index]['urlToImage'] ,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    data[index]['title'] ,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    data[index]['description'] ,
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                );
              } else {
                return Container(); // Return an empty container for non-matching articles
              }
            },
          ),



          ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              if (data[index]['title'].contains('Investor')) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(article: data[index]),
                      ),
                    );
                  },
                  leading: Container(
                    width: 100,
                    height: 100,
                    child: Image.network(
                      data[index]['urlToImage'] ,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    data[index]['title'] ,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    data[index]['description'] ,
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                );
              } else {
                return Container(); // Return an empty container for non-matching articles
              }
            },
          ),

        ],
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class ArticleSearch extends SearchDelegate<String> {
  final articles = [
    "Stock Market",
    "Real Estate",
    "Startups",
    "Economy",
    "Investing",
    "Technology",
    "Entrepreneurship",
    // Add more articles here
  ];

  final recentArticles = [
    "Breaking News",
    "World News",


    // Add more recent articles here
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: fetchData(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          var articles = snapshot.data as List;
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              var article = articles[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(25.0), // Bo tròn góc
                child: Card(
                  elevation: 5.0, // Thêm elevation để tạo hiệu ứng đổ bóng
                  child: Column(
                    children: <Widget>[
                      Image.network(article['urlToImage'] ??
                          'https://via.placeholder.com/150'),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              article['title'],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'BY ${article['author'] ?? 'Unknown'}',
                              style: TextStyle(
                                  fontSize: 14, fontStyle: FontStyle.italic),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'DESCRIPTION: ' + article['description'],
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'CONTENT: ' + article['content'],
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return Text('No results found.');
        }
      },
    );
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentArticles
        : articles.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) =>
          ListTile(
            onTap: () {
              query = suggestionList[index];
              showResults(context);
            },
            leading: Icon(Icons.article),
            title: RichText(
              text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
      itemCount: suggestionList.length,
    );
  }

  Future<List> fetchData(String query) async {
    http.Response response;
    response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=26fc8d0f1f1248e28cfb5e4b09d0200d'));
    var articles = jsonDecode(response.body)['articles'];
    articles.removeWhere((item) =>
    item['title'] == null || item['urlToImage'] == null);
    return articles;
  }
}

  class DetailScreen extends StatelessWidget {
  final Map article;

  DetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article['title']),
      ),
      body: SingleChildScrollView( // Sử dụng SingleChildScrollView
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(article['urlToImage'] ?? 'https://via.placeholder.com/150'),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      article['title'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'BY ${article['author'] ?? 'Unknown'}',
                      style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                    SizedBox(height: 10),
                    Text(
                     'DESCRIPTION: '+ article['description'],
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'CONTENT: '+ article['content'],
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
