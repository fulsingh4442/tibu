import 'package:club_app/constants/strings.dart';

class BiddingResponse {
  BiddingResponse.fromJson(Map<String, dynamic> jsonMap) {
    status = jsonMap['status'];
    error = jsonMap['error'];
    biddingModelList = <BiddingModel>[];
    if (jsonMap['data'] != null) {
      for (Map<String, dynamic> json in jsonMap['data']) {
        biddingModelList.add(BiddingModel.fromJson(json));
      }
    }
  }

  bool status;
  String error;
  List<BiddingModel> biddingModelList;
}

class BiddingModel {
  int bidId;
  String bidName;
  String description;
  String date;
  int bidAmount;
  int tempBidAmount;
  int currentHighestBidAmount;
  String currentHighestBidName;
  String currency;
  bool isInProcess;

  BiddingModel(
      {this.bidName,
      this.description,
      this.date,
      this.bidAmount,
      this.currentHighestBidAmount,
      this.currentHighestBidName,
      this.tempBidAmount,
      this.isInProcess = false}) {
    tempBidAmount = bidAmount;
  }

  BiddingModel.fromJson(Map<String, dynamic> json) {
    bidId = json['id'];
    bidName = json['name'];
    description = json['description'];
    date = json['start_date'];
    bidAmount = json['bid_start'];
    currency = ClubApp.currencyLbl;
    currentHighestBidAmount = json['max_bid'];
    currentHighestBidName = json['max_bidder'];

    if (currentHighestBidName == null) {
      currentHighestBidName = "";
      isInProcess = false;
    } else {
      isInProcess = true;
    }
    tempBidAmount = bidAmount;
  }
}
