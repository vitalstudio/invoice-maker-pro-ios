import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../../model/data_model.dart';

class ChartDataMethods{

  static List<FlSpot> getLineChartData(
      DateTime startDate,
      DateTime endDate,
      List<DataModel> filteredInvoices)
      {
    List<FlSpot> spots = [];
    Duration difference = endDate.difference(startDate);

    for (int i = 0; i <= difference.inDays; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      double totalAmount = 0;

      for (var invoice in filteredInvoices) {
        DateTime invoiceDate = DateTime.parse(invoice.creationDate.toString());
        if (invoiceDate.year == currentDate.year && invoiceDate
            .month == currentDate.month && invoiceDate.day == currentDate.day) {
          totalAmount += int.tryParse(invoice.finalNetTotal.toString()) ?? 0;
        }
      }

      spots.add(FlSpot(i.toDouble(), totalAmount));
    }

    return spots;
  }

  static List<String> generateDateLabels(
      DateTime startDate,
      DateTime endDate,
      String filterType)
      {

    debugPrint('$filterType = S: $startDate, L: $endDate');

    List<String> labels = [];
    Duration difference = endDate.difference(startDate);

    if (difference.isNegative) {
      return labels;
    }

    for (int i = 0; i <= difference.inDays; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      String formattedDate = DateFormat('dd/MM').format(currentDate);
      labels.add(formattedDate);
    }

    return labels;
  }

}