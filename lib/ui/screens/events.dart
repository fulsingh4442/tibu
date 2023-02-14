import 'package:club_app/constants/constants.dart';
import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/bloc/currency_bloc.dart';
import 'package:club_app/logic/bloc/events_bloc.dart';
import 'package:club_app/logic/models/advertise.dart';
import 'package:club_app/logic/models/event_model.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<EventModel> eventList;
  EventBloc _eventBloc;
  CurrencyBloc _currencyBloc;
  DateTime selectedDate = DateTime.now();
  bool isDateFilter = false;
  ScrollController _scrollController = ScrollController();
  int pageCount = 1;
  bool allEventsFetched = false;

  @override
  void initState() {
    print("inside events init");
    super.initState();
    _eventBloc = EventBloc();
    _currencyBloc = CurrencyBloc();
    _listenScrollController();
    fetchEvents();
    getCurrency();
  }

  void _listenScrollController() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
//        if (!allEventsFetched) {
        if (eventList != null &&
            eventList.length < _eventBloc.eventCount &&
            !_eventBloc.isLoadingController.value) {
          pageCount++;
          fetchEvents(showInternetAlert: false);
        }
      }
    });
  }

  Future<void> getCurrency({bool showInternetAlert = true}) async {
    final bool isInternetAvailable = await isNetworkAvailable();
    if (isInternetAvailable) {
      _currencyBloc.currency(context);
    } else {
      if (showInternetAlert) {
        ackAlert(context, ClubApp.no_internet_message);
      }
    }
  }

  Future<void> fetchEvents({bool showInternetAlert = true}) async {
    final bool isInternetAvailable = await isNetworkAvailable();
    if (isInternetAvailable) {
      _eventBloc.fetchEventsList(context, pageCount, eventListOffset);
//      _eventBloc.fetchLocalEventsList();
    } else {
      if (showInternetAlert) {
        ackAlert(context, ClubApp.no_internet_message);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _eventBloc.dispose();
    _currencyBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectDate(context);
        },
        backgroundColor: buttonBackground,
        child: Icon(Icons.event),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: StreamBuilder<bool>(
            stream: _eventBloc.isLoadingController.stream,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
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
                  children: [
                    isDateFilter
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(8, 2, 8, 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  //color: Colors.white,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                      color: Colors.red),
                                  child: Row(
                                    children: [
                                      Text(
                                        currentEventFilterDisplayDate(
                                            selectedDate),
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .apply(color: Colors.white),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      /*IconButton(
                                  color: Colors.grey,
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isDateFilter = false;
                                    });
                                  },
                                ),*/
                                      GestureDetector(
                                        child: Icon(
                                          Icons.cancel,
                                          color: Colors.white,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            isDateFilter = false;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    /*Container(
                      height: 170,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        'assets/images/event6.jpg',
                        fit: BoxFit.fill,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),*/

                    StreamBuilder<Advertise>(
                      stream: _eventBloc.advertiseController.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<Advertise> snapshot) {
                        Advertise advertise;
                        if (snapshot.hasData) {
                          advertise = snapshot.data;
                          print("sadhkashdkjashdjkashkjdhaskjdhkajshd ${advertise.image}");
                          debugPrint(
                              'Advertise priority ${advertise.priority}');
                        }
                        return Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          child: advertise == null
                              ? Image.asset(
                                  'assets/images/placeholder.png',
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                )
                              : FadeInImage.assetNetwork(
                                  placeholder:
                                      'assets/images/placeholder2-small.gif',
                                  image: advertise.image,
                                  // fadeInDuration:
                                  //    const Duration(milliseconds: 500),
                                  fit: BoxFit.none,
                                  alignment: Alignment.center,
                                ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Expanded(
                      child: getEventListWidget(context),
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
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      helpText: ClubApp.hint_event_filter_date,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: (DateTime(DateTime.now().year + 5, DateTime.now().month, 0)),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        debugPrint('Event filter selected date is ==== $picked');
        isDateFilter = true;
        selectedDate = picked;
        //_eventBloc.eventListController.add(EventsState.ListRetrieved);
      });
  }

  Widget getEventListWidget(BuildContext context) {
    return StreamBuilder<EventsState>(
      stream: _eventBloc.eventListController.stream,
      builder: (BuildContext context, AsyncSnapshot<EventsState> snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          return Container();
        }
        if (snapshot.data == EventsState.NoData) {
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
        if (snapshot.data == EventsState.AllEventsFetched) {
          allEventsFetched = true;
        }
        if (eventList == null) {
          eventList = <EventModel>[];
        } else {
          eventList.clear();
        }
        for (int i = 0; i < _eventBloc.eventList.length; i++) {
          if (isDateFilter) {
            if (_eventBloc.eventList[i].eventStartDate != null) {
              bool isSameDate = false;

              isSameDate = _eventBloc.eventList[i].eventStartDate.year >
                      selectedDate.year ||
                  (_eventBloc.eventList[i].eventStartDate.year ==
                          selectedDate.year &&
                      _eventBloc.eventList[i].eventStartDate.month >=
                          selectedDate.month &&
                      _eventBloc.eventList[i].eventStartDate.day >=
                          selectedDate.day);
              debugPrint('isSameDay $isSameDate');
              if (isSameDate) {
                eventList.add(_eventBloc.eventList[i]);
              }
            }
          } else {
            int dateDiff = 0;

            if (_eventBloc.eventList[i].eventEndDate != null) {
              dateDiff = _eventBloc.eventList[i].eventEndDate
                  .difference(DateTime.now())
                  .inDays;
            }
            if (dateDiff >= 0) {
              eventList.add(_eventBloc.eventList[i]);
            }
          }
        }
        if (eventList.length > 0) {
          return generateEventList(context);
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

  Widget generateEventList(BuildContext context) {
    return ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        //padding: const EdgeInsets.only(top: 8.0),
        itemCount: eventList.length,
        itemBuilder: generateEventListCard);
  }

  Widget generateEventListCard(BuildContext context, int index) {
    EventModel eventModel = eventList[index];
    String date = '';
    String day = '';

    String eventDisplayDate = getEventDisplayDate(eventModel.eventStartDate);
    if (eventDisplayDate != null && eventDisplayDate.isNotEmpty) {
      final List<String> dateMonth = eventDisplayDate.split(' ');
      day = dateMonth[0];
      date = dateMonth[1] + ' ' + dateMonth[2];
    }

    return Card(
//      color: cardBackgroundColor,
//      margin: const EdgeInsets.all(4.0),
      elevation: 3.0,
      color: cardBackgroundColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          AppNavigator.gotoEventDetails(context, eventModel);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width / 3,
                child: eventModel.eventImage == null ||
                        eventModel.eventImage.isEmpty
                    ? Image.asset(
                        'assets/images/placeholder.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      )
                    : FadeInImage.assetNetwork(
                        placeholder: 'assets/images/placeholder2-extra-small.gif',
                        placeholderFit: BoxFit.none,
                        image: eventModel.eventImage,
                        fadeInDuration: const Duration(milliseconds: 10),
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: [
                          Text(
                            day,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                .apply(color: textColorDarkPrimary),
                          ),
                          Text(", "),
                          Text(date,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  .apply(color: textColorDarkPrimary)),
                        ],
                      ),
                      // Container(
                      //   width: 1.0,
                      //   margin: const EdgeInsets.symmetric(horizontal: 8),
                      //   color: dividerColor,
                      // ),
                      SizedBox(
                        height: 3,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(eventModel.eventTitle,
                              maxLines: 1,
                              // overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  .apply(color: textColorDarkPrimary)),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            eventModel.eventShortDescription,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .apply(color: textColorDarkSecondary),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            child: Icon(
                              Icons.arrow_forward,
                              color: colorPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
