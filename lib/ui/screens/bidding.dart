import 'package:club_app/logic/bloc/bidding_bloc.dart';
import 'package:club_app/ui/widgets/outline_border_button.dart';
import 'package:flutter/material.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/models/bidding_model.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:club_app/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiddingScreen extends StatefulWidget {
  @override
  _BiddingScreenState createState() => _BiddingScreenState();
}

class _BiddingScreenState extends State<BiddingScreen> {
  BiddingBloc _biddingBloc;
  int pageCount = 1;
  bool allVouchersFetched = false;
  List<BiddingModel> biddingList;
  String userName;
  int userId;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    _biddingBloc = BiddingBloc();
    fetchBidding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: SafeArea(
        child: StreamBuilder<bool>(
          stream: _biddingBloc.loaderController.stream,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            debugPrint('In loader controller stream buulder');
            bool isLoading = false;
            if (snapshot.hasData) {
              isLoading = snapshot.data;
            }

            return ModalProgressHUD(
              inAsyncCall: pageCount == 1 ? isLoading : false,
              //color: dividerColor,
              color: Colors.black,
              progressIndicator: CircularProgressIndicator(
                backgroundColor: dividerColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: getBiddingView(context),
                  ),
                  (_biddingBloc.biddingList != null &&
                          _biddingBloc.biddingList.isNotEmpty)
                      ? getBottomView(context)
                      : Container(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getBiddingView(BuildContext context) {
    return StreamBuilder<BiddingState>(
      stream: _biddingBloc.bindingsListController.stream,
      builder: (BuildContext context, AsyncSnapshot<BiddingState> snapshot) {
        debugPrint('In voucher list controller stream builder ');
        if (snapshot.hasError || !snapshot.hasData) {
          debugPrint(
              'In bidding list controller snapshot has error or has not data ');
          return Container();
        }
        if (snapshot.data == BiddingState.NoData) {
          debugPrint('In bidding list controller snapshot no data ');
          return Center(
            child: Text(
              'No Data',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .apply(color: textColorDarkPrimary),
            ),
          );
        }
        if (biddingList == null) {
          biddingList = <BiddingModel>[];
        } else {
          biddingList.clear();
        }
        /*for (int i = 0; i < _biddingBloc.biddingList.length; i++) {
          int dateDiff = 0;

          if (_biddingBloc.biddingList[i].date != null) {
            dateDiff = _biddingBloc.biddingList[i].date
                .difference(DateTime.now())
                .inDays;
          }
          if (dateDiff >= 0) {
            biddingList.add(_biddingBloc.biddingList[i]);
          }
        }*/
        biddingList.addAll(_biddingBloc.biddingList);
        if (biddingList.length > 0) {
          debugPrint('In bidding list controller bidding list');
          return generateBiddingList(context);
        } else {
          return Center(
            child: Text(
              'No Data',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .apply(color: textColorDarkPrimary),
            ),
          );
        }
      },
    );
  }

  Widget generateBiddingList(BuildContext context) {
    return ListView.builder(
        //shrinkWrap: true,
        //padding: const EdgeInsets.only(top: 8.0),
        itemCount: biddingList.length,
        itemBuilder: generateBiddingCard);
  }

  Widget generateBiddingCard(BuildContext context, int index) {
    String date = '';
    String day = '';
    debugPrint('In voucher list item card');
    BiddingModel biddingModel = biddingList[index];
    String eventDisplayDate =
        getEventDisplayDate(DateTime.parse(biddingModel.date));
    if (eventDisplayDate != null && eventDisplayDate.isNotEmpty) {
      final List<String> dateMonth = eventDisplayDate.split(' ');
      day = dateMonth[0];
      date = dateMonth[1] + ' ' + dateMonth[2];
    }

    return Card(
      elevation: 2,
      color: cardBackgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
      child: Padding(
        //color: cardBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      biddingModel.isInProcess ? "Bidding in progress" : "",
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .apply(color: buttonBackground),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      biddingModel.bidName,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: textColorDarkPrimary, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      biddingModel.description,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.caption.copyWith(
                          color: textColorDarkSecondary, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      day + ", " + date,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: textColorDarkSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1.0,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: dividerColor,
              ),
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Price starts from",
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .apply(color: textColorDarkSecondary)),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            print(biddingModel.bidAmount);
                            if (biddingModel.bidAmount >
                                biddingModel.tempBidAmount) {
                              setState(() {
                                biddingModel.bidAmount -= 100;
                                if (biddingModel.bidAmount >
                                        biddingModel.tempBidAmount &&
                                    biddingModel
                                        .currentHighestBidName.isEmpty) {
                                  biddingModel.isInProcess = true;
                                } else if (biddingModel
                                    .currentHighestBidName.isNotEmpty) {
                                  biddingModel.isInProcess = true;
                                } else {
                                  biddingModel.isInProcess = false;
                                }
                              });
                            }
                          },
                          child: Container(
                            //padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Text("${biddingModel.bidAmount}",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .apply(color: textColorDarkPrimary)),
                        SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              biddingModel.bidAmount += 100;
                              if (biddingModel.bidAmount >
                                      biddingModel.tempBidAmount &&
                                  biddingModel.currentHighestBidName.isEmpty) {
                                biddingModel.isInProcess = true;
                              } else if (biddingModel
                                  .currentHighestBidName.isNotEmpty) {
                                biddingModel.isInProcess = true;
                              } else {
                                biddingModel.isInProcess = false;
                              }
                            });
                          },
                          child: Container(
                            //padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    getCurrentBidderName(context, biddingModel),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getCurrentBidderName(BuildContext context, BiddingModel biddingModel) {
    if (!biddingModel.isInProcess) {
      return Container();
    }
    print(biddingModel.currentHighestBidAmount);
    String bidderName = biddingModel.currentHighestBidName;
    int bidAmount = biddingModel.currentHighestBidAmount;
    if (biddingModel.bidAmount > biddingModel.currentHighestBidAmount) {
      bidderName = userName;
      bidAmount = biddingModel.bidAmount;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text(bidderName ?? "",
        //     style: Theme.of(context)
        //         .textTheme
        //         .caption
        //         .apply(color: textColorDarkPrimary)),
        Text("${ClubApp.currencyLbl} $bidAmount ",
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .apply(color: textColorDarkPrimary)),
      ],
    );
  }

  Widget getBottomView(context) {
    return Container(
      color: cardBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*OutlinedButton(
            onPressed: () {
              ackAlert(context, ClubApp.bid_request);
            },
            borderSide: BorderSide(color: borderColor),
            child: Text(
              ClubApp.request_bid,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .apply(color: Colors.white),
            ),
          )*/
          OutlineBorderButton(buttonBackground, 8.0, 32.0, ClubApp.request_bid,
              Theme.of(context).textTheme.subtitle2.apply(color: Colors.white),
              onPressed: () async {
            final bool isInternetAvailable = await isNetworkAvailable();
            if (isInternetAvailable) {
              _biddingBloc.updateBids(biddingList, context, userId, userName);
            } else {
              ackAlert(context, ClubApp.no_internet_message);
            }
//            ackAlert(context, ClubApp.bid_request);
          }),
        ],
      ),
    );
  }

  Future<void> fetchBidding({bool showInternetAlert = true}) async {
    final bool isInternetAvailable = await isNetworkAvailable();
    if (isInternetAvailable) {
      _biddingBloc.fetchBiddingList();
    } else {
      if (showInternetAlert) {
        ackAlert(context, ClubApp.no_internet_message);
      }
    }
  }

  @override
  void dispose() {
    _biddingBloc.dispose();
    super.dispose();
  }

  Future<void> fetchUserDetails() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      userId = prefs.getInt(ClubApp.userId);
      String firstName = prefs.getString(ClubApp.firstName);
      String lastName = prefs.getString(ClubApp.lastName);
      userName = "$firstName  $lastName";
      debugPrint('User name is $userName');
    } catch (e) {
      print(e);
    }
  }
}
