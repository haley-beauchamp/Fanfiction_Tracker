import 'dart:convert';

class Fanfic {
  final int id;
  final String link;
  final String fandom;
  final String title;
  final String author;
  final String summary;

  Fanfic({
    required this.id,
    required this.link,
    required this.fandom,
    required this.title,
    required this.author,
    required this.summary,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'link': link,
      'fandom': fandom,
      'title': title,
      'author': author,
      'summary': summary,
    };
  }

  factory Fanfic.fromMap(Map<String, dynamic> map) {
    return Fanfic(
      id: map['fanfic_id'] ?? 0,
      link: map['link'] ?? '',
      fandom: map['fandom'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      summary: map['summary'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Fanfic.fromJson(String source) => Fanfic.fromMap(json.decode(source));
}
