class Medicine {
  final String name;
  final String formula; // Added formula
  final String quantity;
  final bool isInStock;
  final String? imageUrl; // Optional image URL

  Medicine({
    required this.name,
    required this.formula,
    required this.quantity,
    required this.isInStock,
    this.imageUrl,
  });
}
