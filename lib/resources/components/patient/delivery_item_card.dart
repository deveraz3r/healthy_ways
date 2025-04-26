import 'package:healty_ways/utils/app_urls.dart';

class DeliveryItemCard extends StatelessWidget {
  final String orderId;
  final String status;
  final DateTime requestedDate;
  final List<String> updateMessages;
  final Function()? onTap;

  const DeliveryItemCard({
    super.key,
    required this.orderId,
    required this.status,
    required this.requestedDate,
    this.updateMessages = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get the latest update message
    final latestUpdate = updateMessages.isNotEmpty
        ? updateMessages.last
        : 'No updates available';

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order #$orderId",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: status.toLowerCase() == 'completed'
                        ? Colors.green
                        : status.toLowerCase() == 'returned'
                            ? Colors.red
                            : Colors.orange,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Requested: ${DateFormat('MMM dd, yyyy').format(requestedDate)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Latest Update: $latestUpdate',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
