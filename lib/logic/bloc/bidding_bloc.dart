import 'dart:convert';

import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/models/bidding_model.dart';
import 'package:club_app/repository/club_app_repository.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';

enum BiddingState { Busy, NoData, ListRetrieved, InProgress }

class BiddingBloc {
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> loaderController = BehaviorSubject<bool>();
  BehaviorSubject<bool> requestButtonController = BehaviorSubject<bool>();
  BehaviorSubject<BiddingState> bindingsListController =
      BehaviorSubject<BiddingState>();
  List<BiddingModel> biddingList;

  int biddingCount = 0;

  void dispose() {
    loaderController.close();
    bindingsListController.close();
    requestButtonController.close();
  }

  Future<void> fetchDummyBiddingList() async {
    debugPrint('In fetchDummyVoucherList');
    BiddingModel bid1 = BiddingModel(
        bidName: "VIP Table",
        description: "Sits 5 with a bottle of champagne",
        bidAmount: 100,
        currentHighestBidAmount: 100,
        currentHighestBidName: "Valued upto",
        date: DateTime.now().add(Duration(days: 1)).toString());
    BiddingModel bid2 = BiddingModel(
        bidName: "Cabana",
        description: "Sits 5 with a bottle of champagne",
        bidAmount: 200,
        currentHighestBidAmount: 200,
        currentHighestBidName: "Valued upto",
        date: DateTime.now().add(Duration(days: 5)).toString());
    BiddingModel bid3 = BiddingModel(
        bidName: "VIP Table",
        description: "Sits 5 with a bottle of champagne",
        bidAmount: 300,
        currentHighestBidAmount: 300,
        currentHighestBidName: "Valued upto",
        date: DateTime.now().add(Duration(days: 7)).toString());
    BiddingModel bid4 = BiddingModel(
        bidName: "VIP Table",
        description: "Sits 5 with a bottle of champagne",
        bidAmount: 100,
        currentHighestBidAmount: 400,
        currentHighestBidName: "Valued upto",
        date: DateTime.now().add(Duration(days: 15)).toString());
//    BiddingModel bid5 = BiddingModel(bidName: "BID 5",description: "This is bid 5", bidAmount: 200,currentHighestBidAmount: 500,currentHighestBidName: "Club app",date: DateTime(2020, 8, 04));
//    BiddingModel bid6 = BiddingModel(bidName: "BID 6",description: "This is bid 6", bidAmount: 300,currentHighestBidAmount: 600,currentHighestBidName: "Club app",date: DateTime(2020, 7, 05));

    biddingList = <BiddingModel>[];
    biddingList.add(bid1);
    biddingList.add(bid2);
    biddingList.add(bid3);
    biddingList.add(bid4);
//    biddingList.add(bid5);
//    biddingList.add(bid6);

    loaderController.add(true);
    Future.delayed(const Duration(seconds: 3), () {
      debugPrint('In vouchers Future delayed');
      loaderController.add(false);
      bindingsListController.add(BiddingState.ListRetrieved);
      requestButtonController.add(true);
    });
  }

  void fetchBiddingList() {
    loaderController.add(true);
    _repository.fetchBiddingList().then((Response response) {
      loaderController.add(false);
      BiddingResponse biddingResponse =
          BiddingResponse.fromJson(json.decode(response.body));
      debugPrint('Bidding list api response is ' + response.body);
      if (biddingResponse.status) {
        if (biddingResponse.biddingModelList != null &&
            biddingResponse.biddingModelList.isNotEmpty) {
          biddingList = biddingResponse.biddingModelList;
          bindingsListController.add(BiddingState.ListRetrieved);
          requestButtonController.add(true);
        } else {
          bindingsListController.add(BiddingState.NoData);
          requestButtonController.add(false);
        }
      } else {
        bindingsListController.add(BiddingState.NoData);
        requestButtonController.add(false);
      }
    }).catchError((Object error) {
      loaderController.add(false);
    });
  }

  void updateBids(
      List<BiddingModel> biddingList, BuildContext context, int userId, String userName) {
    List<Map<String, dynamic>> listMap = <Map<String, dynamic>>[];
    for (BiddingModel biddingModel in biddingList) {
      if (biddingModel.bidAmount > biddingModel.tempBidAmount) {
        listMap.add({
          'guest_id': userId,
          'bid_id': biddingModel.bidId,
          'amount': biddingModel.bidAmount,
          'currency': biddingModel.currency
        });
      }
    }

    if (listMap.isNotEmpty) {
      updateBiddingList(context, listMap, userName);
      //ackAlert(context, ClubApp.bid_request);
    } else {
      ackAlert(context, ClubApp.bid_request_warning);
    }
  }

  void updateBiddingList(BuildContext context, List<Map<String, dynamic>> bidList, String userName) {
    loaderController.add(true);
    _repository.updateBid(bidList).then((Response response) {

      debugPrint('Update Bidding list api response is ' + response.body);
      if(response.statusCode == 200){
        Map<String,dynamic> jsonMap = json.decode(response.body);
        if(jsonMap['status'] as bool){
          for(Map<String, dynamic> bid in bidList){
            for(BiddingModel biddingModel in biddingList){
              if(bid['bid_id'] as int == biddingModel.bidId){
                biddingModel.bidAmount = bid['amount'] as int;
                biddingModel.tempBidAmount = bid['amount'] as int;
                biddingModel.currentHighestBidAmount = bid['amount'] as int;
                biddingModel.currentHighestBidName = userName;
                biddingModel.isInProcess = true;
                break;
              }
            }
          }
          bindingsListController.add(BiddingState.ListRetrieved);
          requestButtonController.add(true);
          loaderController.add(false);
          ackAlert(context, ClubApp.bid_request);
        } else {
          loaderController.add(false);
        }
      } else {
        loaderController.add(false);
      }
    }).catchError((Object error) {
      debugPrint('Update bidding api exceptin is ${error.toString()}');
      loaderController.add(false);
    });
  }
}
