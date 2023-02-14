import 'dart:convert';
import 'dart:math';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/models/add_on_model.dart';
import 'package:club_app/logic/models/cart_table_event_model.dart';
import 'package:club_app/logic/models/cart_table_event_model.dart';
import 'package:club_app/logic/models/category.dart';
import 'package:club_app/logic/models/tables_model.dart';
import 'package:club_app/repository/club_app_repository.dart';
import 'package:club_app/ui/screens/table/table_cart.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AddOnState { Busy, NoData, ListRetrieved }

class AddOnsBloc {
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> loaderController = BehaviorSubject<bool>();
  BehaviorSubject<AddOnState> addOnListController =
      BehaviorSubject<AddOnState>();
  BehaviorSubject<AddOnState> tableCartsController =
      BehaviorSubject<AddOnState>();
  List<AddOnModel> addOnList;
  // List<TableModel> tableCarts = <TableModel>[];
  List<TableCartModel> tableCart = <TableCartModel>[];
  List<EventCartModel> eventCart = <EventCartModel>[];
  List<CategoryModel> category = <CategoryModel>[];
  double totalPrice = 0.0;
  bool isTableListNull = false;
  bool isEventListNull = false;

  double total_amount = 0;
  double pay_amount = 0;
  void dispose() {
    loaderController.close();
    addOnListController.close();
  }

  Future<Response> fetchAddOns() {
    loaderController.add(true);
    return _repository.fetchAddOnList().then((Response response) {
      loaderController.add(false);
      AddOnResponse addOnResponse =
          AddOnResponse.fromJson(json.decode(response.body));
      debugPrint('Add on api response is ===============>  ' + response.body);
      if (addOnResponse.status) {
        debugPrint(
            'Add on ID >>>> ' + addOnResponse.addOnModelList[0].id.toString());

        if (addOnResponse.addOnModelList != null) {
          addOnList = addOnResponse.addOnModelList;
          print(addOnList.length);
          addOnListController.add(AddOnState.ListRetrieved);
        } else {
          addOnListController.add(AddOnState.NoData);
        }
      } else {
        addOnListController.add(AddOnState.NoData);
      }
    }).catchError((Object error) {
      loaderController.add(false);
    });
  }

