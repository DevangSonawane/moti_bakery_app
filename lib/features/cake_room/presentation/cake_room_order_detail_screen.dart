import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/models/order.dart';
import '../../../shared/providers/order_provider.dart';
import '../../../shared/widgets/status_badge.dart';

class CakeRoomOrderDetailScreen extends ConsumerStatefulWidget {
  const CakeRoomOrderDetailScreen({super.key, required this.order});

  final Order order;

  @override
  ConsumerState<CakeRoomOrderDetailScreen> createState() =>
      _CakeRoomOrderDetailScreenState();
}

class _CakeRoomOrderDetailScreenState
    extends ConsumerState<CakeRoomOrderDetailScreen> {
  bool _updating = false;

  Future<void> _updateStatus(OrderStatus status) async {
    setState(() => _updating = true);
    await ref.read(orderControllerProvider.notifier).updateStatus(
          widget.order.id,
          status,
        );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Scaffold(
      appBar: AppBar(title: const Text('Order Detail')),
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
          const SizedBox(height: 12),
          _line('Cake', order.cakeName),
          _line('Flavour', order.flavour),
          _line('Weight', '${order.weight.toStringAsFixed(1)} kg'),
          _line('Customer', order.customerName ?? '-'),
          _line('Delivery Date', DateFormat('dd MMM yyyy').format(order.deliveryDate)),
          _line('Notes', order.notes ?? '-'),
          _line('Total', '₹ ${order.totalPrice.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          if (order.status == OrderStatus.newOrder)
            ElevatedButton(
              onPressed: _updating
                  ? null
                  : () => _updateStatus(OrderStatus.inProgress),
              child: const Text('Start Preparation'),
            ),
          if (order.status == OrderStatus.inProgress)
            ElevatedButton(
              onPressed: _updating
                  ? null
                  : () => _updateStatus(OrderStatus.prepared),
              child: const Text('Mark as Prepared'),
            ),
          if (order.status == OrderStatus.prepared)
            const Text(
              'Order already prepared. No actions available.',
              style: TextStyle(color: Colors.black54),
            ),
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
