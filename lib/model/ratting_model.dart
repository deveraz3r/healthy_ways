class RatingModel {
  final String ratedBy;
  final int stars;
  final String? message;

  RatingModel({
    required this.ratedBy,
    required this.stars,
    this.message,
  });

  Map<String, dynamic> toJson() => {
        'ratedBy': ratedBy,
        'stars': stars,
        'message': message,
      };

  factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
        ratedBy: json['ratedBy'],
        stars: json['stars'],
        message: json['message'],
      );
}
