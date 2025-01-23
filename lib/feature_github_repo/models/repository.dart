class Repository {
  final String id;
  final String name;
  final String description;
  final int stars;
  final String ownerUsername;
  final String ownerAvatarUrl;

  Repository({
    required this.id,
    required this.name,
    required this.description,
    required this.stars,
    required this.ownerUsername,
    required this.ownerAvatarUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'stars': stars,
      'ownerUsername': ownerUsername,
      'ownerAvatarUrl': ownerAvatarUrl,
    };
  }

  static Repository fromMap(Map<String, dynamic> map) {
    return Repository(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      stars: map['stars'],
      ownerUsername: map['ownerUsername'],
      ownerAvatarUrl: map['ownerAvatarUrl'],
    );
  }
}
