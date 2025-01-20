import 'dart:typed_data';
import '../../model/item_summary.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../model/client_summary.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfChartDataWork {
  static Future<Uint8List> createPDFSalesTrending(
      List<String> fetchAllDates,
      List<String> fetchInvoiceCount,
      List<String> fetchFinalAmountTotalList,
      List<String> fetchOnlyPaidAmountList,
      String totalNumberOfInvoices,
      String totalOfSales,
      String totalOfPaid,
      String startDate,
      String endDate) async {
    final pdf = pw.Document();

    final boldFont = await PdfGoogleFonts.robotoBold();
    // final extraBFont = await PdfGoogleFonts.robotoBlack();
    // final normalFont = await PdfGoogleFonts.robotoLight();

    final fallBackFont = await PdfGoogleFonts.notoSansThaiRegular();

    pdf.addPage(pw.MultiPage(
      build: (context) => [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('Sales Trending',
              style: TextStyle(
                  fontBold: boldFont, color: PdfColors.black, fontSize: 17)),
          pw.Text('$startDate - $endDate',
              style: TextStyle(
                  fontBold: boldFont, color: PdfColors.grey, fontSize: 17)),
        ]),
        buildSalesTrendingData(
            fetchAllDates,
            fetchInvoiceCount,
            fetchFinalAmountTotalList,
            fetchOnlyPaidAmountList,
            totalNumberOfInvoices,
            totalOfSales,
            totalOfPaid,
            AppSingletons.storedInvoiceCurrency.value,
            boldFont,
            fallBackFont),
      ],
    ));
    return pdf.save();
  }

  static Future<Uint8List> createPDFSalesBClient(
      List<ClientSummary> clientData,
      String totalInvoices,
      String totalSales,
      String totalPercentage,
      String startDate,
      String endDate) async {
    final pdf = pw.Document();

    final boldFont = await PdfGoogleFonts.robotoBold();
    // final extraBFont = await PdfGoogleFonts.robotoBlack();
    // final normalFont = await PdfGoogleFonts.robotoLight();
    final fallBackFont = await PdfGoogleFonts.notoSansThaiRegular();

    pdf.addPage(pw.MultiPage(
      build: (context) => [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('Sales By Client',
              style: TextStyle(
                  fontBold: boldFont, color: PdfColors.black, fontSize: 17)),
          pw.Text('$startDate - $endDate',
              style: TextStyle(
                  fontBold: boldFont, color: PdfColors.grey, fontSize: 17)),
        ]),
        buildSalesByClient(clientData, totalInvoices, totalSales,
            totalPercentage, boldFont, fallBackFont)
      ],
    ));
    return pdf.save();
  }

  static Future<Uint8List> createPDFSalesByItems(
      List<ItemSummary> itemData,
      String totalQuantity,
      String totalSales,
      String totalPercentage,
      String startDate,
      String endDate) async {
    final pdf = pw.Document();

    final boldFont = await PdfGoogleFonts.robotoBold();
    // final extraBFont = await PdfGoogleFonts.robotoBlack();
    // final normalFont = await PdfGoogleFonts.robotoLight();
    final fallBackFont = await PdfGoogleFonts.notoSansThaiRegular();

    pdf.addPage(pw.MultiPage(
      build: (context) => [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('Sales By Item',
              style: TextStyle(
                  fontBold: boldFont, color: PdfColors.black, fontSize: 17)),
          pw.Text('$startDate - $endDate',
              style: TextStyle(
                  fontBold: boldFont, color: PdfColors.grey, fontSize: 17)),
        ]),
        buildSalesByItems(itemData, totalQuantity, totalSales, totalPercentage,
            boldFont, fallBackFont)
      ],
    ));
    return pdf.save();
  }

  static Widget buildSalesTrendingData(
    List<String> fetchAllDates,
    List<String> fetchInvoiceCount,
    List<String> fetchFinalAmountTotalList,
    List<String> fetchOnlyPaidAmountList,
    String totalNumberOfInvoices,
    String totalOfSalesAmount,
    String totalOfPaidAmount,
    String storedCurrencySymbol,
    Font boldFont,
    Font fallback,
  ) {
    final headers = [
      'DATE',
      'INVOICES',
      'SALES',
      'PAID',
    ];
    final data = List.generate(fetchAllDates.length, (index) {
      return [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
          child: pw.Text(fetchAllDates[index],
              style: pw.TextStyle(
                fontFallback: [fallback],
                font: boldFont,
                fontWeight: pw.FontWeight.normal,
              )),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
          child: pw.Text(fetchInvoiceCount[index],
              style: pw.TextStyle(
                fontFallback: [fallback],
                font: boldFont,
                fontWeight: pw.FontWeight.normal,
              )),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
          child: pw.Text(
              '$storedCurrencySymbol${fetchFinalAmountTotalList[index]}',
              style: pw.TextStyle(
                fontFallback: [fallback],
                font: boldFont,
                fontWeight: pw.FontWeight.normal,
              )),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
          child:
              pw.Text('$storedCurrencySymbol${fetchOnlyPaidAmountList[index]}',
                  style: pw.TextStyle(
                    fontFallback: [fallback],
                    font: boldFont,
                    fontWeight: pw.FontWeight.normal,
                  )),
        )
      ];
    });

    data.add([
      pw.Container(
        width: double.infinity,
        alignment: pw.Alignment.center,
        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
        decoration: pw.BoxDecoration(
            border: Border.all(color: PdfColors.black, width: 1)),
        child: pw.Text('Total',
            style: pw.TextStyle(
              fontFallback: [fallback],
              font: boldFont,
              fontWeight: pw.FontWeight.normal,
            )),
      ),
      pw.Container(
        width: double.infinity,
        alignment: pw.Alignment.center,
        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
        decoration: pw.BoxDecoration(
            border: Border.all(color: PdfColors.black, width: 1)),
        child: pw.Text(totalNumberOfInvoices,
            style: pw.TextStyle(
              fontFallback: [fallback],
              font: boldFont,
              fontWeight: pw.FontWeight.normal,
            )
        ),
      ),
      pw.Container(
        width: double.infinity,
        alignment: pw.Alignment.center,
        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
        decoration: pw.BoxDecoration(
            border: Border.all(color: PdfColors.black, width: 1)),
        child: pw.Text(
            '$storedCurrencySymbol$totalOfSalesAmount',
            style: pw.TextStyle(
              fontFallback: [fallback],
              font: boldFont,
              fontWeight: pw.FontWeight.normal,
            )),
      ),
      pw.Container(
        width: double.infinity,
        alignment: pw.Alignment.center,
        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
        decoration: pw.BoxDecoration(
            border: Border.all(color: PdfColors.black, width: 1)),
        child: pw.Text(
            '$storedCurrencySymbol$totalOfPaidAmount',
            style: pw.TextStyle(
              fontFallback: [fallback],
              font: boldFont,
              fontWeight: pw.FontWeight.normal,
            )),
      )
    ]);

    return pw.Container(
        margin: const pw.EdgeInsets.only(top: 0.5 * PdfPageFormat.cm),
        alignment: pw.Alignment.center,
        child: pw.TableHelper.fromTextArray(
          data: data,
          headers: headers,
          border: null,
          headerStyle:
              pw.TextStyle(fontWeight: pw.FontWeight.bold, font: boldFont),
          headerDecoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          cellHeight: 30,
          cellPadding: pw.EdgeInsets.zero,
          cellDecoration: (index, data, rowNum) {
            return const pw.BoxDecoration(
              border: pw.Border(
                left: pw.BorderSide(color: PdfColors.black, width: 1),
                right: pw.BorderSide(color: PdfColors.black, width: 1),
              ),
            );
          },
          cellAlignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.center,
            2: pw.Alignment.center,
            3: pw.Alignment.center,
          },
        ));
  }

  static Widget buildSalesByClient(
      List<ClientSummary> clientData,
      String totalInvoices,
      String totalSales,
      String totalPercentage,
      Font boldFont,
      Font fallback) {
    final headers = [
      'NAME',
      'INVOICES',
      'PERCENTAGE',
      'SALES',
    ];

    final data = List.generate(clientData.length, (index) {
      return [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
          child: pw.Text(clientData[index].clientName,
              style: pw.TextStyle(
                fontFallback: [fallback],
                font: boldFont,
                fontWeight: pw.FontWeight.normal,
              )),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
          child: pw.Text(clientData[index].count.toString(),
              style: pw.TextStyle(
                fontFallback: [fallback],
                font: boldFont,
                fontWeight: pw.FontWeight.normal,
              )),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
          child: pw.Text('${clientData[index].percentage.toStringAsFixed(2)}%',
              style: pw.TextStyle(
                fontFallback: [fallback],
                font: boldFont,
                fontWeight: pw.FontWeight.normal,
              )),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
          child: pw.Text(
              '${AppSingletons.storedInvoiceCurrency.value}${clientData[index].totalAmount.toString()}',
              style: pw.TextStyle(
                fontFallback: [fallback],
                font: boldFont,
                fontWeight: pw.FontWeight.normal,
              )),
        ),
      ];
    });

    data.add([
      pw.Container(
        width: double.infinity,
        alignment: pw.Alignment.center,
        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
        decoration: pw.BoxDecoration(
            border: Border.all(color: PdfColors.black, width: 1)),
        child: pw.Text('Total',
            style: pw.TextStyle(
              fontFallback: [fallback],
              font: boldFont,
              fontWeight: pw.FontWeight.normal,
            )),
      ),
      pw.Container(
        width: double.infinity,
        alignment: pw.Alignment.center,
        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
        decoration: pw.BoxDecoration(
            border: Border.all(color: PdfColors.black, width: 1)),
        child: pw.Text(totalInvoices,
            style: pw.TextStyle(
              fontFallback: [fallback],
              font: boldFont,
              fontWeight: pw.FontWeight.normal,
            )),
      ),
      pw.Container(
        width: double.infinity,
        alignment: pw.Alignment.center,
        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
        decoration: pw.BoxDecoration(
            border: Border.all(color: PdfColors.black, width: 1)),
        child: pw.Text('$totalPercentage%',
            style: pw.TextStyle(
              fontFallback: [fallback],
              font: boldFont,
              fontWeight: pw.FontWeight.normal,
            )),
      ),
      pw.Container(
          width: double.infinity,
          alignment: pw.Alignment.center,
          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
          decoration: pw.BoxDecoration(
              border: Border.all(color: PdfColors.black, width: 1)),
          child:
              pw.Text('${AppSingletons.storedInvoiceCurrency.value}$totalSales',
                  style: pw.TextStyle(
                    fontFallback: [fallback],
                    font: boldFont,
                    fontWeight: pw.FontWeight.normal,
                  ))),
    ]);

    return pw.Container(
        margin: const pw.EdgeInsets.only(top: 0.5 * PdfPageFormat.cm),
        alignment: pw.Alignment.center,
        child: pw.TableHelper.fromTextArray(
          data: data,
          headers: headers,
          border: null,
          headerStyle:
              pw.TextStyle(fontWeight: pw.FontWeight.bold, font: boldFont),
          headerDecoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          cellHeight: 30,
          cellPadding: pw.EdgeInsets.zero,
          cellDecoration: (index, data, rowNum) {
            return const pw.BoxDecoration(
              border: pw.Border(
                left: pw.BorderSide(color: PdfColors.black, width: 1),
                right: pw.BorderSide(color: PdfColors.black, width: 1),
              ),
            );
          },
          cellAlignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.center,
            2: pw.Alignment.center,
            3: pw.Alignment.center,
          },
        ));
  }

  static Widget buildSalesByItems(
      List<ItemSummary> itemData,
      String totalQuantity,
      String totalSales,
      String totalPercentage,
      Font boldFont,
      Font fallback) {
    final headers = [
      'NAME',
      'QTY',
      'PERCENTAGE',
      'SALES',
    ];

    final data = List.generate(itemData.length, (index) {
      return [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
          child: pw.Text(itemData[index].itemName,
              style: pw.TextStyle(
                fontFallback: [fallback],
                font: boldFont,
                fontWeight: pw.FontWeight.normal,
              )),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
          child: pw.Text(itemData[index].quantity.toString(),
              style: pw.TextStyle(
                fontFallback: [fallback],
                font: boldFont,
                fontWeight: pw.FontWeight.normal,
              )),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
          child: pw.Text('${itemData[index].percentage.toStringAsFixed(2)}%',
              style: pw.TextStyle(
                fontFallback: [fallback],
                font: boldFont,
                fontWeight: pw.FontWeight.normal,
              )),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
          child: pw.Text(
              '${AppSingletons.storedInvoiceCurrency.value}${itemData[index].totalAmount.toString()}',
              style: pw.TextStyle(
                fontFallback: [fallback],
                font: boldFont,
                fontWeight: pw.FontWeight.normal,
              )),
        ),
      ];
    });

    data.add([
      pw.Container(
        width: double.infinity,
        alignment: pw.Alignment.center,
        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
        decoration: pw.BoxDecoration(
            border: Border.all(color: PdfColors.black, width: 1)),
        child: pw.Text('Total',
            style: pw.TextStyle(
              fontFallback: [fallback],
              font: boldFont,
              fontWeight: pw.FontWeight.normal,
            )),
      ),
      pw.Container(
        width: double.infinity,
        alignment: pw.Alignment.center,
        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
        decoration: pw.BoxDecoration(
            border: Border.all(color: PdfColors.black, width: 1)),
        child: pw.Text(totalQuantity,
            style: pw.TextStyle(
              fontFallback: [fallback],
              font: boldFont,
              fontWeight: pw.FontWeight.normal,
            )),
      ),
      pw.Container(
        width: double.infinity,
        alignment: pw.Alignment.center,
        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
        decoration: pw.BoxDecoration(
            border: Border.all(color: PdfColors.black, width: 1)),
        child: pw.Text('$totalPercentage%',
            style: pw.TextStyle(
              fontFallback: [fallback],
              font: boldFont,
              fontWeight: pw.FontWeight.normal,
            )),
      ),
      pw.Container(
          width: double.infinity,
          alignment: pw.Alignment.center,
          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
          decoration: pw.BoxDecoration(
              border: Border.all(color: PdfColors.black, width: 1)),
          child:
              pw.Text('${AppSingletons.storedInvoiceCurrency.value}$totalSales',
                  style: pw.TextStyle(
                    fontFallback: [fallback],
                    font: boldFont,
                    fontWeight: pw.FontWeight.normal,
                  ))),
    ]);

    return pw.Container(
        margin: const pw.EdgeInsets.only(top: 0.5 * PdfPageFormat.cm),
        alignment: pw.Alignment.center,
        child: pw.TableHelper.fromTextArray(
          data: data,
          headers: headers,
          border: null,
          headerStyle:
              pw.TextStyle(fontWeight: pw.FontWeight.bold, font: boldFont),
          headerDecoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          cellHeight: 30,
          cellPadding: pw.EdgeInsets.zero,
          cellDecoration: (index, data, rowNum) {
            return const pw.BoxDecoration(
              border: pw.Border(
                left: pw.BorderSide(color: PdfColors.black, width: 1),
                right: pw.BorderSide(color: PdfColors.black, width: 1),
              ),
            );
          },
          cellAlignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.center,
            2: pw.Alignment.center,
            3: pw.Alignment.center,
          },
        ));
  }
}
