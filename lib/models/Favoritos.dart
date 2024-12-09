class Favoritos {
  final int id;
  final String userEmail;
  final String imageUrl;
  final String nameD;
  final String levelD;

  Favoritos({
    required this.id,
    required this.userEmail,
    required this.imageUrl,
    required this.nameD,
    required this.levelD,
  });

  factory Favoritos.fromJson(Map<String, dynamic> json) {
    return Favoritos(
      id: json['id'],
      userEmail: json['userEmail'],
      imageUrl: json['imageUrl'],
      nameD: json['nameD'],
      levelD: json['levelD'],
    );
  }
}
