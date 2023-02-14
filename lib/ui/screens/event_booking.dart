import 'dart:async';
import 'package:readmore/readmore.dart';
import 'package:club_app/constants/constants.dart';
import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/bloc/add_to_cart_bloc.dart';
import 'package:club_app/logic/bloc/event_booking_bloc.dart';
import 'package:club_app/logic/models/event_booking_model.dart';
import 'package:club_app/logic/models/event_model.dart';
import 'package:club_app/ui/screens/event_details.dart';
import 'package:club_app/ui/utils/utility.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:club_app/ui/widgets/button_rounded_border.dart';
import 'package:club_app/ui/widgets/outline_border_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventBookingScreen extends StatefulWidget {
  const EventBookingScreen(this.eventModel);

  final EventModel eventModel;

  @override
  _EventBookingScreenState createState() =>
      _EventBookingScreenState(eventModel);
}

class _EventBookingScreenState extends State<EventBookingScreen> {
  _EventBookingScreenState(this.eventModel);

  EventModel eventModel;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  EventBookingBloc _eventBookingBloc;
  AddToCartBloc _addToCartBloc;
  double totalAmount = 0.0;
  List<EventSeats> eventSeatsList = <EventSeats>[];

  @override
  void initState() {
    super.initState();
    _eventBookingBloc = EventBookingBloc();
    _addToCartBloc = AddToCartBloc();
    fetchEventSeats();
  }

  Future<void> fetchEventSeats() async {
    final bool isInternetAvailable = await isNetworkAvailable();
    if (isInternetAvailable) {
      _eventBookingBloc.fetchEventSeats(eventModel.eventId, context);
    } else {
      ackAlert(context, ClubApp.no_internet_message);
    }
  }

