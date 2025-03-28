class OrderUpdateModel {
  final DateTime time;
  final String message;

  OrderUpdateModel({
    required this.time,
    required this.message,
  });

  Map<String, dynamic> toJson() => {
        'time': time.toIso8601String(),
        'message': message,
      };

  factory OrderUpdateModel.fromJson(Map<String, dynamic> json) =>
      OrderUpdateModel(
        time: DateTime.parse(json['time']),
        message: json['message'],
      );
}
