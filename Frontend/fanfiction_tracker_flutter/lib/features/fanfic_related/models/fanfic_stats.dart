import 'dart:convert';

class FanficStats {
  final int fanficId;
  final String title;
  final int timesRated;
  final double? averageRating;

  FanficStats({
    required this.fanficId,
    required this.title,
    required this.timesRated,
    required this.averageRating,
  });

  Map<String, dynamic> toMap() {
    return {
      'fanfic_id': fanficId,
      'title': title,
      'times_rated': timesRated,
      'avg_rating': averageRating,
    };
  }

  factory FanficStats.fromMap(Map<String, dynamic> map) {
    return FanficStats(
      fanficId: map['fanfic_id'] ?? 0,
      title: map['title'] ?? '',
      timesRated: map['times_rated'] ?? 0,
      averageRating: (map['avg_rating'] is int) ? (map['avg_rating'] as int).toDouble() : (map['avg_rating']),
    );
  }

  String toJson() => json.encode(toMap());

  factory FanficStats.fromJson(String source) => FanficStats.fromMap(json.decode(source));
}