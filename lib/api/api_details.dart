import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ApiDetails extends StatefulWidget {
  final String newsImage,
      newsTitle,
      newsDate,
      author,
      description,
      content,
      source;
  const ApiDetails({
    super.key,
    required this.newsImage,
    required this.newsTitle,
    required this.newsDate,
    required this.author,
    required this.description,
    required this.content,
    required this.source,
  });

  @override
  State<ApiDetails> createState() => _ApiDetailsState();
}

class _ApiDetailsState extends State<ApiDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SizedBox(
            height: 200,
            width: 400,
            child: CachedNetworkImage(imageUrl: widget.newsImage),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 220, top: 220),
            child: SizedBox(
              height: 200,
              width: 400,
              child: Text(
                widget.author,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 180, top: 250),
            child: SizedBox(
              height: 200,
              width: 400,
              child: Text(
                widget.newsDate,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 300),
            child: SizedBox(
              height: 200,
              width: 400,
              child: Text(
                widget.newsTitle,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 390),
            child: SizedBox(
              height: 200,
              width: 400,
              child: Text(
                widget.description,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
