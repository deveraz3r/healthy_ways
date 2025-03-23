class Medicine {
  final String name;
  final String formula; // Added formula
  final int quantity;
  final String quantityType;
  final String? imageUrl; // Optional image URL

  Medicine({
    required this.name,
    required this.formula,
    required this.quantity,
    required this.quantityType,
    this.imageUrl,
  });
}
