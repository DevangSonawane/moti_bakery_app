import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/models/cake.dart';

class CakeDetailScreen extends StatelessWidget {
  const CakeDetailScreen({super.key, required this.cake});

  final Cake cake;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cake Details')),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: ElevatedButton(
          onPressed: () => context.push('/place-order', extra: cake),
          child: const Text('Place Order'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: CachedNetworkImage(
                imageUrl: cake.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            cake.name,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(cake.description ?? 'No description available.'),
          const SizedBox(height: 16),
          Text('Flavours', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: cake.flavours.map((f) => Chip(label: Text(f))).toList(),
          ),
          const SizedBox(height: 16),
          Text('Weight: ${cake.minWeight}kg - ${cake.maxWeight}kg'),
          const SizedBox(height: 6),
          Text('Base rate: ₹${(cake.baseRate ?? 0).toStringAsFixed(0)}/kg'),
          const SizedBox(height: 6),
          const Text('Final price is calculated at order based on pricing rules.'),
        ],
      ),
    );
  }
}
