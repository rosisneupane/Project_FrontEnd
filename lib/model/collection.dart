import 'dart:convert';

class Collection {
  final String id;
  final String name;
  final String description;
  final List<Video> videos;

  Collection({
    required this.id,
    required this.name,
    required this.description,
    required this.videos,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      videos: (json['videos'] as List)
          .map((video) => Video.fromJson(video))
          .toList(),
    );
  }

  static List<Collection> listFromJson(String jsonString) {
    final data = json.decode(jsonString) as List;
    return data.map((item) => Collection.fromJson(item)).toList();
  }
}

class Video {
  final String id;
  final String title;
  final String url;
  final String collectionId;

  Video({
    required this.id,
    required this.title,
    required this.url,
    required this.collectionId,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      collectionId: json['collection_id'],
    );
  }
}
