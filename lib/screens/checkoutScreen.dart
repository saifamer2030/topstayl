import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/models/checkout_summery_model.dart';
import 'package:topstyle/providers/network_provider.dart';
import 'package:topstyle/screens/address_screen.dart';
import 'package:topstyle/screens/payment_method.dart';
import 'package:topstyle/screens/pervious_address.dart';
import 'package:topstyle/widgets/connectivity_widget.dart';

class CheckoutScreen extends StatefulWidget {
  final int pageIndex;
  final AddressModel address;

  CheckoutScreen(this.pageIndex, [this.address]);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.index = widget.pageIndex;
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        bottom: TabBar(
          onTap: (tabIndex) {
            if (widget.address != null) {
            } else {
              if (tabController.indexIsChanging)
                setState(() {
                  tabController.index = 0;
                });
            }
          },
          controller: tabController,
          indicatorWeight: 3.0,
          labelStyle: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'tajawal'),
          tabs: <Widget>[
            Tab(
              icon: SvgPicture.asset(
                'assets/icons/delivary.svg',
                width: 20.0,
                height: 20.0,
                fit: BoxFit.fitHeight,
              ),
              text: AppLocalization.of(context).translate('delivery_location'),
            ),
            Tab(
              icon: Image.asset(
                'assets/icons/complete_order.png',
                width: 20.0,
                height: 20.0,
              ),
              text: AppLocalization.of(context).translate('confirm_order'),
            )
          ],
        ),
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).translate('payment_method_screen_title'),
        ),
      ),
      body: Provider<NetworkProvider>(
        builder: (context) => NetworkProvider(),
        child: Consumer<NetworkProvider>(
          builder: (context, value, _) => Center(
              child: ConnectivityWidget(
            networkProvider: value,
            child: TabBarView(
              controller: tabController,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                widget.address == null
                    ? AddressScreen(tabController)
                    : PreviousAddress(widget.address),
                PaymentMethod(tabController),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
