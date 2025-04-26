class User {
  final String id;
  final String username;
  final String email;
  final int score;

  User({required this.id, required this.username, required this.email,required this.score});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'], 
      username: json['username'],
      email: json['email'],
      score:json['score']
    );
  }
}
