import 'package:bloodlife/models/healthchannelheadlinesmodel.dart';
import 'package:bloodlife/view_models/news_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Api extends StatefulWidget {
  const Api({super.key});

  @override
  State<Api> createState() => _ApiState();
}

class _ApiState extends State<Api> {
  NewsViewModel newsViewModel = NewsViewModel();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

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
      body: FutureBuilder(
        future: newsViewModel.fetchnewschannelheadlinesapi(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitCircle(
                size: 30,
                color: Colors.blue,
              ),
            );
          } else if (snapshot.hasData) {
            // Filter articles with non-null `urlToImage`
            final articlesWithImages = snapshot.data!.articles!
                .where((article) =>
                    article.urlToImage != null &&
                    article.urlToImage!.isNotEmpty)
                .toList();

            if (articlesWithImages.isEmpty) {
              return const Center(
                child: Text("No articles with images available."),
              );
            }

            return ListView.builder(
              itemCount: articlesWithImages.length,
              itemBuilder: (context, index) {
                final article = articlesWithImages[index];
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(
                    imageUrl: article.urlToImage!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const SpinKitFadingCircle(
                      color: Colors.blue,
                      size: 30,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image, size: 50),
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
    );
  }
}
