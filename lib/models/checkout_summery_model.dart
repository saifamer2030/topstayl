class CheckoutSummeryModel {
  final AddressModel address;
  final List<PaymentModel> payments;
  final CheckoutSummery summery;

  CheckoutSummeryModel({this.address, this.payments, this.summery});

  factory CheckoutSummeryModel.fromJson(address, payments, summery) {
    return CheckoutSummeryModel(
        address: AddressModel.fromJson(address),
        payments: PaymentModel.paymentList(payments),
        summery: CheckoutSummery.fromJson(summery));
  }
}

class AddressModel {
  final int addressId;
  final String userName;
  final String country;
  final String city;
  final double cost;
  final String deliveryPeriod;
  final String area;
  final String street;
  final String address;
  final String phone;
  final String gps;
  final double freeShipping;

  AddressModel(
      {this.addressId,
      this.userName,
      this.country,
      this.city,
      this.cost,
      this.deliveryPeriod,
      this.area,
      this.street,
      this.address,
      this.phone,
      this.gps,
      this.freeShipping});

  factory AddressModel.fromJson(savedAddressJson) {
    return AddressModel(
        addressId: savedAddressJson['address_id'] as int,
        userName: savedAddressJson['user_name'] as String,
        country: savedAddressJson['country'] as String,
        city: savedAddressJson['city'] as String,
        cost: double.parse(savedAddressJson['cost']),
        deliveryPeriod: savedAddressJson['delivery_peroid'] as String,
        area: savedAddressJson['area'] as String,
        street: savedAddressJson['street'] as String,
        address: savedAddressJson['address'] as String,
        phone: savedAddressJson['phone'] as String,
        gps: savedAddressJson['gps'] as String,
        freeShipping: double.parse(savedAddressJson['freeShipping']));
  }
}

class PaymentModel {
  final int paymentId;
  final String paymentName;
  final double cost;
  final int available;
  final bool isDiscount;
  final bool isPercentage;

  PaymentModel(
      {this.paymentId,
      this.paymentName,
      this.cost,
      this.available,
      this.isDiscount,
      this.isPercentage});

  factory PaymentModel.fromJson(parsedPaymentJson) {
    return PaymentModel(
      paymentId: parsedPaymentJson['id'] as int,
      paymentName: parsedPaymentJson['name'] as String,
      cost: double.parse(parsedPaymentJson['cost']),
      available: parsedPaymentJson['available'] as int,
      isDiscount: parsedPaymentJson['isDiscount'] as bool,
      isPercentage: parsedPaymentJson['isPercentage'] as bool,
    );
  }

  static List<PaymentModel> paymentList(parsedJson) {
    var _list = parsedJson as List;
    List<PaymentModel> paymentList =
        _list.map((payment) => PaymentModel.fromJson(payment)).toList();

    return paymentList;
  }
}

class CheckoutSummery {
  final int userCheckoutId;
  final double total;
  final double discount;
  final double availableCostForCoupon;

  CheckoutSummery(
      {this.userCheckoutId,
      this.total,
      this.discount,
      this.availableCostForCoupon});

  factory CheckoutSummery.fromJson(parsedSummery) {
    return CheckoutSummery(
        userCheckoutId: parsedSummery['userCheckoutId'] as int,
        total: double.parse(parsedSummery['total']),
        discount: double.parse(parsedSummery['discount']),
        availableCostForCoupon:
            double.parse(parsedSummery['available_cost_for_coupon']));
  }
}
