import 'package:healty_ways/utils/app_urls.dart';

class OrdersSummaryChart extends StatelessWidget {
  const OrdersSummaryChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Orders Summary",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: true)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text("New");
                            case 1:
                              return const Text("In Progress");
                            case 2:
                              return const Text("Shipped");
                            case 3:
                              return const Text("Delivered");
                            default:
                              return const Text("");
                          }
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  barGroups: [
                    _buildBarGroup(0, 16, Colors.orange),
                    _buildBarGroup(1, 12, Colors.blue),
                    _buildBarGroup(2, 8, Colors.purple),
                    _buildBarGroup(3, 14, Colors.teal),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 20,
          borderRadius: BorderRadius.circular(5),
        ),
      ],
    );
  }
}
