class CartItemModel {
  final int id;
  final String productName;
  final String productImageUrl;
  final String brandName;
  final double productPrice;
  int quantity;
  final int discount;
  final int isAvailable;
  final int availableQuantity;
  final String category;
  final String type;
  final String value;

  CartItemModel(
      {this.id,
      this.productName,
      this.productImageUrl,
      this.brandName,
      this.productPrice,
      this.quantity,
      this.availableQuantity,
      this.discount,
      this.isAvailable,
      this.category,
      this.type,
      this.value});

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
        id: json['id'] as int,
        productName: json['name'] as String,
        productImageUrl: json['image'] as String,
        brandName: json['brand'] as String,
        productPrice: double.parse(json['price']),
        quantity: json['quantity'] as int,
        availableQuantity: json['availableQuantity'] as int,
        discount: json['discount'] as int,
        isAvailable: json['isAvailable'] as int,
        category: json['category'] as String,
        type: json['type'] as String,
        value: json['value'] as String);
  }

  static List<CartItemModel> parsedJson(parsedJson) {
    var _list = parsedJson as List;
    List<CartItemModel> cartItems =
        _list.map((carts) => CartItemModel.fromJson(carts)).toList();
    return cartItems;
  }
}
