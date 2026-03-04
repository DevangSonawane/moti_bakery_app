import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/models/cake.dart';
import '../../../shared/models/order.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/providers/order_provider.dart';
import '../../../shared/providers/pricing_provider.dart';
import '../../../utils/price_calculator.dart';

class PlaceOrderScreen extends ConsumerStatefulWidget {
  const PlaceOrderScreen({super.key, required this.cake});

  final Cake cake;

  @override
  ConsumerState<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends ConsumerState<PlaceOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerController = TextEditingController();
  final _notesController = TextEditingController();

  late String _selectedFlavour;
  late double _weight;
  DateTime _deliveryDate = DateTime.now();
  TimeOfDay? _deliveryTime;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedFlavour = widget.cake.flavours.first;
    _weight = widget.cake.minWeight;
  }

  @override
  void dispose() {
    _customerController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deliveryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _deliveryDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _deliveryTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _deliveryTime = picked);
    }
  }

  Future<void> _submit(double totalPrice) async {
    if (!_formKey.currentState!.validate() || _isSubmitting) {
      return;
    }

    final user = ref.read(authControllerProvider).state.user;
    if (user == null) return;

    setState(() => _isSubmitting = true);

    try {
      final random = Random();
      final order = Order(
        id: 'ORD-${1000 + random.nextInt(8999)}',
        cakeId: widget.cake.id,
        cakeName: widget.cake.name,
        flavour: _selectedFlavour,
        weight: _weight,
        deliveryDate: _deliveryDate,
        deliveryTime: _deliveryTime == null
            ? null
            : DateTime(
                _deliveryDate.year,
                _deliveryDate.month,
                _deliveryDate.day,
                _deliveryTime!.hour,
                _deliveryTime!.minute,
              ),
        customerName:
            _customerController.text.trim().isEmpty ? null : _customerController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        totalPrice: totalPrice,
        status: OrderStatus.newOrder,
        createdAt: DateTime.now(),
        createdBy: user.id,
      );

      final created = await ref.read(orderControllerProvider.notifier).placeOrder(order);
      if (!mounted) return;
      context.go('/order-confirmation', extra: created);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placement failed. Please retry.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rules = ref.watch(pricingRulesProvider).valueOrNull ?? const [];
    final total = PriceCalculator.calculate(
      baseRate: widget.cake.baseRate ?? 0,
      weight: _weight,
      flavour: _selectedFlavour,
      categories: widget.cake.categories,
      rules: rules,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Place Order')),
      body: Stack(
        children: <Widget>[
          ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      initialValue: widget.cake.name,
                      readOnly: true,
                      decoration: const InputDecoration(labelText: 'Cake Design'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedFlavour,
                      decoration: const InputDecoration(labelText: 'Flavour'),
                      items: widget.cake.flavours
                          .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedFlavour = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Text('Weight: ${_weight.toStringAsFixed(1)} kg'),
                    Slider(
                      value: _weight,
                      min: widget.cake.minWeight,
                      max: widget.cake.maxWeight,
                      divisions: ((widget.cake.maxWeight - widget.cake.minWeight) * 10)
                          .round(),
                      label: _weight.toStringAsFixed(1),
                      onChanged: (value) => setState(() => _weight = value),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Delivery Date'),
                      subtitle: Text(DateFormat('dd MMM yyyy').format(_deliveryDate)),
                      trailing: IconButton(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Delivery Time (Optional)'),
                      subtitle: Text(
                        _deliveryTime == null
                            ? 'Not selected'
                            : _deliveryTime!.format(context),
                      ),
                      trailing: IconButton(
                        onPressed: _pickTime,
                        icon: const Icon(Icons.access_time),
                      ),
                    ),
                    TextFormField(
                      controller: _customerController,
                      decoration: const InputDecoration(labelText: 'Customer Name'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notesController,
                      maxLength: 300,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(labelText: 'Custom Notes'),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Price Estimate',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            NumberFormat.currency(
                              locale: 'en_IN',
                              symbol: '₹ ',
                              decimalDigits: 2,
                            ).format(total),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : () => _submit(total),
                      child: const Text('Submit Order'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isSubmitting)
            const ColoredBox(
              color: Color(0x66000000),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
