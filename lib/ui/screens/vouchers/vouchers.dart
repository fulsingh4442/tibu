import 'package:club_app/constants/constants.dart';
import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/bloc/vouchers_bloc.dart';
import 'package:club_app/logic/models/vouchers.dart';
import 'package:club_app/ui/utils/utility.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:club_app/ui/widgets/button_rounded_border.dart';
import 'package:club_app/ui/widgets/outline_border_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class VouchersScreen extends StatefulWidget {
  @override
  _VouchersScreenState createState() => _VouchersScreenState();
}

class _VouchersScreenState extends State<VouchersScreen> {
  VouchersBloc _vouchersBloc;
  List<Vouchers> allVoucherList;
  List<Vouchers> drinkVoucherList;
  List<Vouchers> entryVoucherList;
  double totalAmount = 0.0;
  ScrollController _scrollController = ScrollController();
  int pageCount = 1;
  bool allVouchersFetched = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _vouchersBloc = VouchersBloc();
    _listenScrollController();
    fetchVouchers();
  }

  void _listenScrollController() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (allVoucherList != null &&
            allVoucherList.length < _vouchersBloc.vouchersCount &&
            !_vouchersBloc.loaderController.value) {
          pageCount++;
          fetchVouchers(showInternetAlert: false);
        }
      }
    });
  }

  Future<void> fetchVouchers({bool showInternetAlert = true}) async {
    final bool isInternetAvailable = await isNetworkAvailable();
    if (isInternetAvailable) {
      _vouchersBloc.fetchVouchersList(context, pageCount, eventListOffset);
//      _vouchersBloc.fetchDummyVoucherList();
    } else {
      if (showInternetAlert) {
        ackAlert(context, ClubApp.no_internet_message);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _vouchersBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: appBackgroundColor,
        appBar: AppBar(
          bottom: PreferredSize(
            child: TabBar(
              isScrollable: false,
              dragStartBehavior: DragStartBehavior.start,
              unselectedLabelColor: Colors.white.withOpacity(0.3),
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  child: Text('All'),
                ),
                Tab(
                  child: Text('Food & Drinks'),
                ),
                Tab(
                  child: Text('Entry'),
                ),
              ],
            ),
            preferredSize: Size.fromHeight(0.0),
          ),
          actions: [
            IconButton(
              onPressed: () {
                AppNavigator.gotoLanding(context);
              },
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: SafeArea(
          child: StreamBuilder<bool>(
            stream: _vouchersBloc.loaderController.stream,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              debugPrint('In loader controller stream buulder');
              bool isLoading = false;
              if (snapshot.hasData) {
                isLoading = snapshot.data;
              }

              return ModalProgressHUD(
                inAsyncCall: pageCount == 1 ? isLoading : false,
                //color: dividerColor,
                progressIndicator: CircularProgressIndicator(
                  backgroundColor: dividerColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          getAllTabView(context),
                          getFoodAndDrinkTabView(context),
                          getEntryTabView(context),
                        ],
                      ),
                    ),
                    (pageCount != 1 && isLoading)
                        ? Container(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            color: Colors.transparent,
                            child: Center(
                              child: new CircularProgressIndicator(
                                backgroundColor: dividerColor,
                              ),
                            ),
                          )
                        : Container(),
                    getBottomView(context),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget getBottomView(context) {
    return Container(
      color: cardBackgroundColor,
//      color: Colors.grey.withAlpha(75),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .apply(color: textColorDarkPrimary)),
                Text(ClubApp.currencyLbl + totalAmount.toStringAsFixed(2),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .apply(color: textColorDarkPrimary)),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlineBorderButton(
                  buttonBackground,
                  12.0,
                  32.0,
                  ClubApp.btn_checkout,
                  Theme.of(context)
                      .textTheme
                      .subtitle1
                      .apply(color: Colors.white), onPressed: () async {
                if (totalAmount > 0.0) {
                  final bool isInternetAvailable = await isNetworkAvailable();
                  if (isInternetAvailable) {
                    _vouchersBloc.checkoutVouchers(allVoucherList, context);
                  } else {
                    ackAlert(context, ClubApp.no_internet_message);
                  }
                } else {
                  Utility.showSnackBarMessage(
                      _scaffoldKey, ClubApp.voucher_booking_warning);
                }
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget getAllTabView(BuildContext context) {
    return StreamBuilder<VouchersState>(
      stream: _vouchersBloc.vouchersListController.stream,
      builder: (BuildContext context, AsyncSnapshot<VouchersState> snapshot) {
        debugPrint('In voucher list controller stream builder ');
        if (snapshot.hasError || !snapshot.hasData) {
          debugPrint(
              'In voucher list controller snapshot has error or has not data ');
          return Container();
        }
        if (snapshot.data == VouchersState.NoData) {
          debugPrint('In voucher list controller snapshot no data ');
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
        if (allVoucherList == null) {
          allVoucherList = <Vouchers>[];
        } else {
          allVoucherList.clear();
        }
        for (int i = 0; i < _vouchersBloc.voucherList.length; i++) {
          int dateDiff = 0;

          if (_vouchersBloc.voucherList[i].voucherClaimEndDate != null) {
            dateDiff = _vouchersBloc.voucherList[i].voucherClaimEndDate
                .difference(DateTime.now())
                .inDays;
          }
          if (dateDiff >= 0) {
            allVoucherList.add(_vouchersBloc.voucherList[i]);
          }
        }
        if (allVoucherList.length > 0) {
          debugPrint('In voucher list controller voucher list');
          return generateAllVoucherList(context);
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

  Widget generateAllVoucherList(BuildContext context) {
    return ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        //padding: const EdgeInsets.only(top: 8.0),
        itemCount: allVoucherList.length,
        itemBuilder: generateAllVoucherCard);
  }

  Widget generateAllVoucherCard(BuildContext context, int index) {
    String date = '';
    String day = '';
    String strCategory = allVoucherList[index].category;
    debugPrint('In voucher list item card');
    String eventDisplayDate =
        getEventDisplayDate(allVoucherList[index].voucherClaimStartDate);
    if (eventDisplayDate != null && eventDisplayDate.isNotEmpty) {
      final List<String> dateMonth = eventDisplayDate.split(' ');
      day = dateMonth[0];
      date = dateMonth[1] + ' ' + dateMonth[2];
    }

    return Card(
      elevation: 3,
      color: cardBackgroundColor,
      child: Container(
        color: cardBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 4,
                child: Image.asset(
                  "assets/images/voucher_1.jpg",
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                width: 1.0,
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      allVoucherList[index].voucherTitle,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: textColorDarkPrimary, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      allVoucherList[index].voucherDescription,
                      maxLines: 3,
                      style: Theme.of(context).textTheme.caption.copyWith(
                          color: textColorDarkSecondary, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    /*Text(
                      'Category : ' + strCategory,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: textColorDarkSecondary, fontSize: 11),
                    ),*/
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${allVoucherList[index].currency} ${allVoucherList[index].claimedFor} ',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(
                              color: textColorDarkSecondary,
                              fontSize: 11),
                        ),
                        SizedBox(width: 8,),
                        Text(
                          'Value - ${allVoucherList[index].currency} ${allVoucherList[index].valuedUpTo}',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(
                              color: textColorDarkSecondary,
                              fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),*/
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${allVoucherList[index].currency} ${allVoucherList[index].claimedFor} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        color: textColorDarkPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                day + ', ' + date,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        color: textColorDarkSecondary,
                                        fontSize: 13),
                              ),
                              /*Text(
                                '${allVoucherList[index].currency} ${allVoucherList[index].claimedFor} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        color: textColorDarkSecondary,
                                        fontSize: 11),
                              ),
                              Text(
                                'Value - ${allVoucherList[index].currency} ${allVoucherList[index].valuedUpTo}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        color: textColorDarkSecondary,
                                        fontSize: 11),
                              ),*/
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              bool isClaimed = allVoucherList[index].isClaimed;
                              if (isClaimed) {
                                totalAmount -= allVoucherList[index].claimedFor;
                              } else {
                                totalAmount += allVoucherList[index].claimedFor;
                              }
                              allVoucherList[index].isClaimed = !isClaimed;
                            });
                          },
                          // borderSide: BorderSide(color: Colors.white),
                          child: Text(
                            allVoucherList[index].isClaimed ? 'Remove' : 'Add',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .apply(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getFoodAndDrinkTabView(BuildContext context) {
    return StreamBuilder<VouchersState>(
      stream: _vouchersBloc.vouchersListController.stream,
      builder: (BuildContext context, AsyncSnapshot<VouchersState> snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          return Container();
        }
        if (snapshot.data == VouchersState.NoData) {
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
        if (drinkVoucherList == null) {
          drinkVoucherList = <Vouchers>[];
        } else {
          drinkVoucherList.clear();
        }
        for (int i = 0; i < _vouchersBloc.voucherList.length; i++) {
          if (_vouchersBloc.voucherList[i].category == 'food and drinks') {
            int dateDiff = 0;

            if (_vouchersBloc.voucherList[i].voucherClaimEndDate != null) {
              dateDiff = _vouchersBloc.voucherList[i].voucherClaimEndDate
                  .difference(DateTime.now())
                  .inDays;
            }
            if (dateDiff >= 0) {
              drinkVoucherList.add(_vouchersBloc.voucherList[i]);
            }
          }
        }
        if (drinkVoucherList.length > 0) {
          return generateFoodAndDrinkVoucherList(context);
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

  Widget generateFoodAndDrinkVoucherList(BuildContext context) {
    return ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        //padding: const EdgeInsets.only(top: 8.0),
        itemCount: drinkVoucherList.length,
        itemBuilder: generateFoodAndDrinkVoucherCard);
  }

  Widget generateFoodAndDrinkVoucherCard(BuildContext context, int index) {
    String date = '';
    String day = '';
    String strCategory = drinkVoucherList[index].category;
    String eventDisplayDate =
        getEventDisplayDate(drinkVoucherList[index].voucherClaimStartDate);
    if (eventDisplayDate != null && eventDisplayDate.isNotEmpty) {
      final List<String> dateMonth = eventDisplayDate.split(' ');
      day = dateMonth[0];
      date = dateMonth[1] + ' ' + dateMonth[2];
    }

    return Card(
      elevation: 3,
      color: cardBackgroundColor,
      child: Container(
        color: cardBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 4,
                child: Image.asset(
                  "assets/images/voucher_2.jpg",
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                width: 1.0,
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      drinkVoucherList[index].voucherTitle,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: textColorDarkPrimary, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      drinkVoucherList[index].voucherDescription,
                      maxLines: 3,
                      style: Theme.of(context).textTheme.caption.copyWith(
                          color: textColorDarkSecondary, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    /*Text(
                      'Category : ' + strCategory,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: textColorDarkSecondary, fontSize: 11),
                    ),*/
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${drinkVoucherList[index].currency} ${drinkVoucherList[index].claimedFor} ',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(
                              color: textColorDarkSecondary,
                              fontSize: 11),
                        ),
                        SizedBox(width: 8,),
                        Text(
                          'Value - ${drinkVoucherList[index].currency} ${drinkVoucherList[index].valuedUpTo}',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(
                              color: textColorDarkSecondary,
                              fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),*/
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${drinkVoucherList[index].currency} ${drinkVoucherList[index].claimedFor} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        color: textColorDarkPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                day + ', ' + date,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        color: textColorDarkSecondary,
                                        fontSize: 13),
                              ),
                              /*Text(
                                '${drinkVoucherList[index].currency} ${drinkVoucherList[index].claimedFor} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                    color: textColorDarkSecondary,
                                    fontSize: 11),
                              ),
                              Text(
                                'Value - ${drinkVoucherList[index].currency} ${drinkVoucherList[index].valuedUpTo}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                    color: textColorDarkSecondary,
                                    fontSize: 11),
                              ),*/
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              bool isClaimed =
                                  drinkVoucherList[index].isClaimed;
                              if (isClaimed) {
                                totalAmount -=
                                    drinkVoucherList[index].claimedFor;
                              } else {
                                totalAmount +=
                                    drinkVoucherList[index].claimedFor;
                              }
                              drinkVoucherList[index].isClaimed = !isClaimed;
                            });
                          },
                          // borderSide: BorderSide(color: Colors.white),
                          child: Text(
                            drinkVoucherList[index].isClaimed
                                ? 'Remove'
                                : 'Add',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .apply(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getEntryTabView(BuildContext context) {
    return StreamBuilder<VouchersState>(
      stream: _vouchersBloc.vouchersListController.stream,
      builder: (BuildContext context, AsyncSnapshot<VouchersState> snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          return Container();
        }
        if (snapshot.data == VouchersState.NoData) {
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
        if (entryVoucherList == null) {
          entryVoucherList = <Vouchers>[];
        } else {
          entryVoucherList.clear();
        }
        for (int i = 0; i < _vouchersBloc.voucherList.length; i++) {
          if (_vouchersBloc.voucherList[i].category == 'entry') {
            int dateDiff = 0;

            if (_vouchersBloc.voucherList[i].voucherClaimEndDate != null) {
              dateDiff = _vouchersBloc.voucherList[i].voucherClaimEndDate
                  .difference(DateTime.now())
                  .inDays;
            }
            if (dateDiff >= 0) {
              entryVoucherList.add(_vouchersBloc.voucherList[i]);
            }
          }
        }
        if (entryVoucherList.length > 0) {
          return generateEntryVoucherList(context);
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

  Widget generateEntryVoucherList(BuildContext context) {
    return ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        //padding: const EdgeInsets.only(top: 8.0),
        itemCount: entryVoucherList.length,
        itemBuilder: generateEntryVoucherCard);
  }

  Widget generateEntryVoucherCard(BuildContext context, int index) {
    String date = '';
    String day = '';
    String strCategory = entryVoucherList[index].category;
    String eventDisplayDate =
        getEventDisplayDate(entryVoucherList[index].voucherClaimStartDate);
    if (eventDisplayDate != null && eventDisplayDate.isNotEmpty) {
      final List<String> dateMonth = eventDisplayDate.split(' ');
      day = dateMonth[0];
      date = dateMonth[1] + ' ' + dateMonth[2];
    }

    return Card(
      elevation: 3,
      color: cardBackgroundColor,
      child: Container(
        color: cardBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 4,
                child: Image.asset(
                  "assets/images/voucher_3.jpg",
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                width: 1.0,
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entryVoucherList[index].voucherTitle,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: textColorDarkPrimary, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      entryVoucherList[index].voucherDescription,
                      maxLines: 3,
                      style: Theme.of(context).textTheme.caption.copyWith(
                          color: textColorDarkSecondary, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    /*Text(
                      'Category : ' + strCategory,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: textColorDarkSecondary, fontSize: 11),
                    ),*/
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${entryVoucherList[index].currency} ${entryVoucherList[index].claimedFor} ',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(
                              color: textColorDarkSecondary,
                              fontSize: 11),
                        ),
                        SizedBox(width: 8,),
                        Text(
                          'Value - ${entryVoucherList[index].currency} ${entryVoucherList[index].valuedUpTo}',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(
                              color: textColorDarkSecondary,
                              fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),*/
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${entryVoucherList[index].currency} ${entryVoucherList[index].claimedFor} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        color: textColorDarkPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                day + ', ' + date,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        color: textColorDarkSecondary,
                                        fontSize: 13),
                              ),
                              /*Text(
                                '${entryVoucherList[index].currency} ${entryVoucherList[index].claimedFor} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                    color: textColorDarkSecondary,
                                    fontSize: 11),
                              ),
                              Text(
                                'Value - ${entryVoucherList[index].currency} ${entryVoucherList[index].valuedUpTo}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                    color: textColorDarkSecondary,
                                    fontSize: 11),
                              ),*/
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              bool isClaimed =
                                  entryVoucherList[index].isClaimed;
                              if (isClaimed) {
                                totalAmount -=
                                    entryVoucherList[index].claimedFor;
                              } else {
                                totalAmount +=
                                    entryVoucherList[index].claimedFor;
                              }
                              entryVoucherList[index].isClaimed = !isClaimed;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            onSurface: Colors.white,
                          ),
                          child: Text(
                            entryVoucherList[index].isClaimed
                                ? 'Remove'
                                : 'Add',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .apply(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
