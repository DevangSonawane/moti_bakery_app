import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/providers/auth_provider.dart';
import '../../../shared/providers/order_provider.dart';
import '../../../shared/widgets/status_badge.dart';

class MyOrdersScreen extends ConsumerStatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  ConsumerState<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends ConsumerState<MyOrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authControllerProvider).state.user;
      if (user != null) {
        ref.read(orderControllerProvider.notifier).loadMyOrders(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(orderControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: RefreshIndicator(
        onRefresh: () async {
          final user = ref.read(authControllerProvider).state.user;
          if (user != null) {
            await ref.read(orderControllerProvider.notifier).loadMyOrders(user.id);
          }
        },
        child: ordersState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
          data: (orders) {
            if (orders.isEmpty) {
              return const Center(child: Text('No orders yet.'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Text('${order.id} • ${order.cakeName}'),
                  subtitle: Text(
                    '${DateFormat('dd MMM').format(order.deliveryDate)} • ${order.weight}kg',
                  ),
                  trailing: StatusBadge(status: order.status),
                  onTap: () => context.push('/order-detail', extra: order),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
