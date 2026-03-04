import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../models/order.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      OrderStatus.newOrder => ('New', AppColors.neutralGrey, Colors.black87),
      OrderStatus.inProgress => ('In Progress', AppColors.infoBlue, Colors.white),
      OrderStatus.prepared => ('Prepared', AppColors.successGreen, Colors.white),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: fg)),
    );
  }
}
