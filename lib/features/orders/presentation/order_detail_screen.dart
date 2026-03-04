import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/models/order.dart';
import '../../../shared/widgets/status_badge.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(order.id, style: const TextStyle(fontWeight: FontWeight.w700)),
              StatusBadge(status: order.status),
            ],
          ),
          const SizedBox(height: 16),
          _line('Cake', order.cakeName),
          _line('Flavour', order.flavour),
          _line('Weight', '${order.weight.toStringAsFixed(1)} kg'),
          _line('Delivery Date', DateFormat('dd MMM yyyy').format(order.deliveryDate)),
          _line('Customer', order.customerName ?? '-'),
          _line('Notes', order.notes ?? '-'),
          _line('Total', '₹ ${order.totalPrice.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _line(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          SizedBox(width: 110, child: Text(label)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
