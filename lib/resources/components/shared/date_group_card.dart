import 'package:flutter/material.dart';
import 'package:healty_ways/model/order_model.dart';
import 'package:intl/intl.dart';

class DateGroupCard extends StatelessWidget {
  final DateTime date;
  final List<OrderModel> orders;
  final Function(String, OrderStatus) onStatusChange;

  const DateGroupCard({
    super.key,
    required this.date,
    required this.orders,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Card
        Container(
          width: 45,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Text(
                DateFormat('MMM').format(date),
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('dd').format(date),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Orders Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE').format(date),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              ...orders.map((order) => _buildOrderCard(context, order)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id.substring(0, 6)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Chip(
                  label: Text(
                    OrderModel.orderStatusToString(order.status),
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _getStatusColor(order.status),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${order.medicineIds.length} items',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Ordered: ${DateFormat('h:mm a').format(order.orderTime)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            if (order.address != null)
              Text(
                'Address: ${order.address}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            const SizedBox(height: 8),
            if (order.status != OrderStatus.completed &&
                order.status != OrderStatus.cancelled)
              ElevatedButton(
                onPressed: () {
                  final newStatus = order.status == OrderStatus.processing
                      ? OrderStatus.inProgress
                      : OrderStatus.completed;
                  onStatusChange(order.id, newStatus);
                },
                child: Text(
                  order.status == OrderStatus.processing
                      ? 'Mark as In Progress'
                      : 'Mark as Completed',
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return Colors.orange;
      case OrderStatus.inProgress:
        return Colors.blue;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}
