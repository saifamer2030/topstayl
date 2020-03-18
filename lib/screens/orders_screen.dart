import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/helper/size_config.dart';
import 'package:topstyle/models/orders_model.dart';
import 'package:topstyle/providers/network_provider.dart';
import 'package:topstyle/providers/user_provider.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';
import 'package:topstyle/widgets/connectivity_widget.dart';

import '../helper/appLocalization.dart';
import '../providers/order_provider.dart';
import '../widgets/OrderItem.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = "orders-screen";

  UserProvider user = UserProvider();
  List<OrderModel> orderData = [];

  getUserOrderData(BuildContext context) async {
    var token = await user.isAuthenticated();
    orderData = await Provider.of<OrdersProvider>(context, listen: false)
        .getUserOrder(token['Authorization']);
  }

  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).translate("myOrders_page_title"),
          style: TextStyle(fontSize: widgetSize.mainTitle),
        ),
        centerTitle: true,
      ),
      body: Provider<NetworkProvider>.value(
        value: NetworkProvider(),
        child: Consumer<NetworkProvider>(
          builder: (context, value, _) => Center(
              child: ConnectivityWidget(
            networkProvider: value,
            child: FutureBuilder(
              future: getUserOrderData(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return orderData.length > 0
                      ? ListView.builder(
                          itemBuilder: (ctx, index) => OrderItem(
                              orderData[index].orderId,
                              orderData[index].orderDate,
                              orderData[index].orderStatus,
                              orderData[index].itemsCount),
                          itemCount: orderData.length,
                        )
                      : Center(
                          child: Text(
                            AppLocalization.of(context).translate('no_order'),
                            style: TextStyle(fontSize: widgetSize.content),
                          ),
                        );
                } else {
                  return Center(
                    child: AdaptiveProgressIndicator(),
                  );
                }
              },
            ),
          )),
        ),
      ),
    );
  }
}
