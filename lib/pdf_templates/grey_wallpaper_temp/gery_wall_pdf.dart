import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/utils/utils.dart';
import '../../model/data_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfGreyWallpaperTemplate {
  static Future<Uint8List> createPreviewPdf(
      DataModel dataModel,
      ) async {
    final pdf = pw.Document();

    final boldFont = await PdfGoogleFonts.robotoBold();
    final extraBFont = await PdfGoogleFonts.robotoBlack();
    final normalFont = await PdfGoogleFonts.robotoLight();
    final italicFont = await PdfGoogleFonts.robotoItalic();

    final fallBackFont = await PdfGoogleFonts.notoSansThaiRegular();

    final Uint8List imageData =
    await loadImageFromAssets('assets/images/grey_wallpaper.jpg');

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          buildHeader(
              imageData,
              boldFont,
              normalFont,
              dataModel.businessLogoImg ?? Uint8List(0),
              dataModel.businessName.toString(),
              dataModel.businessEmail.toString(),
              dataModel.businessBillingAddress.toString(),
              dataModel.businessPhoneNumber.toString(),
              dataModel.businessWebsite.toString(),
              dataModel.titleName.toString(),
              extraBFont),
          pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
          belowHeaderInfo(
              boldFont,
              normalFont,
              dataModel.clientName.toString(),
              dataModel.clientEmail.toString(),
              dataModel.clientPhoneNumber.toString(),
              dataModel.clientBillingAddress.toString(),
              dataModel.clientShippingAddress.toString(),
              dataModel.uniqueNumber.toString(),
              dataModel.creationDate.toString(),
              dataModel.dueDate.toString(),
              dataModel.purchaseOrderNo.toString()),
          buildItemDetail(
              dataModel.itemNames ?? [],
              dataModel.itemsDiscountList ?? [],
              dataModel.itemsTaxesList ?? [],
              dataModel.itemsPriceList ?? [],
              dataModel.itemsAmountList ?? [],
              dataModel.itemsQuantityList ?? [],
              boldFont,
              dataModel.currencyName.toString()),
          buildTotal(
              boldFont,
              normalFont,
              fallBackFont,
              dataModel.paymentMethod.toString(),
              dataModel.finalNetTotal.toString(),
              dataModel.currencyName.toString(),
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
        footer: (format) => pw.Container(
            margin: const pw.EdgeInsets.only(top: 0.5 * PdfPageFormat.cm),
            height: 10,
            color: PdfColors.blueGrey),
        margin: const pw.EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        orientation: pw.PageOrientation.portrait,
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
      ),
    );
    return pdf.save();
  }

  static Future<Uint8List> loadImageFromAssets(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  static Widget buildHeader(
      Uint8List backImg,
      Font boldFont,
      Font normalFont,
      Uint8List businessLogoImg,
      String fName,
      String fEmail,
      String fBillingAddress,
      String fPhoneNumber,
      String fWebsiteUrl,
      String invoiceTitle,
      Font extraBFont) {
    String titleCheck;

    if (invoiceTitle.isEmpty) {
      titleCheck =  AppSingletons.isInvoiceDocument.value ? 'INVOICE' : 'ESTIMATE';
    } else {
      titleCheck = invoiceTitle;
    }

    return pw.Container(
      height: 170,
      width: double.infinity,
      decoration: pw.BoxDecoration(
        image: pw.DecorationImage(
          image: pw.MemoryImage(backImg),
          fit: pw.BoxFit.fill,
        ),
      ),
      child: pw.Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                if(businessLogoImg.isNotEmpty)
                  pw.Expanded(
                      flex: 1,
                      child: businessLogoImg.isEmpty
                          ? pw.SizedBox.shrink()
                          : pw.Container(
                          width: 80,
                          height: 80,
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Image(MemoryImage(businessLogoImg),
                              width: 75,
                              height: 75,
                              alignment: pw.Alignment.center,
                              fit: pw.BoxFit.fill))),
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Text('From',
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              font: boldFont,
                              fontWeight: pw.FontWeight.bold,
                            )),
                        pw.Text(fName,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 15,
                              font: normalFont,
                              color: PdfColors.white,
                            ),
                            maxLines: 2),
                        pw.Text(fBillingAddress,
                            maxLines: 3,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 15,
                                font: normalFont,
                                color: PdfColors.white)),
                        pw.Text(fPhoneNumber,
                            maxLines: 1,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 15,
                                font: normalFont,
                                color: PdfColors.white)),
                        pw.Text(fEmail,
                            maxLines: 1,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 15,
                                font: normalFont,
                                color: PdfColors.white)),
                        pw.Text(fWebsiteUrl,
                            maxLines: 2,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.normal,
                                fontSize: 15,
                                font: normalFont,
                                color: PdfColors.white)),
                      ]),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(titleCheck,
                      textAlign: pw.TextAlign.end,
                      style: pw.TextStyle(
                          fontSize: 30,
                          fontWeight: pw.FontWeight.bold,
                          font: extraBFont,
                          color: PdfColors.white)),
                ),
              ])),
    );
  }

  static Widget belowHeaderInfo(
      Font boldFont,
      Font normalFont,
      String cName,
      String cEmail,
      String cPhoneNo,
      String cBillingAddress,
      String cShippingAddress,
      String invoiceNumber,
      String creationDate,
      String dueDate,
      String poNumber) {
    return pw.Container(
        margin: const pw.EdgeInsets.symmetric(horizontal: 30),
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Expanded(
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.Text('BILL TO',
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
                                      )),
                              ]),
                        ),
                      ])),
            ]));
  }

  static Widget buildItemDetail(
      // List<ItemModel> itemsList,
      List<String> itemsNameList,
      List<String> itemsDiscountList,
      List<String> itemsTaxesList,
      List<String> itemsPriceList,
      List<String> itemsAmountList,
      List<String> itemsQuantityList,
      Font boldFont,
      String currencySign,
      ) {
    final headers = [
      'DESCRIPTION',
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
        margin: const pw.EdgeInsets.only(
            left: 30, right: 30, top: 0.5 * PdfPageFormat.cm),
        alignment: pw.Alignment.center,
        child: pw.TableHelper.fromTextArray(
          headers: headers,
          data: data,
          border: null,
          headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              font: boldFont,
              color: PdfColors.white),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey),
          oddRowDecoration:
          const pw.BoxDecoration(color: PdfColor.fromInt(0xFFE0EEFD)),
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
      String netTotal,
      String currencySymbol,
      String subTotal,
      String discountPercentage,
      String discountAmount,
      String taxPercentage,
      String taxAmount,
      String shippingCost,
      String partiallyPaid
      ) {
    return pw.Container(
        margin: const pw.EdgeInsets.only(
            left: 30, right: 30, top: 0.5 * PdfPageFormat.cm),
        child: pw.Row(
            mainAxisSize: pw.MainAxisSize.min,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
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
                        color: PdfColors.blueGrey,
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'TOTAL',
                                style: pw.TextStyle(
                                    font: boldFont,
                                    fontSize: 16,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.white),
                              ),
                              pw.Text(
                                '$currencySymbol $netTotal',
                                style: pw.TextStyle(
                                    font: boldFont,
                                    fontFallback: [fallback],
                                    fontSize: 15,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.white),
                              ),
                            ])),

                    if(partiallyPaid.isNotEmpty)
                      pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
                    if(partiallyPaid.isNotEmpty)
                      pw.Container(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(
                            '*Partially $currencySymbol $partiallyPaid',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontFallback: [fallback],
                              fontSize: 15,
                              fontWeight: pw.FontWeight.normal,
                            )
                        ),
                      )

                  ])),
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