  Future<void> fetchTableCartList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(ClubApp.userId);
    loaderController.add(true);
    return _repository.fetchTableCartList(userId.toString()).then((Response response) {
      loaderController.add(false);
      // print("fetchtable cart response --------- ${response.body}");
      printLongString('Table cart api response issss ==> ' + response.body);

      CartTableEventResponse tableCartResponse =
          CartTableEventResponse.fromJson(json.decode(response.body));

      print(tableCartResponse.status);
      print(tableCartResponse.data.tables);
      print(tableCartResponse.data.events);

      if (tableCartResponse.total_amount != null) {
        total_amount = tableCartResponse.total_amount;
        pay_amount = tableCartResponse.pay_amount;
      }

      if (tableCartResponse.status) {
        print("COMING HERE");
        if (tableCartResponse.data.tables != null &&
            tableCartResponse.data.events != null) {
          print("both have data");
          tableCart = tableCartResponse.data.tables;
          eventCart = tableCartResponse.data.events;
          print("length ${tableCart.length} ${eventCart.length}");
        } else if (tableCartResponse.data.tables != null &&
            tableCartResponse.data.events == null) {
          print("tables");
          tableCart = tableCartResponse.data.tables;
          isEventListNull = true;
        } else if (tableCartResponse.data.events != null &&
            tableCartResponse.data.tables == null) {
          print("events");
          eventCart = tableCartResponse.data.events;
          isTableListNull = true;
        } else {
          eventCart = [];
          tableCart = [];
          print("here in else");
        }

        if (tableCart != null || eventCart != null) {
          totalPrice = 0.0;
          if (tableCart != null && isTableListNull == false) {
            for (var each in tableCart) {
              totalPrice = totalPrice + double.parse(each.rate.toString());
              print("table------ > $totalPrice");
              if (each.addons != null) {
                for (var item in each.addons) {
                  if (item.addonPaymentSkip != 1) {
                    totalPrice = totalPrice + double.parse(item.rate.toString());
                  }
                  print("table addon------ > $totalPrice");
                }
              }
            }
          }
          if (eventCart != null && isEventListNull == false) {
            for (var each in eventCart) {
              totalPrice = totalPrice +
                  double.parse(each.rate.toString()) * each.quantity;
              print("event------ > $totalPrice");
              if (each.addons != null) {
                for (var item in each.addons) {
                  if (item.addonPaymentSkip != 1) {
                    totalPrice = totalPrice + double.parse(item.rate.toString());
                  }
                  print("event addon------ > $totalPrice");
                }
              }
            }
          }
        }
      }
    }).catchError((Object error) {
      loaderController.add(false);
    });
  }

  void printLongString(String text) {
    final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((RegExpMatch match) =>   print(match.group(0)));
  }

  Future<void> deleteTable(
      int tableId, bool tabbar, BuildContext context) async {
    loaderController.add(true);
    _repository.deleteTablefromCart(tableId).then((Response response) async {
      loaderController.add(false);
      debugPrint(
          '--------delete table from cart response------ ${response.body}');

      Map map = json.decode(response.body);
      if (map.containsKey('status') && map['status']) {
        fetchTableCartList();
      } else {
        String error = map['error'];
        ackAlert(context, error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint(
          'delete table from cart response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }

  Future<void> deleteAddon(int addonCartId, BuildContext context) async {
    loaderController.add(true);
    _repository
        .deleteAddonfromCart(addonCartId)
        .then((Response response) async {
      loaderController.add(false);
      debugPrint(
          '--------delete addon from cart response------ ${response.body}');

      Map map = json.decode(response.body);
      if (map.containsKey('status') && map['status']) {
        fetchTableCartList();
      } else {
        String error = map['error'];
        ackAlert(context, error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint(
          'delete addon from cart response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }

  Future<void> deleteAddonFromList(int addonId, BuildContext context) async {
    loaderController.add(true);
    print("LOADER ADDED");
    _repository
        .deleteAddonfromList(addonId)
        .then((Response response) async {
      loaderController.add(false);
      debugPrint(
          '--------delete addon from cart response------ ${response.body}');

      Map map = json.decode(response.body);
      if (map.containsKey('status') && map['status']) {
        ackAlert(context, "Removed Successfully!!!");
      } else {
        String error = map['error'];
        ackAlert(context, error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint(
          'delete addon from cart response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }

  Future<void> deleteEvent(int eventId, BuildContext context) async {
    loaderController.add(true);
    _repository.deleteEventfromCart(eventId).then((Response response) async {
      loaderController.add(false);
      debugPrint(
          '--------delete event from cart response------ ${response.body}');
      Map map = json.decode(response.body);
      if (map.containsKey('status') && map['status']) {
        fetchTableCartList();
      } else {
        String error = map['error'];
        ackAlert(context, error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint(
          'delete event from cart response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }

  Future<void> addAddon(int addonId, String cartIds, int quantity,
      String addOnFor, BuildContext context) async {
    loaderController.add(true);
    _repository
        .addAddonToCart(addonId, cartIds, quantity, addOnFor)
        .then((Response response) async {
      loaderController.add(false);
      debugPrint('======add addon to cart response======= ${response.body}');

      Map map = json.decode(response.body);
      if (map.containsKey('status') && map['status']) {
        ackAlert(context, "Added To Cart");
      } else {
        String error = map['error'];
        ackAlert(context, error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('add addon to cart response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }

  Future<void> updateAddon(int addonId,int quantity, BuildContext context) async {
    loaderController.add(true);
    _repository
        .updateAddonToCart(addonId, quantity)
        .then((Response response) async {
      loaderController.add(false);
      debugPrint('======add addon to cart response======= ${response.body}');

      Map map = json.decode(response.body);
      if (map.containsKey('status') && map['status']) {
        //ackAlert(context, "Added To Cart");
        print("Sucessfully updated! Yay! Yay!");
      } else {
        String error = map['error'];
        ackAlert(context, error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('add addon to cart response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }
}
