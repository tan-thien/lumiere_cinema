import 'package:flutter/material.dart';
import 'package:lumiere_cinema/models/news_model.dart';
import 'package:lumiere_cinema/services/news_service.dart';
import 'news_detail_screen.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  late Future<List<News>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = NewsService.getAllNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin Tức'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<News>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final newsList = snapshot.data!;
            return ListView.builder(
              itemCount: newsList.length + 1,
              itemBuilder: (context, index) {
                if (index == newsList.length) {
                  return const SizedBox(height: 90); // 👈 Khoảng trống cuối
                }

                final news = newsList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewsDetailScreen(news: news),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),

                            child: Hero(
                              tag:
                                  'news-image-${news.id}', // hoặc news.tieuDe nếu không có id
                              child: Image.network(
                                news.anhTinTuc,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              news.tieuDe,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
