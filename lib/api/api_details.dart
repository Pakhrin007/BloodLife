import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ApiDetails extends StatelessWidget {
  final String newsImage;
  final String newsTitle;
  final String newsDate;
  final String author;
  final String description;
  final String content;
  final String source;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            newsImage.isNotEmpty
                ? Image.network(newsImage)
                : const Placeholder(fallbackHeight: 200),
            const SizedBox(height: 16),
            Text(
              newsTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Published: ${formatDate(newsDate)}',
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'Poppins-Light'),
            ),
            const SizedBox(height: 8),
            Text(
              'Author: $author',
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'Poppins-Light'),
            ),
            const SizedBox(height: 16),
            Text(
              description.isNotEmpty
                  ? description
                  : 'No description available.',
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins-Light',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              content.isNotEmpty ? content : 'No content available.',
              style: const TextStyle(fontSize: 16, fontFamily: 'Poppins-Light'),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(String publishedDate) {
    try {
      final dateTime = DateTime.parse(publishedDate);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return 'Invalid date';
    }
  }
}
