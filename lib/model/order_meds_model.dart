import 'package:healty_ways/utils/app_urls.dart';

class OrderMedsModel extends MedicineModel {
  final int quantity;

  OrderMedsModel({
    required super.id,
    required super.name,
    required super.formula,
    required super.stockType,
    this.quantity = 1,
    super.description,
    super.imageUrl,
  });

  // Convert OrderMedsModel to JSON
  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'quantity': quantity,
      };

  // Create OrderMedsModel from JSON
  factory OrderMedsModel.fromJson(Map<String, dynamic> json) {
    return OrderMedsModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      formula: json['formula'] as String? ?? '',
      stockType: json['stockType'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  // CopyWith method for immutable updates
  @override
  OrderMedsModel copyWith({
    String? id,
    String? name,
    String? formula,
    String? stockType,
    int? stock,
    String? description,
    String? imageUrl,
  }) {
    return OrderMedsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      formula: formula ?? this.formula,
      stockType: stockType ?? this.stockType,
      quantity: stock ?? this.quantity, // Map 'stock' to 'quantity'
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
