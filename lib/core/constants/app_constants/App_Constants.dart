import 'dart:io';
import 'package:get/get.dart';

class AppConstants {

  static String all = 'All';
  static String paidInvoice = 'Paid';
  static String unpaidInvoice = 'Unpaid';
  static String partiallyPaidInvoice = 'Partially Paid';
  static String overdue = 'Overdue';
  static String pending = 'Pending';
  static String cancel = 'Cancel';
  static String approved = 'Approved';

  static String salesTrending = 'Sales Trending';
  static String salesByClient = 'Sales by Client';
  static String salesByItem = 'Sales by Item';

  static String kMonthlyIdentifier = 'monthly_invoice_pro';
  static String kWeeklyIdentifier = 'weekly_invoice_pro';
  static String kYearlyIdentifier = 'yearly_invoice_pro';
  static String kLifeTimeIdentifier = 'lifetime_invoice_pro';

  static RxBool isMobileScreen = false.obs;

  static RxBool isMobileViewTemp = false.obs;

  static void setPlatformType() {
    if(Platform.isIOS || Platform.isAndroid){
      isMobileScreen.value = true;
    } else if(Platform.isMacOS || Platform.isWindows){
      isMobileScreen.value = false;
    }
  }

  static void updateScreenWidthForTemplate(double width) {
    if(width < 900){
      isMobileViewTemp.value = true;
    } else {
      isMobileViewTemp.value = false;
    }
  }

  static String last7Days = 'last7days';
  static String last30days = 'last30days';
  static String thisMonth = 'thismonth';
  static String thisQuarter = 'thisquarter';
  static String thisYear = 'thisyear';
  static String lastMonth = 'lastmonth';
  static String lastQuarter = 'lastquarter';
  static String lastYear = 'lastyear';
  static String custom = 'custom';



  //InApp USer Status User Key.

static const String userStatusKey = "userStatusKey";

}