import 'package:flutter/material.dart';
import '../models/notice.dart';

class NoticeDetailScreen extends StatelessWidget {
  final Notice notice;

  const NoticeDetailScreen({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(notice.title),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notice.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.category, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    notice.categoryName ?? 'General',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const Spacer(),
                  Text(
                    notice.publishedAt != null
                        ? 'Published: ${_formatDate(notice.publishedAt!)}'
                        : 'Draft',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),
              Text(notice.body),
              if (notice.attachmentUrl != null) ...[
                const SizedBox(height: 16),
                const Text('Attachment:'),
                const SizedBox(height: 8),
                // You can show an image preview if it's an image, or a download link
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.attach_file),
                    title: const Text('View Attachment'),
                    onTap: () {
                      // Open attachment URL using url_launcher
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}