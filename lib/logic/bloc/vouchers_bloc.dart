import 'dart:convert';

import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/models/vouchers.dart';
import 'package:club_app/repository/club_app_repository.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum VouchersState { Busy, NoData, ListRetrieved, AllEventsFetched }

class VouchersBloc {
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> loaderController = BehaviorSubject<bool>();
  BehaviorSubject<VouchersState> vouchersListController =
      BehaviorSubject<VouchersState>();
  List<Vouchers> voucherList;
  int vouchersCount = 0;

  void dispose() {
    loaderController.close();
    vouchersListController.close();
  }

  Future<void> fetchDummyVoucherList() async {
    debugPrint('In fetchDummyVoucherList');
    Vouchers vouchers1 = Vouchers(1, 'Voucher 1',
        'This is voucher 1 description', '1', 100, 500, DateTime(2020, 6, 10));
    Vouchers vouchers2 = Vouchers(2, 'Voucher 2',
        'This is voucher 2 description', '2', 120, 500, DateTime(2020, 6, 13));
    Vouchers vouchers3 = Vouchers(3, 'Voucher 3',
        'This is voucher 3 description', '2', 100, 500, DateTime(2020, 6, 17));
 /*   Vouchers vouchers4 = Vouchers(4, 'Voucher 4',
        'This is voucher 4 description', '1', 150, 500, DateTime(2020, 6, 22));
    Vouchers vouchers5 = Vouchers(5, 'Voucher 5',
        'This is voucher 5 description', '1', 100, 500, DateTime(2020, 6, 28));
    Vouchers vouchers6 = Vouchers(6, 'Voucher 6',
        'This is voucher 6 description', '2', 200, 600, DateTime(2020, 6, 28));
    Vouchers vouchers7 = Vouchers(7, 'Voucher 7',
        'This is voucher 7 description', '1', 300, 700, DateTime(2020, 7, 1));
    Vouchers vouchers8 = Vouchers(8, 'Voucher 8',
        'This is voucher 8 description', '2', 100, 500, DateTime(2020, 7, 7));
    Vouchers vouchers9 = Vouchers(9, 'Voucher 9',
        'This is voucher 9 description', '1', 180, 500, DateTime(2020, 7, 15));
    Vouchers vouchers10 = Vouchers(10, 'Voucher 10',
        'This is voucher 10 description', '2', 300, 700, DateTime(2020, 7, 18));*/

    voucherList = <Vouchers>[];
    voucherList.add(vouchers1);
    voucherList.add(vouchers2);
    voucherList.add(vouchers3);
   /* voucherList.add(vouchers4);
    voucherList.add(vouchers5);
    voucherList.add(vouchers6);
    voucherList.add(vouchers7);
    voucherList.add(vouchers8);
    voucherList.add(vouchers9);
    voucherList.add(vouchers10);
*/
    loaderController.add(true);
    Future.delayed(const Duration(seconds: 3), () {
      debugPrint('In vouchers Future delayed');
      loaderController.add(false);
      vouchersListController.add(VouchersState.ListRetrieved);
    });
  }

  void fetchVouchersList(BuildContext context, int page, int offset) async {
    debugPrint('In fetch vouchers function');
    loaderController.add(true);
    _repository
        .getVouchers(page: page, volume: offset)
        .then((Response response) {
      loaderController.add(false);

      VoucherResponse voucherResponse =
          VoucherResponse.fromJson(json.decode(response.body));
      debugPrint('Vouchers list response is ${response.body}');
      if (voucherResponse.status) {
        vouchersCount = voucherResponse.total;
        if (voucherResponse.voucherList != null &&
            voucherResponse.voucherList.isNotEmpty) {
          if (page == 1) {
            voucherList = <Vouchers>[];
          }
          voucherList.addAll(voucherResponse.voucherList);
          vouchersListController.add(VouchersState.ListRetrieved);
        } else {
          if (voucherList == null ||
              (voucherList != null && voucherList.isEmpty)) {
            vouchersListController.add(VouchersState.NoData);
          } else {
            vouchersListController.add(VouchersState.AllEventsFetched);
          }
        }
      } else {
        if (voucherList == null ||
            (voucherList != null && voucherList.isEmpty)) {
          ackAlert(context, voucherResponse.error);
        } else {
          vouchersListController.add(VouchersState.AllEventsFetched);
        }
      }
    }).catchError((Object error) {
      loaderController.add(false);
    });
  }

  Future<void> checkoutVouchers(List<Vouchers> allVoucherList, context) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(ClubApp.userId);
    List<int> vouchers = <int>[];
    for (Vouchers voucher in allVoucherList) {
      if (voucher.isClaimed) {
        vouchers.add(voucher.voucherId);
      }
    }

    loaderController.add(true);
    _repository.checkoutVoucherBookings(userId.toString(), vouchers).then((Response response){
      loaderController.add(false);
      debugPrint('Checkout vouchers response is ${response.body}');
      Map<String, dynamic> responseBody = json.decode(response.body);
      if(responseBody['status']){
        ackAlert(context, 'Vouchers booked successfully');
      } else {
        ackAlert(context, responseBody['error']);
      }
    });
  }
}
