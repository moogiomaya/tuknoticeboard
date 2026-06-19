import 'package:equatable/equatable.dart';

class Notice extends Equatable {
  final int noticeId;
  final String title;
  final String body;
  final int? categoryId;
  final String? categoryName;
  final String createdBy;
  final String? approvedBy;
  final String status;
  final String? attachmentUrl;
  final DateTime createdAt;
  final DateTime? publishedAt;
  final DateTime? expiresAt;
  final bool isRead;

  Notice({
    required this.noticeId,
    required this.title,
    required this.body,
    this.categoryId,
    this.categoryName,
    required this.createdBy,
    this.approvedBy,
    required this.status,
    this.attachmentUrl,
    required this.createdAt,
    this.publishedAt,
    this.expiresAt,
    this.isRead = false,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      noticeId: json['notice_id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      createdBy: json['created_by'] ?? '',
      approvedBy: json['approved_by'],
      status: json['status'] ?? '',
      attachmentUrl: json['attachment_url'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'])
          : null,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'])
          : null,
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'notice_id': noticeId,
        'title': title,
        'body': body,
        'category_id': categoryId,
        'category_name': categoryName,
        'created_by': createdBy,
        'approved_by': approvedBy,
        'status': status,
        'attachment_url': attachmentUrl,
        'created_at': createdAt.toIso8601String(),
        'published_at': publishedAt?.toIso8601String(),
        'expires_at': expiresAt?.toIso8601String(),
        'is_read': isRead,
      };

  @override
  List<Object?> get props => [noticeId];
}