  @override
  void dispose() {
    _eventBookingBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        title: Text('Book Event'),
        leading: IconButton(
          onPressed: () {

            AppNavigator.gotoLanding(context);
            //Navigator.pop(context);
            // Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<bool>(
          stream: _eventBookingBloc.isLoadingController.stream,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            bool isLoading = false;
            if (snapshot.hasData) {
              isLoading = snapshot.data;
            }

            return ModalProgressHUD(
                inAsyncCall: isLoading,
                color: Colors.black,
                progressIndicator: const CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: StreamBuilder<EventsBookingState>(
                          stream: _eventBookingBloc.eventListController.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<EventsBookingState> snapshot) {
                            print(snapshot.toString() + "=======>>");
                            if (!snapshot.hasData) {
                              return Container();
                            }
                            if (snapshot.data ==
                                EventsBookingState.ListRetrieved) {
                              eventSeatsList =
                                  _eventBookingBloc.eventSeatsList != null
                                      ? _eventBookingBloc.eventSeatsList
                                      : 0;
                              return generateEventSeatList(context);
                            } else {
                              return Center(
                                child: Text(
                                  ClubApp.no_event_seats_available,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .apply(color: textColorDarkPrimary),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1.0,
                      margin: const EdgeInsets.only(top: 4),
                      color: detailsDividerColor,
                    ),
                    getBottomView(context),
                    /*const SizedBox(
                      height: 4,
                    ),*/
                  ],
                ));
          },
        ),
      ),
    );
  }

  Widget getBottomView(context) {
    return Container(
      color: cardBackgroundColor,
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
                Text(
                    // '${eventModel.seatList[0].currency} ' +
                    '${ClubApp.currencyLbl} ' + totalAmount.toStringAsFixed(2),
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
                  ClubApp.btn_book,
                  Theme.of(context)
                      .textTheme
                      .subtitle1
                      .apply(color: Colors.white), onPressed: () async {
                if (totalAmount > 0.0) {
                  final bool isInternetAvailable = await isNetworkAvailable();
                  if (isInternetAvailable) {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    int userId = prefs.getInt(ClubApp.userId);
                    print(
                        "=======QUANTITY========${eventSeatsList[0].quantity}");
                    for (var tt in eventSeatsList) {
                      if (tt.quantity > 0) {
                        _addToCartBloc.cart(
                            tt.seatId, userId, tt.quantity, context);
                      }
                    }

                    Utility.showSnackBarMessage(
                        _scaffoldKey, ClubApp.added_to_cart);
                    //Timer(Duration(seconds: 2), () {
                      print("inside timer");
                      AppNavigator.gotoTableCart(context, [], []);
                    //});

                    // _eventBookingBloc.checkoutEvents(
                    //     eventModel.eventId, eventSeatsList, context);
                  } else {
                    ackAlert(context, ClubApp.no_internet_message);
                  }
                } else {
                  Utility.showSnackBarMessage(
                      _scaffoldKey, ClubApp.event_booking_warning);
                }
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget generateEventSeatList(BuildContext context) {
    print("eventSeatsList ${eventSeatsList.length}");
    return ListView.builder(
        //shrinkWrap: true,
        //padding: const EdgeInsets.only(top: 8.0),
        itemCount: eventSeatsList.length,
        itemBuilder: generateEventSeatsCard);
  }

  Widget generateEventSeatsCard(BuildContext context, int index) {
    EventSeats eventSeats = eventSeatsList[index];
    print(eventSeats.capacity.toString() + "===>>");

    return Card(
      color: cardBackgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 1.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(eventSeats.seatLabel,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .apply(color: textColorDarkPrimary)),
                  ReadMoreText(
                    eventSeats.seatDescription,
                    trimLines: 2,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    moreStyle: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .apply(color: Colors.pink),
                    style:  Theme.of(context)
                        .textTheme
                        .bodyText2
                        .apply(color: textColorDarkSecondary),
                  ),
                  /*Text(
                    eventSeats.seatDescription,
                    maxLines: 2,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .apply(color: textColorDarkSecondary),
                  ),*/
                  const SizedBox(
                    height: 4,
                  ),
                  // IntrinsicHeight(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     crossAxisAlignment: CrossAxisAlignment.stretch,
                  //     children: [
                  //       Text(
                  //         'Capacity: ${eventSeats.capacity.toString()}',
                  //         maxLines: 1,
                  //         style: Theme.of(context)
                  //             .textTheme
                  //             .bodyText2
                  //             .apply(color: textColorDarkPrimary),
                  //       ),
                  //       Container(
                  //         width: 1.0,
                  //         margin: const EdgeInsets.symmetric(horizontal: 8),
                  //         color: dividerColor,
                  //       ),
                  //       Text(
                  //         'Remaining: ${eventSeats.remaining.toString()}',
                  //         maxLines: 2,
                  //         style: Theme.of(context)
                  //             .textTheme
                  //             .bodyText2
                  //             .apply(color: textColorDarkPrimary),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: eventSeats.remaining == 0 < 1
                  ? const Text(
                      "SOLD OUT",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: Container(
                                //padding: const EdgeInsets.all(5.0),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                if (eventSeats.quantity > 0) {
                                  setState(() {
                                    eventSeats.quantity -= 1;
                                    totalAmount -= eventSeats.rate;
                                    eventSeats.remaining++;
                                  });
                                }
                              },
                            ),
                            SizedBox(width: 15),
                            Text(
                              '${eventSeats.quantity.toString()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .apply(color: textColorDarkPrimary),
                            ),
                            SizedBox(width: 15),
                            GestureDetector(
                              child: Container(
                                //padding: const EdgeInsets.all(5.0),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                // if (eventSeats.quantity == eventSeats.remaining) {
                                if (eventSeats.remaining < 1) {
                                  Utility.showSnackBarMessage(_scaffoldKey,
                                      ClubApp.seats_capacity_reached);
                                } else {
                                  setState(() {
                                    eventSeats.quantity += 1;
                                    totalAmount += eventSeats.rate;
                                    eventSeats.remaining--;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          eventSeats.currency + ' ${eventSeats.rate}',
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .apply(color: textColorDarkSecondary),
                        )
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
