import 'package:club_app/constants/constants.dart';
import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/bloc/login_bloc.dart';
import 'package:club_app/logic/bloc/notifications_bloc.dart';
import 'package:club_app/logic/models/notifications.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:club_app/ui/widgets/outline_border_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SingingCharacter { sucasa, kenjin }

var sucasaSelected = true;
SingingCharacter _character = SingingCharacter.sucasa;
bool _isloggedin = false;

class SelectBranchScreen extends StatefulWidget {
  @override
  _SelectBranchScreenState createState() => _SelectBranchScreenState();
}

class _SelectBranchScreenState extends State<SelectBranchScreen> {
  LoginBloc _loginBloc;
  @override
  void initState() {
    // TODO: implement initState

    getdata();
    loginStatus();
    fetchBaseUrl();
    super.initState();
    _loginBloc = LoginBloc();
  }

  Future<void> loginStatus() async {
    print(BASE_URL);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isloggedin = prefs.getBool('loginSuccess');
      print("isloggedin $_isloggedin");
    });
  }

  Future<void> fetchBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    BASE_URL = prefs.getString(ClubApp.BASE_URLString);

    if (prefs.getString(ClubApp.BASE_URLString) == null) {
      //old BASE_URL = 'https://sucasa.bookbeach.club/api/';
      BASE_URL = 'https://sucasa.reserveyourvenue.com/api/';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        title: Text(ClubApp.selectVenue),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            alignment: Alignment.center,
            child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //sucasa
                  InkWell(
                    onTap: () {
                      setState(() {
                        sucasaSelected = true;
                        //old BASE_URL = 'https://sucasa.bookbeach.club/api/';
                        BASE_URL = 'https://sucasa.reserveyourvenue.com/api/';
                        if (_isloggedin == true) {
                          _loginBloc.profileAccess(context);
                          //AppNavigator.gotoLanding(context);
                        } else {
                          AppNavigator.gotoLanding(context);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: sucasaSelected
                                ? Colors.red
                                : Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      width: 200,
                      height: 200,
                      child: Image.asset("assets/images/sucasa2.jpg"),
                    ),
                  ),

                  SizedBox(
                    height: 60,
                  ),
                  //kenjin
                  InkWell(
                    onTap: () {
                      setState(() {
                        sucasaSelected = false;
                        //old BASE_URL = "https://kenjin.bookbeach.club/api/";
                        BASE_URL = "https://kenjin.reserveyourvenue.com/api/";
                        if (_isloggedin == true) {
                          _loginBloc.profileAccess(context);
                          //AppNavigator.gotoLanding(context);
                        } else {
                          AppNavigator.gotoLanding(context);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: !sucasaSelected
                                ? Colors.red
                                : Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      width: 200,
                      height: 200,
                      child: Image.asset("assets/images/Kenjin_logo1.jpeg"),
                    ),
                  ),
                ],
              ),

              // OutlineBorderButton(
              //     buttonBackground,
              //     12.0,
              //     50.0,
              //     "Launch",
              //     Theme.of(context)
              //         .textTheme
              //         .subtitle1, onPressed: () async {
              //   print(sucasaSelected);
              //   if (sucasaSelected == true) {
              //     BASE_URL = 'https://sucasa.bookbeach.club/api/';
              //   } else {
              //     BASE_URL = "https://kenjin.bookbeach.club/api/";
              //   }
              //   if (_isloggedin == true) {
              //     _loginBloc.profileAccess(context);
              //     //AppNavigator.gotoLanding(context);
              //   } else {
              //     AppNavigator.gotoLanding(context);
              //   }
              // })
          ),
        ),
      ),
    );
  }

  void getdata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessKey = prefs.getString(ClubApp.access_key);
    String email = prefs.getString(ClubApp.email);
    print(" accessKey $accessKey");
    print("email  $email");
  }
}
