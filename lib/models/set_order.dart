class SetOrder {
  final String paymentUrl;
  final String checkoutId;
  final int orderId;

  SetOrder({this.paymentUrl, this.checkoutId, this.orderId});

  factory SetOrder.fromJson(paymentUrl, checkoutId, orderId) {
    return SetOrder(
        paymentUrl: paymentUrl as String,
        checkoutId: checkoutId as String,
        orderId: orderId as int);
  }
}
