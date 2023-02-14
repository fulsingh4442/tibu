import 'dart:convert';

import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/models/add_on_model.dart';
import 'package:club_app/logic/models/cart_model.dart';
import 'package:club_app/logic/models/tables_model.dart';
import 'package:club_app/repository/club_app_repository.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TableCartState { Busy, NoData, ListRetrieved }

class CartBloc {
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> isLoadingController = BehaviorSubject<bool>();
  BehaviorSubject<TableCartState> tableCartsController =
      BehaviorSubject<TableCartState>();
  BehaviorSubject<double> totalAmountController = BehaviorSubject<double>();
  List<Event> tableCarts = <Event>[];

  void dispose() {
    isLoadingController.close();
    tableCartsController.close();
    totalAmountController.close();
  }

  void fetchDummyTableCart() {
    // tableCarts = <TableMEventodel>[];
    // TableModel tableModel1 = TableModel(
    //     1,
    //     'POOL BED - 405',
    //     'https://dreamadmin.bookbeachclub.com/assets/img/category/1567625483.jpg',
    //     'Including pool bed, sofa and Umbrella',
    //     4,
    //     6000,
    //     'THAI BAHT');
    // TableModel tableModel2 = TableModel(
    //     2,
    //     'BEACH FRONT BED - 505',
    //     'https://dreamadmin.bookbeachclub.com/assets/img/category/1567625515.jpg',
    //     'Including pool bed and Umbrella',
    //     4,
    //     4000,
    //     'THAI BAHT');
    // TableModel tableModel3 = TableModel(
    //     3,
    //     'BEACH FRONT BED - 602',
    //     'https://dreamadmin.bookbeachclub.com/assets/img/category/1567625515.jpg',
    //     'Including pool bed and Umbrella',
    //     4,
    //     4000,
    //     'THAI BAHT');
    // TableModel tableModel4 = TableModel(
    //     4,
    //     'VIP POOL SIDE KING BED - 218',
    //     'https://dreamadmin.bookbeachclub.com/assets/img/category/1567625483.jpg',
    //     'Including pool bed, sofa and Umbrella',
    //     4,
    //     7000,
    //     'THAI BAHT');
    // tableCarts.add(tableModel1);
    // tableCarts.add(tableModel2);
    // tableCarts.add(tableModel3);
    // tableCarts.add(tableModel4);
    // tableCartsController.add(TableCartState.ListRetrieved);
  }

  void fetchCartList(String userId) {
    isLoadingController.add(true);
    _repository.fetchCartList(userId).then((Response response) {
      isLoadingController.add(false);
      CartResponseModel tableCartResponse =
          CartResponseModel.fromJson(json.decode(response.body));
      debugPrint('Table cart api response is ' + response.body);
      if (tableCartResponse.status) {
        if (tableCartResponse.data.events != null &&
            tableCartResponse.data.events.isNotEmpty) {
          tableCarts = tableCartResponse.data.events;
          tableCartsController.add(TableCartState.ListRetrieved);
        } else {
          tableCartsController.add(TableCartState.NoData);
        }
      } else {
        tableCartsController.add(TableCartState.NoData);
      }
    }).catchError((Object error) {
      isLoadingController.add(false);
    });
  }

  Future<void> checkoutTable(
      List<TableModel> cartTable, BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(ClubApp.userId);
    List<Map<String, dynamic>> daybed = <Map<String, dynamic>>[];
    for (TableModel table in cartTable) {
      List<int> addOnList;
      if (table.addOns != null && table.addOns.isNotEmpty) {
        addOnList = <int>[];
        for (AddOnModel addOnModel in table.addOns) {
          addOnList.add(addOnModel.id);
        }
      }
      daybed.add({
        'date': table.bookingDate,
        'unit_id': table.unitId,
        'addon': addOnList
      });
    }

    isLoadingController.add(true);
    _repository
        .checkoutTableBookings(userId.toString(), daybed)
        .then((Response response) {
      isLoadingController.add(false);
      debugPrint('Checkout table response is ${response.body}');
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['status']) {
        ackAlert(context, 'Table booked successfully');
      } else {
        ackAlert(context, responseBody['error']);
      }
    });
  }
}
