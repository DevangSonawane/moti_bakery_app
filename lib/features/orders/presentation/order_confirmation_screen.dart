import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/models/order.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Spacer(),
              const Icon(Icons.check_circle, color: Colors.orange, size: 84),
              const SizedBox(height: 12),
              const Text(
                'Order Placed Successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              SelectableText(
                'Order ID: ${order.id}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Cake: ${order.cakeName}'),
                      Text('Flavour: ${order.flavour}'),
                      Text('Weight: ${order.weight.toStringAsFixed(1)} kg'),
                      Text(
                        'Delivery: ${DateFormat('dd MMM yyyy').format(order.deliveryDate)}',
                      ),
                      Text('Total: ₹ ${order.totalPrice.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go('/counter'),
                child: const Text('Place Another Order'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => context.go('/my-orders'),
                child: const Text('View My Orders'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
