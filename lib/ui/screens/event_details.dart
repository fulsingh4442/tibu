import 'package:club_app/constants/constants.dart';
import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/bloc/event_details_bloc.dart';
import 'package:club_app/logic/models/event_model.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:club_app/ui/widgets/outline_border_button.dart';
import 'package:flutter/material.dart';
//import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventDetailsScreen extends StatefulWidget {
  EventDetailsScreen(this.eventModel);

  EventModel eventModel;

  @override
  _EventDetailsScreenState createState() =>
      _EventDetailsScreenState(eventModel);
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  _EventDetailsScreenState(this.eventModel);

  EventModel eventModel;
  EventDetailsBloc _eventDetailsBloc;
  bool _isloggedin = false;

  @override
  void initState() {
    super.initState();
    loginStatus();
    _eventDetailsBloc = EventDetailsBloc();
  }

  Future<void> loginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isloggedin = prefs.getBool('loginSuccess') ?? false;

      print("isloggedin $_isloggedin");
    });
  }

  @override
  void dispose() {
    _eventDetailsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        title: Text(eventModel.eventTitle),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                children: [
                  Container(
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                    child: eventModel.eventImage == null ||
                            eventModel.eventImage.isEmpty
                        ? Image.asset(
                            'assets/images/placeholder2.gif',
                            fit: BoxFit.fill,
                            alignment: Alignment.center,
                          )
                        : FadeInImage.assetNetwork(
                            placeholder: 'assets/images/event3.jpg',
                            image: eventModel.eventImage,
                            fadeInDuration: const Duration(milliseconds: 500),
                            fit: BoxFit.fill,
                            alignment: Alignment.center,
                          ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            'Details: ',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .apply(color: textColorDarkPrimary),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        // IconButton(
                        //   onPressed: () {
                        //     if (eventModel != null) {
                        //       String text = 'Hey,\n';
                        //       text += 'Club have event - ' +
                        //           eventModel.eventTitle +
                        //           ' \non ' +
                        //           getEventDisplayDate(
                        //               eventModel.eventStartDate) +
                        //           '\n';
                        //       text += 'Description: ' +
                        //           eventModel.eventLongDescription;
                        //       text += '\nEvent Image: ' + eventModel.eventImage;
                        //       final RenderBox box = context.findRenderObject();
                        //       Share.share(text,
                        //           subject: 'Share Events',
                        //           sharePositionOrigin:
                        //               box.localToGlobal(Offset.zero) &
                        //                   box.size);
                        //     }
                        //   },
                        //   icon: Icon(
                        //     Icons.share,
                        //     color: borderColor,
                        //   ),
                        // ),
                        const SizedBox(
                          width: 8,
                        ),
                        if (_isloggedin)
                          Container(
                            height: 40,
                            width: 100,
                            child: OutlineBorderButton(
                                buttonBackground,
                                0.0,
                                0.0,
                                "Guest List",
                                Theme.of(context).textTheme.subtitle2.apply(
                                    color: Colors.white), onPressed: () async {
                              AppNavigator.gotoGuestList(context);
                            }),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      eventModel.eventLongDescription,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .apply(color: textColorDarkPrimary),
                    ),
                  ),
                  /*Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1.0,
                      margin:
                          const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      color: detailsDividerColor,
                    ),*/
                  getEventArtist(context),
                  getContactDetails(context),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1.0,
              //margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
              color: detailsDividerColor,
            ),
            Container(
              color: cardBackgroundColor,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlineBorderButton(
                      buttonBackground,
                      12.0,
                      72.0,
                      ClubApp.btn_book,
                      Theme.of(context)
                          .textTheme
                          .subtitle1
                          .apply(color: Colors.white), onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    bool isloggedin = prefs.getBool('loginSuccess');
                    print("isloggedin $isloggedin");
                    if (isloggedin == true) {
                      AppNavigator.gotoBookEvent(context, eventModel);
                    } else {
                      AppNavigator.gotoLogin(context, "event", eventModel);
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getEventArtist(BuildContext context) {
    return eventModel.eventArtist != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Artist Details',
                      style: Theme.of(context).textTheme.subtitle1.apply(
                          color: textColorDarkPrimary, fontWeightDelta: 1),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /*Expanded(
                      flex: 2,
                      child: */
                          CircleAvatar(
                            backgroundImage: ExactAssetImage(
                                'assets/images/profile_placeholder.png'),
                            minRadius: 30,
                            maxRadius: 30,
                            child: FadeInImage.assetNetwork(
                              placeholder:
                                  'assets/images/profile_placeholder.png',
                              image: eventModel.eventArtist.artistImage,
                              fadeInDuration: const Duration(milliseconds: 500),
                              fit: BoxFit.fill,
                              alignment: Alignment.center,
                            ),
                          ),
                          //),
                          Container(
                            width: 1.0,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            color: detailsDividerColor,
                          ),
                          Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    eventModel.eventArtist.artistName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .apply(color: textColorDarkPrimary),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    eventModel.eventArtist.artistDescription,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .apply(color: textColorDarkSecondary),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1.0,
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                color: detailsDividerColor,
              ),
            ],
          )
        : Container();
  }

  Widget getContactDetails(BuildContext context) {
    return eventModel.eventContact != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Details',
                      style: Theme.of(context).textTheme.subtitle1.apply(
                          color: textColorDarkPrimary, fontWeightDelta: 1),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      eventModel.eventContact.contactEmail,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .apply(color: textColorDarkSecondary),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }
}
