// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:club_app/constants/constants.dart';
import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/bloc/landing_bloc.dart';
import 'package:club_app/observer/user_profile_observable.dart';
import 'package:club_app/observer/user_profile_observer.dart';
import 'package:club_app/ui/screens/bidding.dart';
import 'package:club_app/ui/screens/events.dart';
import 'package:club_app/ui/screens/login.dart';
import 'package:club_app/ui/screens/select_branch.dart';
import 'package:club_app/ui/screens/table/table_cart.dart';
import 'package:club_app/ui/screens/table/table_new.dart';
import 'package:club_app/ui/utils/push_notification_manager.dart';
import 'package:club_app/ui/utils/size_config.dart';
import 'package:club_app/ui/utils/utility.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:barcode_scan/barcode_scan.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with RouteAware
    implements UserProfileObserver {
  int _currentIndex = 0;
  String title = 'Table';
  bool _isloggedin = false;
  bool oncartpress = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String photo = '';

  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  LandingBloc _landingBloc;
  UserProfileObservable _userProfileObservable;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> loginStatus() async {
    print(BASE_URL);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isloggedin = prefs.getBool('loginSuccess') ?? false;
      photo = prefs.getString('photo') ?? '';
      print("isloggedin $_isloggedin");
    });
  }

  Future<void> photos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      photo = prefs.getString('photo') ?? '';
  }
  @override
  void dispose() {

    print("DISPOSEBAG");
    //routeObserver.unsubscribe(this);
    _landingBloc.dispose();
    _userProfileObservable.unRegister(this);
    super.dispose();
  }

  @override
  void didPush() {
    print("PUSH");
    debugPrint('In Navigator did push of Landing');
  }

  @override
  void didPopNext() {
    print("POP");
    debugPrint('In Navigator did pop next of Landing');
  }

  final List<Widget> _children1 = <Widget>[

    TableNewScreen(),
    EventsScreen(),
    TableCart(true),
  ];

  final List<Widget> _children2 = <Widget>[

    TableNewScreen(),
    LoginScreen("Events"),
    // BiddingScreen(),
    LoginScreen("cart"),
  ];

  Widget _buildBottomNavigationBar(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: colorPrimary,
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          //primaryColor: Colors.red,
          // sets the inactive color of the `BottomNavigationBar`
          /*textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.yellow),
              ),*/
        ),
        child: BottomNavigationBar(
          backgroundColor: bottomNavigationBackground,
          selectedItemColor: navigationItemSelectedColor,
          unselectedItemColor: navigationItemUnSelectedColor,
          selectedFontSize: 12,
          unselectedFontSize: 10,

          showUnselectedLabels: true,
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          // this will be set when a new tab is tapped
          items: [

            // BottomNavigationBarItem(
            //   icon: Icon(Icons.local_activity),
            //   title: const Text('Vouchers'),
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_bar),
              label: 'Table',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Events',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Menu',
            )
          ],
        ),
      );

  void _onTabTapped(int index) {
    if (index != 3) {
      setState(() {
        switch (index) {
          case 0:
            title = 'Table';
            break;
          case 1:
            title = 'Events';
            break;
          case 3:
            title = 'Cart';
            setState(() {
              oncartpress = true;
            });
            break;
        }
        _currentIndex = index;
      });
    } else {

      _scaffoldKey.currentState.openEndDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      key: _scaffoldKey,
      drawerEdgeDragWidth: 0,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          //padding: const EdgeInsets.symmetric(horizontal: 16),
          child:
          Text(title),
        ),

        leadingWidth: sucasaSelected ? 100 : 80,
        leading: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Image.asset('assets/images/tibus.png',
            // sucasaSelected
            //
            //     ? 'assets/images/sucasa.png'
            //     : 'assets/images/Kenjin_logo.png',
            width: 24,
            height: 24,
          ),
        ),
        /*Center(
          child: Text(title),
        ),*/
        actions: <Widget>[
          Container(),
        ],
      ),
      endDrawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              margin: const EdgeInsets.all(0),
              decoration: BoxDecoration(color: drawerColor),
              child: Container(
                height: 250,
                color: drawerColor,
                child: InkWell(
                  onTap: () {
                    // Navigator.pop(context);
                    // AppNavigator.gotoProfileScreen(context);
                  },
                  child: Row(
                    children: [
                      Column(
                        children: [
                          StreamBuilder<String>(

                            stream: _landingBloc.userNameController.stream,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              String userName = '';
                              if (snapshot.hasData) {
                                userName = snapshot.data;
                              }

                              return Text(
                                _isloggedin == true ? userName : "",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold  ),


                                // style: Theme.of(context).textTheme.headline6
                              );
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(

                              child: _isloggedin == false
                                  ? CircleAvatar(
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/images/placeholder2.gif'),
                                    ),
                                  ),
                                ),
                                minRadius: 40,
                                maxRadius: 40,
                              )
                                  : photo == ''
                                  ?
                              CircleAvatar(
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/images/profile_placeholder.png'),
                                    ),
                                  ),
                                ),
                                minRadius: 40,
                                maxRadius: 40,
                              )
                                  : ClipOval(
                                child: FadeInImage.assetNetwork(
                                  placeholder:
                                  'assets/images/placeholder2.gif',
                                  image: photo,
                                  // fadeInDuration:
                                  //    const Duration(milliseconds: 500),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  height: 65,
                                  width: 65,
                                ),
                              )

                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          if (_isloggedin == true)
                          // Row(
                          //   children: <Widget>[
                          //     StreamBuilder<int>(
                          //       stream: _landingBloc
                          //           .loyaltyPointsController.stream,
                          //       builder: (BuildContext context,
                          //           AsyncSnapshot<int> snapshot) {
                          //         int loyaltyPoints = 0;
                          //         if (snapshot.hasData) {
                          //           loyaltyPoints = snapshot.data;
                          //         }
                          //         return Text(loyaltyPoints.toString(),
                          //             style: Theme.of(context)
                          //                 .textTheme
                          //                 .subtitle1);
                          //       },
                          //     ),
                          //     SizedBox(width: 5),
                          //     // Icon(
                          //     //   Icons.star_border_outlined,
                          //     //   size: 20,
                          //     // )
                          //   ],
                          // ),
                            SizedBox(
                              height: 10,
                            ),
                          if (_isloggedin == true)
                            Row(
                              children: <Widget>[
                                // StreamBuilder<String>(
                                //   stream:
                                //       _landingBloc.loyaltyNameController.stream,
                                //   builder: (BuildContext context,
                                //       AsyncSnapshot<String> snapshot) {
                                //     String membershipStatus = "";
                                //     if (snapshot.hasData) {
                                //       membershipStatus = snapshot.data;
                                //     }
                                //     return Text(membershipStatus.toString(),
                                //         style: Theme.of(context)
                                //             .textTheme
                                //             .subtitle1);
                                //   },
                                // ),
                                SizedBox(width: 10),
                              ],
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_isloggedin == true)
                            Row(
                              children: <Widget>[
                                // StreamBuilder<String>(
                                //   stream: _landingBloc
                                //       .memberShipTypeController.stream,
                                //   builder: (BuildContext context,
                                //       AsyncSnapshot<String> snapshot) {
                                //     String membershipStatus = "";
                                //     if (snapshot.hasData) {
                                //       membershipStatus = snapshot.data;
                                //     }
                                //     return Text(membershipStatus.toString(),
                                //         style: Theme.of(context)
                                //             .textTheme
                                //             .subtitle1);
                                //   },
                                // ),
                                // SizedBox(width: 10),
                              ],
                            )
                        ],
                      ),
                      // if (_isloggedin == true)
                      //   StreamBuilder<String>(
                      //     stream: _landingBloc.QRCodeController.stream,
                      //     builder: (BuildContext context,
                      //         AsyncSnapshot<String> snapshot) {
                      //       String qrCode = "";
                      //       if (snapshot.hasData) {
                      //         qrCode = snapshot.data;
                      //       }
                      //       return SizedBox(
                      //         height: 68,
                      //         width: 65,
                      //         child: Image(image: NetworkImage(qrCode)),
                      //       );
                      //     },
                      //   ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(padding: EdgeInsets.zero, children: <Widget>[
                if (_isloggedin == true)
                  ListTile(
                    title: Text('Settings',
                        style: Theme.of(context).textTheme.subtitle2),
                    leading: const Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      AppNavigator.gotoProfileScreen(context);
                    },
                  ),
                // ListTile(
                //   title: Text('Notifications',
                //       style: Theme.of(context).textTheme.subtitle2),
                //   leading: const Icon(
                //     Icons.notifications,getUserDetails
                //     color: Colors.black,
                //   ),
                //   onTap: () {
                //     /*List<NotificationModel> notificationList =
                //           <NotificationModel>[];
                //       NotificationModel notificationModel1 = NotificationModel(
                //           id: '1',
                //           title: 'Notification 1',
                //           subTitle: 'This is notification 1 subtitle');
                //       NotificationModel notificationModel2 = NotificationModel(
                //           id: '2',
                //           title: 'Notification 2',
                //           subTitle: 'This is notification 2 subtitle');
                //       NotificationModel notificationModel3 = NotificationModel(
                //           id: '3',
                //           title: 'Notification 3',
                //           subTitle: 'This is notification 3 subtitle');
                //       NotificationModel notificationModel4 = NotificationModel(
                //           id: '4',
                //           title: 'Notification 4',
                //           subTitle: 'This is notification 4 subtitle');
                //       notificationList.add(notificationModel1);
                //       notificationList.add(notificationModel2);
                //       notificationList.add(notificationModel3);
                //       notificationList.add(notificationModel4);*/
                //     Navigator.pop(context);
                //     AppNavigator.gotoNotification(context);
                //   },
                // ),
                ListTile(
                  title: Text('Help',
                      style: Theme.of(context).textTheme.subtitle2),
                  leading: Icon(
                    Icons.help,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Bookings',
                      style: Theme.of(context).textTheme.subtitle2),
                  leading: Icon(
                    Icons.star,
                    color: Colors.black,
                  ),
                  onTap: () {
                    if (_isloggedin == true) {
                      Navigator.pop(context);
                      AppNavigator.gotoBookings(context);
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen("enddrawer")));
                    }
                  },
                ),
                // if (_isloggedin == true)
                //   ListTile(
                //     title: Text('Submit Guest List',
                //         style: Theme.of(context).textTheme.subtitle2),
                //     leading: Icon(
                //       Icons.person,
                //       color: Colors.black,
                //     ),
                //     onTap: () {
                //       if (_isloggedin == true) {
                //         Navigator.pop(context);
                //         AppNavigator.gotoGuestList(context);
                //       } else {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) =>
                //                     LoginScreen("enddrawer")));
                //       }
                //     },
                //   ),
                // ListTile(
                //   title: Text('Select Venue',
                //       style: Theme.of(context).textTheme.subtitle2),
                //   leading: Icon(
                //     Icons.home_work_sharp,
                //     color: Colors.black,
                //   ),
                //   onTap: () {
                //     AppNavigator.gotoSelectVenue(context);
                //   },
                // ),
                FutureBuilder<bool>(
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData && snapshot.data) {
                      return ListTile(
                        title: Text('Scan Code',
                            style: Theme.of(context).textTheme.subtitle2),
                        leading: Icon(
                          Icons.settings_overscan,
                          color: Colors.black,
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          // await scan();
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                  // future: _checkUserType(),
                ),
              ]),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: OutlinedButton(
                onPressed: () async {
                  if (_isloggedin == true) {
                    final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    prefs.setBool(ClubApp.loginSuccess, false);
                    //await _landingBloc.registerDeregisterToken(false);
                    //prefs.setString(ClubApp.token, null);
                    // SystemNavigator.pop();
                    AppNavigator.gotoLanding(context);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen("sidemenu")));
                  }
                },
                style: OutlinedButton.styleFrom(
                  onSurface: unClaimButtonColor,
                ),
                child: Text(_isloggedin == true ? 'Logout' : 'SignIn',
                    style: Theme.of(context).textTheme.subtitle2),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      body: SafeArea(
        child: StreamBuilder<bool>(
          stream: _landingBloc.loaderController,
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
              dismissible: false,
              child: IndexedStack(
                index: _currentIndex,
                children: _isloggedin == true ? _children1 : _children2,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Future<void> initState() {
    super.initState();
    loginStatus();
    _landingBloc = LandingBloc();
    _userProfileObservable = UserProfileObservable();
    _userProfileObservable.register(this);
    _landingBloc.getUserDetails(ClubApp.userId, context);
    // PushNotificationsManager pushNotificationsManager =
    //     PushNotificationsManager();
    // pushNotificationsManager.init().then((String token) {
    //   if (token != null) {
    //     _landingBloc.registerDeregisterToken(true);
    //   }
    // });
  }

  @override
  Future<void> updateUserName(String name) async {
    print("NNNNNNNNNNNNNNNNNN");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      photo = prefs.getString('photo') ?? '';
    });
    _landingBloc.userNameController.add(name);
  }
}
