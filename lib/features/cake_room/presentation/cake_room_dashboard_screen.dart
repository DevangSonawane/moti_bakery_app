import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/providers/auth_provider.dart';
import '../../../shared/providers/order_provider.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/models/order.dart';

class CakeRoomDashboardScreen extends ConsumerStatefulWidget {
  const CakeRoomDashboardScreen({super.key});

  @override
  ConsumerState<CakeRoomDashboardScreen> createState() =>
      _CakeRoomDashboardScreenState();
}

class _CakeRoomDashboardScreenState
    extends ConsumerState<CakeRoomDashboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderControllerProvider.notifier).loadQueue();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cake Room Queue'),
        actions: [
          IconButton(
            onPressed: () => ref.read(authControllerProvider).logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Tab>[
            Tab(text: 'New'),
            Tab(text: 'In Progress'),
            Tab(text: 'Prepared'),
          ],
        ),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (_) => TabBarView(
          controller: _tabController,
          children: <Widget>[
            _OrderList(status: OrderStatus.newOrder),
            _OrderList(status: OrderStatus.inProgress),
            _OrderList(status: OrderStatus.prepared),
          ],
        ),
      ),
    );
  }
}

class _OrderList extends ConsumerWidget {
  const _OrderList({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersByStatusProvider(status));

    if (orders.isEmpty) {
      return const Center(child: Text('No orders in this tab.'));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(orderControllerProvider.notifier).loadQueue(),
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: orders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final order = orders[index];
          return ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text('${order.id} • ${order.cakeName}'),
            subtitle: Text(
              '${order.flavour} • ${order.weight.toStringAsFixed(1)}kg • ${DateFormat('dd MMM, hh:mm a').format(order.deliveryDate)}',
            ),
            trailing: StatusBadge(status: order.status),
            onTap: () => context.push('/cake-room/order-detail', extra: order),
          );
        },
      ),
    );
  }
}
