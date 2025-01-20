import 'dart:io';
import '../../model/company_model.dart';
import '../../model/data_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' as io;
import '../model/client_model.dart';
import '../model/item_model.dart';
import '../model/payment_model.dart';
import '../model/signature_model.dart';
import '../model/termAndCondition_model.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initialDatabase();
    return _db;
  }

  // initialDatabase() async {
  //
  //
  //
  //   io.Directory docDirectory = await getApplicationDocumentsDirectory();
  //   String path = join(docDirectory.path, 'invoice.db');
  //   var db = await openDatabase(path, version: 1, onCreate: _onCreate);
  //   return db;
  // }

  initialDatabase() async {

    if(Platform.isMacOS){
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    io.Directory docDirectory = await getApplicationCacheDirectory();

    String path = join(docDirectory.path,'invoice.db');
    var db = await openDatabase(path,version: 1,onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
   await db.execute('''
    CREATE TABLE client(  
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     clientName TEXT NOT NULL, 
     clientEmailAddress TEXT NOT NULL, 
     clientPhoneNo TEXT,
     firstBillingAddress TEXT,
     firstShippingAddress TEXT,
     clientDetail TEXT
     )
    ''');

   await db.execute('''
   CREATE TABLE businessInfo(
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     businessName TEXT NOT NULL,
     businessEmail TEXT,
     businessPhoneNo TEXT,
     businessBillingOne TEXT,
     businessWebsite TEXT,
     businessLogoImg BLOB
     )
    ''');

   await db.execute('''
   CREATE TABLE itemTable(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    itemName TEXT,
    itemPrice TEXT,
    unitToMeasure TEXT,
    itemDetail TEXT
    )
   ''');

   await db.execute('''
    CREATE TABLE signature(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pngBytes BLOB
    )
    ''');

   await db.execute('''
   CREATE TABLE termAndCondition(
   id INTEGER PRIMARY KEY AUTOINCREMENT, 
   tcDetail TEXT
   )
   ''');

   await db.execute('''
    CREATE TABLE payment(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    paymentMethod TEXT
    )
    ''');

   await db.execute('''
    CREATE TABLE invoiceTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      uniqueNumber TEXT,
      creationDate TEXT,
      dueDate TEXT,
      purchaseOrderNo TEXT,
      titleName TEXT,
      languageName TEXT,
      clientName TEXT,
      clientEmail TEXT,
      clientPhoneNumber TEXT,
      clientBillingAddress TEXT,
      clientShippingAddress TEXT,
      clientDetail TEXT,
      businessLogoImg BLOB,
      businessName TEXT,
      businessEmail TEXT,
      businessPhoneNumber TEXT,
      businessBillingAddress TEXT,
      businessWebsite TEXT,
      itemNames TEXT,
      itemsQuantityList TEXT,
      itemsPriceList TEXT,
      itemsDiscountList TEXT,
      itemsTaxesList TEXT,
      itemsAmountList TEXT,
      itemsUnitList TEXT,
      itemsDescriptionList TEXT,
      currencyName TEXT,
      signatureImg BLOB,
      termAndCondition TEXT,
      paymentMethod TEXT,
      selectedTemplateId TEXT,
      discountInTotal TEXT,
      discountPercentage TEXT,
      taxInTotal TEXT,
      taxPercentage TEXT,
      shippingCost TEXT,
      subTotal TEXT,
      finalNetTotal TEXT,
      documentStatus TEXT,
      partiallyPaidAmount TEXT,
      unlockTempIds TEXT
    )
  ''');

   await db.execute('''
    CREATE TABLE estimateTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      uniqueNumber TEXT,
      creationDate TEXT,
      dueDate TEXT,
      purchaseOrderNo TEXT,
      titleName TEXT,
      languageName TEXT,
      clientName TEXT,
      clientEmail TEXT,
      clientPhoneNumber TEXT,
      clientBillingAddress TEXT,
      clientShippingAddress TEXT,
      clientDetail TEXT,
      businessLogoImg BLOB,
      businessName TEXT,
      businessEmail TEXT,
      businessPhoneNumber TEXT,
      businessBillingAddress TEXT,
      businessWebsite TEXT,
      itemNames TEXT,
      itemsQuantityList TEXT,
      itemsPriceList TEXT,
      itemsDiscountList TEXT,
      itemsTaxesList TEXT,
      itemsAmountList TEXT,
      itemsUnitList TEXT,
      itemsDescriptionList TEXT,
      currencyName TEXT,
      signatureImg BLOB,
      termAndCondition TEXT,
      paymentMethod TEXT,
      selectedTemplateId TEXT,
      discountInTotal TEXT,
      discountPercentage TEXT,
      taxInTotal TEXT,
      taxPercentage TEXT,
      shippingCost TEXT,
      subTotal TEXT,
      finalNetTotal TEXT,
      documentStatus TEXT,
      partiallyPaidAmount TEXT,
      unlockTempIds TEXT
    )
  ''');
  }

  // RELATED TO CLIENT TABLE IN DATABASE

  Future<ClientModel> insertClient(ClientModel clientModel) async {
    var dbClient = await db;
    await dbClient!.insert('client', clientModel.toMap());
    return clientModel;
  }
  Future<List<ClientModel>> getClientList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryClient = await dbClient!.query('client');
    return queryClient.map((e) => ClientModel.fromMap(e)).toList();
  }
  Future<int> deleteClient(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('client', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> deleteAllClient() async {
    var dbClient = await db;
    return await dbClient!.delete('client');
  }
  Future<int> updateClient(ClientModel clientModel) async {
    var dbClient = await db;
    return await dbClient!.update(
        'client',
        clientModel.toMap(),
        where: 'id = ?',
        whereArgs: [clientModel.id]);
  }
  Future<ClientModel?> getClientById(int clientId) async {
    var dbGetClient = await db;
    List<Map<String, dynamic>> result = await dbGetClient!.query('client', where: 'id = ?', whereArgs: [clientId]);
    //return result.isNotEmpty ? result.first : null;
    return result.isNotEmpty ? ClientModel.fromMap(result.first) : null;
  }

  Future<void> deleteCheckedClients(List<ClientModel> clientList) async {
    var dbClient = await db;
    List<int?> clientToDelete = [];
    for (var client in clientList) {
      if (client.isChecked.value) {
        clientToDelete.add(client.id);
      }
    }
    for (var id in clientToDelete) {
      await dbClient!.delete(
        'client',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    clientList.removeWhere((client) => client.isChecked.value);
  }

  // RELATED TO BUSINESS INFO OR COMPANY INFO TABLE IN DATABASE

  Future<BusinessInfoModel> insertBusinessInfo(BusinessInfoModel businessInfoModel) async {
    var dbBusinessInfo = await db;
    await dbBusinessInfo!.insert('businessInfo', businessInfoModel.toMap());
    return businessInfoModel;
  }
  Future<List<BusinessInfoModel>> getBusinessList() async {
    var dbBusinessInfo = await db;
    final List<Map<String, Object?>> queryBusinessInfo =
    await dbBusinessInfo!.query('businessInfo');
    return queryBusinessInfo.map((e) => BusinessInfoModel.fromMap(e)).toList();
  }
  Future<int> deleteBusinessInfo(int id) async {
    var dbCompany = await db;
    return await dbCompany!.delete('businessInfo', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> deleteAllBusinessInfo() async {
    var dbCompany = await db;
    return await dbCompany!.delete('businessInfo');
  }
  Future<int> updateBusinessInfo(BusinessInfoModel businessInfoModel) async {
    var dbBusinessInfo = await db;
    return await dbBusinessInfo!.update('businessInfo', businessInfoModel.toMap(),
        where: 'id = ?', whereArgs: [businessInfoModel.id]);
  }
  Future<BusinessInfoModel?> getBusinessInfoById(int businessInfoId) async {
    var dbGetBusinessInfo = await db;
    List<Map<String, dynamic>> result = await dbGetBusinessInfo!.query('businessInfo', where: 'id = ?', whereArgs: [businessInfoId]);
    return result.isNotEmpty ? BusinessInfoModel.fromMap(result.first) : null;
  }

  // RELATED TO ITEM TABLE IN DATABASE

  Future<ItemModel> insertItem(ItemModel itemModel) async {
    var dbItem = await db;
    await dbItem!.insert('itemTable', itemModel.toMap());
    return itemModel;
  }
  Future<List<ItemModel>> getItemList() async {
    var dbItem = await db;
    final List<Map<String, Object?>> queryItem =
    await dbItem!.query('itemTable');

    if (queryItem.isEmpty) {
      print('No items found in the database.');
    } else {
      print('Retrieved ${queryItem.length} items from the database.');
    }

    return queryItem.map((e) => ItemModel.fromMap(e)).toList();
  }
  Future<int> deleteItem(int id) async {
    var dbItem = await db;
    return await dbItem!.delete('itemTable', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> deleteAllItem() async {
    var dbItem = await db;
    return await dbItem!.delete('itemTable');
  }
  Future<int> updateItem(ItemModel itemModel) async {
    var dbItem = await db;
    return await dbItem!.update(
        'itemTable',
        itemModel.toMap(),
        where: 'id = ?',
        whereArgs: [itemModel.id]);
  }
  Future<ItemModel?> getItemById(int itemId) async {
    var dbGetItem = await db;
    List<Map<String, dynamic>> result = await dbGetItem!.query('itemTable', where: 'id = ?', whereArgs: [itemId]);
    return result.isNotEmpty ? ItemModel.fromMap(result.first) : null;
  }

  Future<void> deleteCheckedItems(List<ItemModel> itemList) async {
    var dbItem = await db;
    List<int?> itemsToDelete = [];
    for (var item in itemList) {
      if (item.isChecked.value) {
        itemsToDelete.add(item.id);
      }
    }
    for (var id in itemsToDelete) {
      await dbItem!.delete(
        'itemTable',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    itemList.removeWhere((item) => item.isChecked.value);
  }

  // RELATED TO Signature TABLE IN DATABASE

  Future<SignatureModel> insertSignature(SignatureModel signatureModel) async {
    var dbSignature = await db;
    await dbSignature!.insert('signature', signatureModel.toMap());
    return signatureModel;
  }
  Future<List<SignatureModel>> getSignatureList() async {
    var dbSignature = await db;
    final List<Map<String, Object?>> querySignature =
    await dbSignature!.query('signature');
    return querySignature.map((e) => SignatureModel.fromMap(e)).toList();
  }
  Future<int> deleteSignature(int id) async {
    var dbSignature = await db;
    return await dbSignature!
        .delete('signature', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> deleteAllSignature() async {
    var dbSignature = await db;
    return await dbSignature!.delete('signature');
  }
  Future<int> updateSignature(SignatureModel signatureModel) async {
    var dbSignature = await db;
    return await dbSignature!.update('signature', signatureModel.toMap(),
        where: 'id = ?', whereArgs: [signatureModel.id]);
  }
  Future<SignatureModel?> getSignatureById(int signatureId) async {
    var dbGetSignature = await db;
    List<Map<String, dynamic>> result = await dbGetSignature!.query('signature', where: 'id = ?', whereArgs: [signatureId]);
    return result.isNotEmpty ? SignatureModel.fromMap(result.first) : null;
  }

  // RELATED TO TERM AND CONDITION TABLE IN DATABASE

  Future<TermModel> insertTAC(TermModel termModel) async {
    var dbTerm = await db;
    await dbTerm!.insert('termAndCondition', termModel.toMap());
    return termModel;
  }
  Future<List<TermModel>> getTermList() async {
    var dbTerm = await db;
    final List<Map<String, Object?>> queryTerm =
    await dbTerm!.query('termAndCondition');
    return queryTerm.map((e) => TermModel.fromMap(e)).toList();
  }
  Future<int> deleteTAC(int id) async {
    var dbTerm = await db;
    return await dbTerm!
        .delete('termAndCondition', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> deleteAllTAC() async {
    var dbTerm = await db;
    return await dbTerm!.delete('termAndCondition');
  }
  Future<int> updateTAC(TermModel termModel) async {
    var dbTerm = await db;
    return await dbTerm!.update('termAndCondition', termModel.toMap(),
        where: 'id = ?', whereArgs: [termModel.id]);
  }
  Future<TermModel?> getTermById(int termId) async {
    var dbGetTerm = await db;
    List<Map<String, dynamic>> result = await dbGetTerm!.query('termAndCondition', where: 'id = ?', whereArgs: [termId]);
    return result.isNotEmpty ? TermModel.fromMap(result.first) : null;
  }

  // RELATED TO PAYMENT TABLE IN DATABASE

  Future<PaymentModel> insertPayment(PaymentModel paymentModel) async {
    var dbPayment = await db;
    await dbPayment!.insert('payment', paymentModel.toMap());
    return paymentModel;
  }
  Future<List<PaymentModel>> getPaymentList() async {
    var dbPayment = await db;
    final List<Map<String, Object?>> queryPayment =
    await dbPayment!.query('payment');
    return queryPayment.map((e) => PaymentModel.fromMap(e)).toList();
  }
  Future<int> deletePayment(int id) async {
    var dbPayment = await db;
    return await dbPayment!.delete('payment', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> deleteAllPayment() async {
    var dbPayment = await db;
    return await dbPayment!.delete('payment');
  }
  Future<int> updatePayment(PaymentModel paymentModel) async {
    var dbPayment = await db;
    return await dbPayment!.update('payment', paymentModel.toMap(),
        where: 'id = ?', whereArgs: [paymentModel.id]);
  }
  Future<PaymentModel?> getPaymentById(int paymentId) async {
    var dbGetPayment = await db;
    List<Map<String, dynamic>> result = await dbGetPayment!.query('payment', where: 'id = ?', whereArgs: [paymentId]);
    return result.isNotEmpty ? PaymentModel.fromMap(result.first) : null;
  }

  // RELATED TO INVOICE TABLE IN DATABASE

  Future<DataModel> insertInvoice(DataModel invoiceModel) async{
    var dbInvoice = await db;
    await dbInvoice!.insert('invoiceTable', invoiceModel.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    return invoiceModel;
  }
  Future<List<DataModel>> getInvoiceList() async {
    var dbInvoice = await db;
    final List<Map<String, Object?>> queryInvoice = await dbInvoice!.query('invoiceTable');
    return queryInvoice.map((e) => DataModel.fromMap(e)).toList();
  }
  Future<int> deleteInvoice(int id) async {
    var dbInvoice = await db;
    return await dbInvoice!.delete('invoiceTable',where: 'id = ?',whereArgs: [id]);
  }
  Future<int> deleteAllInvoice() async{
    var dbInvoice = await db;
    return await dbInvoice!.delete('invoiceTable');
  }
  Future<int> updateInvoice(DataModel invoiceDataModel) async {
    var dbInvoice = await db;
    return await dbInvoice!.update('invoiceTable', invoiceDataModel.toMap(),
        where: 'id = ?', whereArgs: [invoiceDataModel.id]
    );
  }
  Future<DataModel?> getSingleInvoiceById(int invoiceId) async {
    var dbGetInvoice = await db;

    List<Map<String, dynamic>> result = await dbGetInvoice!.query('invoiceTable', where: 'id = ?', whereArgs: [invoiceId]);

    return result.isNotEmpty ? DataModel.fromMap(result.first) : null;
  }

  // RELATED TO ESTIMATE TABLE IN DATABASE

  Future<DataModel> insertEstimate(DataModel estimateModel) async{
    var dbEstimate = await db;
    await dbEstimate!.insert('estimateTable', estimateModel.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    return estimateModel;
  }
  Future<List<DataModel>> getEstimateList() async {
    var dbEstimate = await db;
    final List<Map<String, Object?>> queryEstimate =
    await dbEstimate!.query('estimateTable');
    return queryEstimate.map((e) => DataModel.fromMap(e)).toList();
  }
  Future<int> deleteEstimate(int id) async {
    var dbEstimate = await db;
    return await dbEstimate!.delete('estimateTable',where: 'id = ?',whereArgs: [id]);
  }
  Future<int> deleteAllEstimate() async{
    var dbEstimate = await db;
    return await dbEstimate!.delete('estimateTable');
  }
  Future<int> updateEstimate(DataModel estimateDataModel) async {
    var dbEstimate = await db;
    return await dbEstimate!.update('estimateTable', estimateDataModel.toMap(),
        where: 'id = ?', whereArgs: [estimateDataModel.id]
    );
  }
  Future<DataModel?> getSingleEstimateById(int estimateId) async {
    var dbGetEstimate = await db;

    List<Map<String, dynamic>> result = await dbGetEstimate!.query('estimateTable', where: 'id = ?', whereArgs: [estimateId]);

    return result.isNotEmpty ? DataModel.fromMap(result.first) : null;
  }

}
