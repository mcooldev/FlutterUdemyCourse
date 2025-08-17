import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:udemy_course/models/expense.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses});

  //
  final List<Expense> expenses;

  List<ExpenseBucket> get buckets => [
    ExpenseBucket.forCategory(expenses, Category.food),
    ExpenseBucket.forCategory(expenses, Category.travel),
    ExpenseBucket.forCategory(expenses, Category.leisure),
    ExpenseBucket.forCategory(expenses, Category.work),
  ];

  double get maxTotalExpense {
    double maxTotalExpense = 0.00;

    ///
    for (final bucket in buckets) {
      if (bucket.totalExpenses > maxTotalExpense) {
        maxTotalExpense = bucket.totalExpenses;
      }
    }
    return maxTotalExpense;
  }

  // Get titles widgets
  Widget _getTitlesWidget(double value, TitleMeta meta) {
    Widget icon;
    final index = value.toInt();

    //
    switch (index) {
      case 0:
        icon = Icon(
          categoryIcons[Category.food],
          color: Colors.deepPurpleAccent,
          size: 22,
        );
        break;
      case 1:
        icon = Icon(
          categoryIcons[Category.travel],
          color: Colors.deepPurpleAccent,
          size: 22,
        );
        break;
      case 2:
        icon = Icon(
          categoryIcons[Category.leisure],
          color: Colors.deepPurpleAccent,
          size: 22,
        );
        break;
      case 3:
        icon = Icon(
          categoryIcons[Category.work],
          color: Colors.deepPurpleAccent,
          size: 22,
        );
        break;
      default:
        icon = const SizedBox.shrink();
    }
    return SideTitleWidget(meta: meta, child: icon);
  }

  //
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      width: double.infinity,
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: maxTotalExpense,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _getTitlesWidget,
              ),
            ),
          ),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_){
                return Theme.of(context).colorScheme.primaryContainer;
              },
            )
          ),
          barGroups: buckets.asMap().entries.map((entry) {
            final index = entry.key;
            final bucket = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: bucket.totalExpenses,
                  color: Colors.deepPurpleAccent,
                  width: 24,
                  borderRadius: BorderRadius.circular(40),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxTotalExpense,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
