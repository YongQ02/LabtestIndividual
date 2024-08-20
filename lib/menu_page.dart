import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'homepage.dart'; // 确保导入这个文件

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool isLoading = true;
  Map<String, dynamic>? movieData;
  final String apiKey = 'bd3300f908fc6afc85a12790fd1dcfe1'; 
  String currentQuery = 'horror'; // 当前查询类型
  List<String> queries = ['horror', 'action', 'comedy', 'drama']; // 电影类型列表
  int currentIndex = 0; // 当前电影类型索引

  @override
  void initState() {
    super.initState();
    fetchMovieData(currentQuery);
  }

  Future<void> fetchMovieData(String query) async {
    final url = 'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          movieData = data['results'] != null && data['results'].isNotEmpty
              ? data['results'][0] // 获取第一个电影结果
              : null;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load movie data');
      }
    } catch (error) {
      print('Error fetching movie data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _changeMovie() {
    setState(() {
      isLoading = true;
      currentIndex = (currentIndex + 1) % queries.length; // 循环切换电影类型
      currentQuery = queries[currentIndex];
    });
    fetchMovieData(currentQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Page'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isLoading
                    ? CircularProgressIndicator()
                    : movieData != null
                        ? Column(
                            children: [
                              Text(
                                movieData!['title'] ?? 'No title available',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Overview: ${movieData!['overview'] ?? 'No overview available'}',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              movieData!['poster_path'] != null
                                  ? Image.network('https://image.tmdb.org/t/p/w500${movieData!['poster_path']}')
                                  : Text('No poster available'),
                              SizedBox(height: 20),
                            ],
                          )
                        : Text('No data available'),
                ElevatedButton(
                  onPressed: _changeMovie,
                  child: Text(
                    'Change Movie',
                    style: TextStyle(color: Colors.white), // 改变按钮文本颜色
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo, // 改变按钮背景颜色
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/*class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Welcome to the Menu Page!'),
      ),
    );
  }
}*/