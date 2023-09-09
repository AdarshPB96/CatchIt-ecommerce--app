
import 'package:catch_it_project/core/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:order_tracker_zen/order_tracker_zen.dart';

class TrackOrder extends StatelessWidget {
  OrderDetails order;

  TrackOrder({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    List<TrackerData> trackerDataList = [];

    List<Map<String, String>> trackingSteps = [];

    if (order.orderStatus == "Live") {
      trackingSteps = [
        {"title": "Order Placed", "status": "Live"},
      ];
    } else if (order.orderStatus == "Shipped") {
      trackingSteps = [
        {"title": "Order Placed", "status": "Completed"},
        {"title": "Order Shipped", "status": "Shipped"},
      ];
    } else if (order.orderStatus == "Out for Delivery") {
      trackingSteps = [
        {"title": "Order Placed", "status": "Completed"},
        {"title": "Order Shipped", "status": "Completed"},
        {"title": "Out for Delivery", "status": "Out for Delivery"},
      ];
    } else if (order.orderStatus == "Delivered") {
      trackingSteps = [
        {"title": "Order Placed", "status": "Completed"},
        {"title": "Order Shipped", "status": "Completed"},
        {"title": "Out for Delivery", "status": "Completed"},
        {"title": "Delivered", "status": "Delivered"},
      ];
    }

    List<String> stepDates = [
      "Sat, 8 Apr '22",
      "Sun, 9 Apr '22",
      "Mon, 10 Apr '22",
      "Tue, 11 Apr '22",
    ];

    for (int i = 0; i < trackingSteps.length; i++) {
      var step = trackingSteps[i];
      String title = step['title'].toString();
      String status = step['status'].toString();

      Color statusColor =
          status == order.orderStatus ? Colors.green : Colors.grey;

      TrackerDetails trackerDetails = TrackerDetails(
        title: title,
        datetime: order.orderStatus == title ? "Now" : "",
      );

      TrackerData trackerData = TrackerData(
        title: title,
        date: stepDates[i],
        tracker_details: [trackerDetails],
      );

      trackerDataList.add(trackerData);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Tracker Zen"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: OrderTrackerZen(
                tracker_data: trackerDataList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
