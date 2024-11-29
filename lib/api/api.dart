import 'package:bloodlife/api/api_details.dart';
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
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        // leading: const Icon(Icons.square),
        title: const Padding(
          padding: EdgeInsets.only(left: 120),
          child: Text(
            "Health News",
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
                  return const Center(
                    child: SpinKitCircle(
                      size: 30,
                      color: Colors.blue,
                    ),
                  );
                } else if (snapshot.hasData) {
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
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          color: Colors.grey.shade300,
                          height: height * .3,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ApiDetails(
                                          newsImage: snapshot
                                              .data!.articles![index].urlToImage
                                              .toString(),
                                          newsTitle: snapshot
                                              .data!.articles![index].title
                                              .toString(),
                                          newsDate: snapshot.data!
                                              .articles![index].publishedAt
                                              .toString(),
                                          author: snapshot
                                              .data!.articles![index].author
                                              .toString(),
                                          description: snapshot.data!
                                              .articles![index].description
                                              .toString(),
                                          content: snapshot
                                              .data!.articles![index].content
                                              .toString(),
                                          source: snapshot
                                              .data!.articles![index].source
                                              .toString(),
                                        ),
                                      ),
                                    );
                                  },
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
                              ),
                              Positioned(
                                top: 200,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 14, top: 12),
                                  child: Container(
                                    child: Text(
                                      'Author: ${snapshot.data!.articles![index].author.toString()}',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 200,
                                right: 50,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 14, top: 12),
                                  child: Container(
                                    child: Text(
                                      'Author: ${snapshot.data!.articles![index].publishedAt.toString()}',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
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
