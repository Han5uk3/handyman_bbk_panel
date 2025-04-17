class ProductsModel {
  final String? id;
  final String? name;
  final String? price;
  final String? details;
  final String? discount;
  final String? availability;
  final String? image;

  ProductsModel({
    this.id,
    this.name,
    this.price,
    this.details,
    this.discount,
    this.availability,
    this.image,
  });

  factory ProductsModel.fromMap(Map<String, dynamic> map) {
    return ProductsModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      details: map['details'] ?? '',
      discount: map['discount'] ?? '0',
      availability: map['availability'] ?? '',
      image: map['image'] ?? 'No image selected',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'details': details,
      'discount': discount,
      'availability': availability,
      'image': image,
    };
  }
}
