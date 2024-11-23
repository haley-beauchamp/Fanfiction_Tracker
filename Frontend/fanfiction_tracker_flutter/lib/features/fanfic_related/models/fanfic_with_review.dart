import 'dart:convert';

class FanficWithReview {
  final int fanficId;
  final String link;
  final String fandom;
  final String title;
  final String author;
  final String summary;
  final List<String> tags;
  final int userId;
  final double rating;
  final String review;
  final String favoriteMoments;
  final String assignedList;
  final List<String> favoriteTags;

  FanficWithReview({
    required this.fanficId,
    required this.link,
    required this.fandom,
    required this.title,
    required this.author,
    required this.summary,
    required this.tags,
    required this.userId,
    required this.rating,
    required this.review,
    required this.favoriteMoments,
    required this.assignedList,
    required this.favoriteTags,
  });

  Map<String, dynamic> toMap() {
    return {
      'fanfic_id': fanficId,
      'link': link,
      'fandom': fandom,
      'title': title,
      'author': author,
      'summary': summary,
      'tags': tags,
      'user_id': userId,
      'rating': rating,
      'review': review,
      'favorite_moments': favoriteMoments,
      'assigned_list': assignedList,
      'favorite_tags': favoriteTags,
    };
  }

  factory FanficWithReview.fromMap(Map<String, dynamic> map) {
    return FanficWithReview(
      fanficId: map['fanfic_id'] ?? 0,
      link: map['link'] ?? '',
      fandom: map['fandom'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      summary: map['summary'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      userId: map['user_id'] ?? 0,
      rating: (map['rating'] is int) ? (map['rating'] as int).toDouble() : (map['rating'] ?? 0.0),
      review: map['review'] ?? '',
      favoriteMoments: map['favorite_moments'] ?? '',
      assignedList: map['assigned_list'] ?? '',
      favoriteTags: List<String>.from(map['favorite_tags'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory FanficWithReview.fromJson(String source) => FanficWithReview.fromMap(json.decode(source));
}