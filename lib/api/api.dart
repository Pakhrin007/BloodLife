import 'package:bloodlife/models/healthchannelheadlinesmodel.dart';
import 'package:bloodlife/view_models/news_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class Api extends StatefulWidget {
  const Api({super.key});

  @override
  State<Api> createState() => _ApiState();
}

class _ApiState extends State<Api> {
  NewsViewModel newsViewModel = NewsViewModel();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.square),
        title: const Padding(
          padding: EdgeInsets.only(left: 100),
          child: Text(
            "News",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height,
            width: width,
            child: FutureBuilder(
              future: newsViewModel.fetchnewschannelheadlinesapi(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      size: 30,
                      color: Colors.blue,
                    ),
                  );
                } else if (snapshot.hasData) {
                  // Filter articles to exclude null or empty `urlToImage`
                  final filteredArticles = snapshot.data!.articles!
                      .where((article) =>
                          article.urlToImage != null &&
                          article.urlToImage!.isNotEmpty)
                      .toList();

                  if (filteredArticles.isEmpty) {
                    return const Center(
                      child: Text("No articles with images available."),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredArticles.length,
                    itemBuilder: (context, index) {
                      final article = filteredArticles[index];
                      return Container(
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: CachedNetworkImage(
                                  imageUrl: article.urlToImage.toString(),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    child: spinkit2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text("Failed to load news."),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

const spinkit2 = SpinKitFadingCircle(
  color: Colors.blue,
  size: 30,
);
