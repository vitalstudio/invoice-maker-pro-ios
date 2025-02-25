import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/utils/utils.dart';
import '../../model/data_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfGreenShadeTemplate {

  static Future<Uint8List> loadImageFromAssets(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  static Future<Uint8List> createPreviewPdf(
      DataModel dataModel,
      ) async {
    final pdf = pw.Document();

    final boldFont = await PdfGoogleFonts.robotoBold();
    final extraBFont = await PdfGoogleFonts.robotoBlack();
    final normalFont = await PdfGoogleFonts.robotoLight();

    final fallBackFont = await PdfGoogleFonts.notoSansThaiRegular();

    log('Translated "from": ${'from'.tr}');

    final Uint8List backgroundImage = await loadImageFromAssets('assets/images/green_shade.jpg');

    pdf.addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            buildBackground: (_){
              return pw.Container(
                decoration: pw.BoxDecoration(
                  image: pw.DecorationImage(
                      image: pw.MemoryImage(
                          backgroundImage
                      )
                  )
                )
              );
            },
            margin: pw.EdgeInsets.zero,
            orientation: pw.PageOrientation.portrait,
          ),
      build: (context) => [
        pw.SizedBox(height: 1 * PdfPageFormat.cm),
        buildHeader(
            dataModel.titleName.toString(),
            extraBFont,
            boldFont,
            normalFont,
            dataModel.uniqueNumber.toString(),
            dataModel.creationDate.toString(),
            dataModel.dueDate.toString(),
            dataModel.purchaseOrderNo.toString()),
        pw.SizedBox(height: 0.5 * PdfPageFormat.cm),

        pw.Container(
          margin: const pw.EdgeInsets.symmetric(horizontal:1 * PdfPageFormat.cm,),
          child:  pw.Divider(color: PdfColors.grey, height: 0, thickness: 1.5),
        ),


        pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
        buildInvoicePersonsInfo(
            boldFont,
            normalFont,
            dataModel.businessName.toString(),
            dataModel.businessEmail.toString(),
            dataModel.businessBillingAddress.toString(),
            dataModel.businessPhoneNumber.toString(),
            dataModel.businessWebsite.toString(),
            dataModel.clientName.toString(),
            dataModel.clientEmail.toString(),
            dataModel.clientPhoneNumber.toString(),
            dataModel.clientBillingAddress.toString(),
            dataModel.clientShippingAddress.toString()),
        buildItemDetail(
            dataModel.itemNames ?? [],
            dataModel.itemsDiscountList ?? [],
            dataModel.itemsTaxesList ?? [],
            dataModel.itemsPriceList ?? [],
            dataModel.itemsAmountList ?? [],
            dataModel.itemsQuantityList ?? [],
            boldFont),
        pw.Container(
          margin: const pw.EdgeInsets.symmetric(horizontal:1 * PdfPageFormat.cm,),
          child:  pw.Divider(color: PdfColors.grey, height: 0, thickness: 1.5),
        ),
        buildTotal(
            boldFont,
            normalFont,
            fallBackFont,
            dataModel.paymentMethod.toString(),
            dataModel.currencyName.toString(),
            dataModel.finalNetTotal.toString(),
            dataModel.subTotal.toString(),
            dataModel.discountPercentage.toString(),
            dataModel.discountInTotal.toString(),
            dataModel.taxPercentage.toString(),
            dataModel.taxInTotal.toString(),
            dataModel.shippingCost.toString(),
            dataModel.partiallyPaidAmount.toString()
        ),
        pw.Expanded(
          child: buildTermAndConditions(
              dataModel.termAndCondition.toString(),
              boldFont,
              normalFont,
              dataModel.signatureImg ?? Uint8List(0)),
        ),
        pw.SizedBox(height: 1 * PdfPageFormat.cm),
        // pw.Container(
        //   alignment: Alignment.centerRight,
        //   margin: const EdgeInsets.symmetric(horizontal: 20),
        //   child: pw.Text('INVOICE MAKER AND BILLING APP',
        //     style: pw.TextStyle(
        //       font: boldFont,
        //       fontSize: 15,
        //       fontWeight: pw.FontWeight.normal,
        //     ),
        //   ),
        // ),
        // pw.SizedBox(height: 1 * PdfPageFormat.cm),
      ],
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
    ));
    return pdf.save();
  }

  static Widget buildHeader(
      String invoiceTitle,
      Font extraBFont,
      Font boldFont,
      Font normalFont,
      String invoiceNumber,
      String creationDate,
      String dueDate,
      String poNumber) {
    String titleCheck;

    if (invoiceTitle.isEmpty) {
      titleCheck =  AppSingletons.isInvoiceDocument.value ? 'INVOICE' : 'ESTIMATE';
    } else {
      titleCheck = invoiceTitle;
    }

    return pw.Container(
        alignment: pw.Alignment.center,
        child: pw.Row(
            mainAxisSize: pw.MainAxisSize.min,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(width: 1 * PdfPageFormat.cm),
              pw.Expanded(
                child: pw.Text(titleCheck,
                    style: pw.TextStyle(
                        fontSize: 30,
                        fontWeight: pw.FontWeight.bold,
                        font: extraBFont,
                        color: PdfColors.green)),
              ),
              pw.SizedBox(width: 2 * PdfPageFormat.cm),
              pw.Expanded(
                  child: pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            mainAxisSize: pw.MainAxisSize.min,
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Text('INVOICE #',
                                  style: pw.TextStyle(
                                    color: PdfColors.black,
                                    font: boldFont,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 16,
                                  )),
                              pw.Text('CREATION DATE',
                                  style: pw.TextStyle(
                                    color: PdfColors.black,
                                    font: boldFont,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 16,
                                  )),
                              pw.Text('DUE DATE',
                                  style: pw.TextStyle(
                                    color: PdfColors.black,
                                    font: boldFont,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 16,
                                  )),
                              if (poNumber.isNotEmpty)
                                pw.Text('P.O.#',
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      font: boldFont,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 16,
                                    )),
                            ]),
                        pw.SizedBox(width: 20),
                        pw.Expanded(
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              mainAxisSize: pw.MainAxisSize.min,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Text(invoiceNumber,
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontNormal: normalFont,
                                      fontWeight: pw.FontWeight.normal,
                                      fontSize: 16,
                                    )),
                                pw.Text(
                                    DateFormat('dd-MMM-yyyy')
                                        .format(DateTime.parse(creationDate)),
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontNormal: normalFont,
                                      fontWeight: pw.FontWeight.normal,
                                      fontSize: 16,
                                    )),
                                pw.Text(
                                    DateFormat('dd-MMM-yyyy')
                                        .format(DateTime.parse(dueDate)),
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontNormal: normalFont,
                                      fontWeight: pw.FontWeight.normal,
                                      fontSize: 16,
                                    )),
                                if (poNumber.isNotEmpty)
                                  pw.Text(poNumber,
                                      style: pw.TextStyle(
                                        color: PdfColors.black,
                                        fontNormal: normalFont,
                                        fontWeight: pw.FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                      softWrap: true),
                              ]),
                        ),
                      ])),

              pw.SizedBox(width: 1 * PdfPageFormat.cm),
            ]));
  }

  static Widget buildInvoicePersonsInfo(
      Font boldFont,
      Font normalFont,
      String fName,
      String fEmail,
      String fBillingAddress,
      String fPhoneNumber,
      String fWebsiteUrl,
      String cName,
      String cEmail,
      String cPhoneNo,
      String cBillingAddress,
      String cShippingAddress,
      ) {
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.SizedBox(width: 1 * PdfPageFormat.cm),
          pw.Expanded(
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Text('from'.tr,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 16,
                          font: boldFont)),
                  pw.Text(fName,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 15,
                          font: normalFont)),
                  pw.Text(fBillingAddress,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 15,
                          font: normalFont)),
                  pw.Text(fPhoneNumber,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 15,
                          font: normalFont)),
                  pw.Text(fEmail,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 15,
                          font: normalFont)),
                  pw.Text(fWebsiteUrl,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 15,
                          font: normalFont)),
                ]),
          ),
          pw.SizedBox(width: 2 * PdfPageFormat.cm),
          pw.Expanded(
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Text('bill to'.tr,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 16,
                        font: boldFont,
                      )),
                  pw.Text(cName,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 15,
                          font: normalFont)),
                  pw.Text(cBillingAddress,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 15,
                          font: normalFont)),
                  pw.Text(cShippingAddress,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 15,
                          font: normalFont)),
                  pw.Text(cPhoneNo,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 15,
                          font: normalFont)),
                  pw.Text(cEmail,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 15,
                          font: normalFont)),
                ]),
          ),
          pw.SizedBox(width: 1 * PdfPageFormat.cm),
        ]);
  }

  static Widget buildItemDetail(
      List<String> itemsNameList,
      List<String> itemsDiscountList,
      List<String> itemsTaxesList,
      List<String> itemsPriceList,
      List<String> itemsAmountList,
      List<String> itemsQuantityList,
      Font boldFont,
      ) {
    final headers = [
      'Name',
      'QTY',
      'PRICE',
      'DISCOUNT',
      'TAX',
      'AMOUNT'
    ];

    final data = List.generate(itemsNameList.length, (index) {
      return [
        Utils.showLimitedText(itemsNameList[index], 25),
        Utils.showLimitedText(itemsQuantityList[index].toString(), 9),
        Utils.showLimitedText(itemsPriceList[index].toString(), 11),
        '${itemsDiscountList[index]}%',
        '${itemsTaxesList[index]}%',
        Utils.showLimitedText(itemsAmountList[index].toString(), 11),
      ];
    });

    return pw.Container(
        margin: const pw.EdgeInsets.only(top: 0.5 * PdfPageFormat.cm,left: 1* PdfPageFormat.cm,right: 1 * PdfPageFormat.cm),
        alignment: pw.Alignment.center,
        child: pw.TableHelper.fromTextArray(
          headers: headers,
          data: data,
          border: null,
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: boldFont,color: PdfColors.white),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.green),
          cellHeight: 30,
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.center,
            2: pw.Alignment.center,
            3: pw.Alignment.center,
            4: pw.Alignment.center,
            5: pw.Alignment.center,
          },
        ));
  }

  static Widget buildTotal(
      Font boldFont,
      Font normalFont,
      Font fallback,
      String paymentMethod,
      String currencySymbol,
      String netTotal,
      String subTotal,
      String discountPercentage,
      String discountAmount,
      String taxPercentage,
      String taxAmount,
      String shippingCost,
      String partiallyPaid,
      ) {
    return pw.Container(
        margin: const pw.EdgeInsets.only(top: 0.5 * PdfPageFormat.cm),
        child: pw.Row(
            mainAxisSize: pw.MainAxisSize.min,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(width: 1 * PdfPageFormat.cm),
              pw.Expanded(
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.Text(
                        'PAYMENT METHOD',
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        paymentMethod,
                        style: pw.TextStyle(
                          font: normalFont,
                          fontSize: 15,
                          fontWeight: pw.FontWeight.normal,
                        ),
                      ),
                    ]),
              ),
              pw.SizedBox(width: 2 * PdfPageFormat.cm),
              pw.Expanded(
                  child: pw.Column(children: [
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'SubTotal',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            '$currencySymbol $subTotal',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontFallback: [fallback],
                              fontSize: 15,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ]),
                    pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Discount ($discountPercentage)%',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            '- $currencySymbol $discountAmount',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontFallback: [fallback],
                              fontSize: 15,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ]),
                    pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Tax ($taxPercentage)%',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            '+ $currencySymbol $taxAmount',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontFallback: [fallback],
                              fontSize: 15,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ]),
                    pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Shipping',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            '$currencySymbol $shippingCost',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontFallback: [fallback],
                              fontSize: 15,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ]),
                    pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
                    pw.Container(
                        padding: const pw.EdgeInsets.all(5),
                      color: PdfColors.green,
                     child: pw.Row(
                         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                         children: [
                           pw.Text(
                             'TOTAL',
                             style: pw.TextStyle(
                               font: boldFont,
                               fontSize: 16,
                               fontWeight: pw.FontWeight.bold,
                               color: PdfColors.white
                             ),
                           ),
                           pw.Text(
                             '$currencySymbol $netTotal',
                             style: pw.TextStyle(
                               font: boldFont,
                               fontFallback: [fallback],
                               fontSize: 15,
                               fontWeight: pw.FontWeight.bold,
                               color: PdfColors.white
                             ),
                           ),
                         ])
                    ),

                    if(partiallyPaid.isNotEmpty)
                      pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
                    if(partiallyPaid.isNotEmpty)
                      pw.Container(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(
                            '*Partially $currencySymbol $partiallyPaid Paid',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontFallback: [fallback],
                              fontSize: 15,
                              fontWeight: pw.FontWeight.normal,
                            )
                        ),
                      )

                  ])),
              pw.SizedBox(width: 1 * PdfPageFormat.cm),
            ]));
  }

  static Widget buildTermAndConditions(String termAndCondition, Font boldFont,
      Font normalFont, Uint8List signImg) {
    return pw.Container(
        margin: const pw.EdgeInsets.only(top: 1 * PdfPageFormat.cm),
        child: pw.Row(
            mainAxisSize: pw.MainAxisSize.min,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(width: 30),
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Text(
                          'TERMS & CONDITION',
                          style: pw.TextStyle(
                            font: boldFont,
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          termAndCondition,
                          style: pw.TextStyle(
                            font: normalFont,
                            fontSize: 15,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                      ])),
              pw.SizedBox(width: 2 * PdfPageFormat.cm),
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Text(
                          'Signature',
                          style: pw.TextStyle(
                            font: boldFont,
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        signImg.isEmpty
                            ? pw.SizedBox()
                            : pw.Container(
                            color: PdfColors.white,
                            width: 80,
                            height: 60,
                            alignment: pw.Alignment.bottomRight,
                            child: pw.Image(MemoryImage(signImg),
                                width: 50,
                                height: 50,
                                alignment: pw.Alignment.center,
                                fit: pw.BoxFit.fill)),
                      ]
                  )
              ),
              pw.SizedBox(width: 30),
            ]));
  }
}
