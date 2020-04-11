import 'package:flutter/cupertino.dart';

class OrderModel {
  final int orderId;
  final String orderDate;
  final int orderStatus;
  final int itemsCount;
  final int paymentId;
  final double totalPrice;

  OrderModel(
      {@required this.orderId,
      @required this.orderDate,
      @required this.orderStatus,
      @required this.itemsCount,
      this.paymentId,
      this.totalPrice});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        orderId: json['orderId'] as int,
        orderDate: json['orderDate'] as String,
        orderStatus: json['orderStatus'] as int,
        itemsCount: json['orderItems'] as int,
        paymentId: int.parse(json['payment_id']),
        totalPrice: double.parse(json['totalprice']));
  }
}

class DetailsModel {
  final int optionId;
  final String productName;
  final int quantity;
  final double price;
  final String brand;
  final String image;
  final String type;
  final String value;

  DetailsModel(
      {this.optionId,
      this.quantity,
      this.price,
      this.productName,
      this.value,
      this.type,
      this.brand,
      this.image});

  factory DetailsModel.fromJson(json) {
    return DetailsModel(
        optionId: json['option_id'] as int,
        quantity: json['quantity'] as int,
        price: double.parse(json['price']),
        productName: json['name'] as String,
        brand: json['brand'] as String,
        image: json['image'] as String,
        type: json['type'] as String,
        value: json['value'] as String);
  }
}

class AddressModel {
  final int id;
  final String name;
  final String phone;
  final String country;
  final String city;
  final String area;
  final String street;
  final String description;

  AddressModel(
      {this.id,
      this.name,
      this.phone,
      this.country,
      this.city,
      this.area,
      this.street,
      this.description});

  factory AddressModel.fromJson(json) {
    return AddressModel(
        id: json['id'] as int,
        name: json['user_name'] as String,
        phone: json['phone_number'] as String,
        country: json['country'] as String,
        city: json['city'] as String,
        area: json['area_name'] as String,
        street: json['street_name'],
        description: json['address_description']);
  }
}

class OrderDetailsModel {
  final OrderModel orderModel;
  final AddressModel addressModel;
  final List<DetailsModel> listOfDetails;

  OrderDetailsModel({this.orderModel, this.addressModel, this.listOfDetails});

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
        orderModel: OrderModel.fromJson(json['order']),
        addressModel: AddressModel.fromJson(json['address']),
        listOfDetails: parseList(json['details']));
  }

  static List<DetailsModel> parseList(parsedList) {
    var _list = parsedList as List;
    return _list.map((option) => DetailsModel.fromJson(option)).toList();
  }
}
