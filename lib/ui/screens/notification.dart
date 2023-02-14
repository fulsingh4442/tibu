import 'package:club_app/constants/constants.dart';
import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/bloc/notifications_bloc.dart';
import 'package:club_app/logic/models/notifications.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Notifications> notificationsList;
  NotificationsBloc _notificationsBloc;
  ScrollController _scrollController = ScrollController();
  int pageCount = 1;
  bool allNotificationsFetched = false;

  @override
  void initState() {
    super.initState();
    _notificationsBloc = NotificationsBloc();
    _listenScrollController();
    fetchEvents();
  }

  void _listenScrollController() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!allNotificationsFetched &&
            !_notificationsBloc.isLoadingController.value) {
          pageCount++;
          fetchEvents(showInternetAlert: false);
        }
      }
    });
  }

  Future<void> fetchEvents({bool showInternetAlert = true}) async {
    final bool isInternetAvailable = await isNetworkAvailable();
    if (isInternetAvailable) {
      _notificationsBloc.fetchNotificationsList(
          context, pageCount, eventListOffset);
    } else {
      if (showInternetAlert) {
        ackAlert(context, ClubApp.no_internet_message);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _notificationsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        title: Text(ClubApp.notification),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: StreamBuilder<bool>(
            stream: _notificationsBloc.isLoadingController.stream,
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

  Widget getEventListWidget(BuildContext context) {
    return StreamBuilder<NotificationsState>(
      stream: _notificationsBloc.eventListController.stream,
      builder:
          (BuildContext context, AsyncSnapshot<NotificationsState> snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          return Container();
        }
        if (snapshot.data == NotificationsState.NoData) {
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
        if (snapshot.data == NotificationsState.AllEventsFetched) {
          allNotificationsFetched = true;
        }
        if (notificationsList == null) {
          notificationsList = <Notifications>[];
        } else {
          notificationsList.clear();
        }
        notificationsList.addAll(_notificationsBloc.notificationsList);
        if (notificationsList.length > 0) {
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
        itemCount: notificationsList.length,
        itemBuilder: generateEventListCard);
  }

  Widget generateEventListCard(BuildContext context, int index) {
    Notifications notifications = notificationsList[index];
    return Container(
      color: cardBackgroundColor,
      margin: EdgeInsets.only(top: 10.0),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              notifications.content,
              style: TextStyle(color: colorPrimaryText),
            ),
            SizedBox(height: 10.0),
            Text(
              notifications.date,
              style: TextStyle(color: colorPrimaryText),
            ),
          ],
        ),
      ),
    );
  }
}
