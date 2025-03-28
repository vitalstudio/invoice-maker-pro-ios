
import 'package:get/get.dart';
import '../../modules/saved_pdf/saved_pdf_binding.dart';
import '../../modules/saved_pdf/saved_pdf_view.dart';
import '../../modules/share_chart_detail/share_chart_detail_binding.dart';
import '../../modules/share_chart_detail/share_chart_detail_view.dart';
import '../../modules/pro_screen/pro_screen_binding.dart';
import '../../modules/pro_screen/pro_screen_view.dart';
import '../../modules/charts_of_data/charts_binding.dart';
import '../../modules/charts_of_data/charts_view.dart';
import '../../modules/estimate/estimate_list_binding.dart';
import '../../modules/estimate/estimates_list_view.dart';
import '../../modules/estimate_entrance/estimate_entrance_binding.dart';
import '../../modules/estimate_entrance/estimate_entrance_view.dart';
import '../../modules/business_info_list/business_list_binding.dart';
import '../../modules/business_info_list/business_list_view.dart';
import '../../modules/payment_method/payment_method_binding.dart';
import '../../modules/payment_method/payment_method_view.dart';
import '../../modules/pdf_preview/pdf_preview_binding.dart';
import '../../modules/pdf_preview/pdf_preview_view.dart';
import '../../modules/templates/templates_binding.dart';
import '../../modules/templates/templates_view.dart';
import '../../modules/add_edit_item/add_item_binding.dart';
import '../../modules/add_edit_item/add_item_view.dart';
import '../../modules/add_new_signature/new_signature_binding.dart';
import '../../modules/add_new_signature/new_signature_view.dart';
import '../../modules/signature_for_invoice/signature_list_binding.dart';
import '../../modules/signature_for_invoice/signature_list_view.dart';
import '../../modules/term_and_condition/term_and_condition_binding.dart';
import '../../modules/term_and_condition/term_and_condition_view.dart';
import '../../modules/add_edit_client/add_client_binding.dart';
import '../../modules/add_edit_client/add_client_view.dart';
import '../../modules/business_info/business_info_binding.dart';
import '../../modules/business_info/business_info_view.dart';
import '../../modules/invoice_entrance_screen/invoice_entrance_binding.dart';
import '../../modules/invoice_entrance_screen/invoice_entrance_view.dart';
import '../../modules/setting_screen/setting_screen_binding.dart';
import '../../modules/setting_screen/setting_screen_view.dart';
import '../../modules/item_list_screen/item_screen_binding.dart';
import '../../modules/item_list_screen/item_screen_view.dart';
import '../../modules/bottom_nav_bar/bottom_nav_bar_binding.dart';
import '../../modules/bottom_nav_bar/bottom_nav_bar_view.dart';
import '../../modules/splash_screen/splash_binding.dart';
import '../../modules/splash_screen/splash_view.dart';
import '../../modules/client_list_screen/client_list_binding.dart';
import '../../modules/client_list_screen/client_list_view.dart';
import '../../modules/home_screen/home_binding.dart';
import '../../modules/home_screen/home_view.dart';

abstract class Routes {
  static const String splashView = '/splashView';
  static const String settingScreenView = '/settingScreenView';
  static const String bottomNavBar = "/bottomNavBar";
  static const String homeView = "/homeView";
  static const String estimateListView = "/estimateListView";
  static const String invoiceInputView = "/invoiceInputView";
  static const String estimateInputView = "/estimateInputView";
  static const String dateEntranceView = '/dateEntranceView';
  static const String businessInfo = '/businessInfo';
  static const String businessListView = '/businessListView';
  static const String fromInputView = "/fromInputView";
  // static const String billToView = "/billToView";
  static const String clientDataView = "/clientDataView";
  static const String itemsView = "/itemsView";
  static const String signatureView = "/signatureView";
  static const String addNewSignatureView = "/addNewSignatureView";
  static const String termsAndConditionView = "/termsAndConditionView";
  static const String paymentView = "/paymentView";
  static const String addClientView = "/addClientView";
  static const String addEditItemView = "/addEditItemView";
  static const String pdfPreviewPages = "/pdfPreviewPages";
  static const String pdfTemplateSelect = "/pdfTemplateSelect";
  static const String chartsView = "/chartsView";
  static const String proScreenView = "/proScreenView";
  static const String shareChartDetailView = "/shareChartDetailView";
  static const String savedPdfView = "/savedPdfView";

  static final List<GetPage> pages = [
    GetPage(name: splashView, page: ()=>  const SplashView(),binding: SplashBinding()),
    GetPage(name: bottomNavBar, page: ()=>  BottomNavView(),binding: BottomNavBinding()),
    GetPage(name: homeView, page: ()=>  const HomeView(),binding: HomeBinding()),
    GetPage(name: clientDataView, page: ()=> const ClientListView(),binding: ClientBinding()),
    GetPage(name: itemsView, page: ()=> const ItemScreenView(),binding: ItemScreenBinding()),
    GetPage(name: settingScreenView, page: ()=> const SettingScreenView(),binding: SettingScreenBinding()),
    GetPage(name: invoiceInputView, page: ()=>InvoiceEntranceView(), binding: InvoiceEntranceBinding()),
    GetPage(name: businessInfo, page: ()=>const BusinessInfoView(),binding: BusinessInfoBinding()),
    GetPage(name: businessListView, page: ()=>  const BusinessListView(),binding: BusinessListBinding()),
  //  GetPage(name: billToView, page: ()=>const BillToView(),binding: BillToBinding()),
    GetPage(name: addClientView, page: ()=>const AddClientView(),binding: AddClientBinding()),
    GetPage(name: addEditItemView, page: ()=> const AddItemView(), binding: AddItemBinding()),
    GetPage(name: signatureView, page: ()=>  const SignatureListView(),binding: SignatureListBinding()),
    GetPage(name: addNewSignatureView, page: ()=>  const NewSignatureView(),binding: NewSignatureBinding()),
    GetPage(name: termsAndConditionView, page: ()=>  const TermAndConditionView(),binding: TermAndConditionBinding()),
    GetPage(name: paymentView, page: ()=>  const PaymentMethodView(),binding: PaymentMethodBinding()),
    GetPage(name: pdfPreviewPages, page: ()=>  const PdfPreviewView(),binding: PdfPreviewBinding()),
    GetPage(name: pdfTemplateSelect, page: ()=>  const TemplatesView(),binding: TemplatesBinding()),
    GetPage(name: estimateListView, page: ()=>  const EstimateListView(),binding: EstimateListBinding()),
    GetPage(name: estimateInputView, page: ()=>  EstimateEntranceView(),binding: EstimateEntranceBinding()),
    GetPage(name: chartsView, page: ()=>  const ChartsView(),binding: ChartsBinding()),
    GetPage(name: proScreenView, page: ()=>  const ProScreenView(),binding: ProScreenBinding()),
    GetPage(name: savedPdfView, page: ()=>  SavedPdfView(),binding: SavedPdfBinding()),
    GetPage(name: shareChartDetailView, page: ()=>  const ShareChartDetailView(),binding: ShareChartDetailBinding()),
  ];
}
