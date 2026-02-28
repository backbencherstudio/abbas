import 'package:flutter/material.dart';
import '../../../../../cors/routes/route_names.dart';
import '../../../../widgets/secondary_appber.dart';
import '../../widgets/option_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Subscriptions extends StatefulWidget {
  const Subscriptions({super.key});

  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}
class _SubscriptionsState extends State<Subscriptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SecondaryAppBar(title: 'Subscription & Payment'),
          Padding(
            padding:  EdgeInsets.all(16.0.sp),
            child: Column(
              children: [
                SizedBox(height: 40.h,),
                OptionCard(title: "Track Payment", iconPath: '', route: RouteNames.trackPayment,hasPrefixIcon: false,),
                SizedBox(height: 20.h,),
                OptionCard(title: "Payment History", iconPath: "", route: RouteNames.paymentHistoryScreen,hasPrefixIcon: false,),
                SizedBox(height: 20.h,),
                OptionCard(title: "Change Stripe Payment Account", iconPath: "", route: RouteNames.changeStripe,hasPrefixIcon: false,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}