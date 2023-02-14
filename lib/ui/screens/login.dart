import 'dart:convert';

import 'package:club_app/constants/constants.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/constants/validator.dart';
import 'package:club_app/logic/bloc/login_bloc.dart';
import 'package:club_app/logic/models/event_model.dart';
import 'package:club_app/ui/screens/landing.dart';
import 'package:club_app/ui/screens/select_branch.dart';
import 'package:club_app/ui/screens/sign_up.dart';
import 'package:club_app/ui/utils/utility.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:club_app/ui/widgets/button_rounded_border.dart';
import 'package:club_app/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';

// Class allows user to access the system by providing valid login credentials
class LoginScreen extends StatefulWidget {
  String type;
  EventModel eventModel;
  LoginScreen(this.type, {this.eventModel});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isRememberPassword = true;
  bool _isPasswordVisible = true;
  final GlobalKey _formKey = GlobalKey<FormState>();
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  LoginBloc _loginBloc;
  bool _autoValidate = false;
  // static final FacebookLogin facebookSignIn = FacebookLogin();

//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: <String>[
//       'email',
//       /*'https://www.googleapis.com/auth/user.addresses.read',
//       'https://www.googleapis.com/auth/user.birthday.read',*/
// //      'https://www.googleapis.com/auth/user.gender.read'
// //      'https://www.googleapis.com/auth/user.phonenumbers.read'
//       //'https://people.googleapis.com/v1/people/{userId}?personFields=genders,birthdays'
//     ],
//   );
  // GoogleSignInAccount _currentUser;
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc();
    _loginBloc.autoValidateController.add(_autoValidate);
    _loginBloc.visibleController.add(_isPasswordVisible);

    // _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
    //   setState(() {
    //     _currentUser = account;
    //   });
    //   if (_currentUser != null) {
    //     _handleGetContact();
    //   }
    // });
    // _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact() async {
    final http.Response response = await http.get(Uri(
      path: 'https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names',
      // headers: await _currentUser.authHeaders,
    ));
    if (response.statusCode != 200) {
      debugPrint("People API gave a ${response.statusCode} "
          "response. Check logs for details.");
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        debugPrint("I see you know $namedContact!");
      } else {
        debugPrint("No contacts to display.");
      }
    });
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  // Future<void> _handleSignIn() async {
  //   final bool isInternetAvailable = await isNetworkAvailable();
  //   if (isInternetAvailable) {
  //     try {
  //       debugPrint('inside handle sign in');
  //       await _googleSignIn.signIn();
  //       debugPrint('Your email address ' + _googleSignIn.currentUser.email);
  //       debugPrint('Your name ' + _googleSignIn.currentUser.displayName);

  //       String email = _googleSignIn.currentUser.email.trim();
  //       String name = _googleSignIn.currentUser.displayName.trim();
  //       String firstName = name;
  //       String lastName = '';
  //       List<String> nameArray = name.split(' ');
  //       if (nameArray.length > 1) {
  //         firstName = nameArray[0];
  //         lastName = '';
  //         for (int i = 1; i < nameArray.length; i++) {
  //           lastName = lastName + ' ' + nameArray[i];
  //         }
  //       }
  //       _loginBloc.loginGoogleUser(email, firstName, lastName, context);
  //     } catch (error) {
  //       print(error);
  //     }
  //   } else {
  //     ackAlert(context, ClubApp.no_internet_message);
  //   }
  // }

  // Future<Null> _handleFacebookLogin() async {
  //   final bool isInternetAvailable = await isNetworkAvailable();
  //   if (isInternetAvailable) {
  //     final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

  //     switch (result.status) {
  //       case FacebookLoginStatus.loggedIn:
  //         final FacebookAccessToken accessToken = result.accessToken;

  //         final graphResponse = await http.get(
  //             'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}');
  //         final Map<String, dynamic> profile = json.decode(graphResponse.body);

  //         debugPrint('''
  //        Logged in!

  //        Token: ${accessToken.token}
  //        User id: ${accessToken.userId}
  //        Expires: ${accessToken.expires}
  //        Permissions: ${accessToken.permissions}
  //        Declined permissions: ${accessToken.declinedPermissions}
  //        profile details $profile
  //        ''');

  //         String firstName = profile['first_name'];
  //         String lastName = profile['last_name'];
  //         String email = profile['email'];
  //         _loginBloc.loginGoogleUser(email, firstName, lastName, context);

  //         break;
  //       case FacebookLoginStatus.cancelledByUser:
  //         debugPrint('Login cancelled by the user.');
  //         break;
  //       case FacebookLoginStatus.error:
  //         debugPrint('Something went wrong with the login process.\n'
  //             'Here\'s the error Facebook gave us: ${result.errorMessage}');
  //         break;
  //     }
  //   } else {
  //     ackAlert(context, ClubApp.no_internet_message);
  //   }
  // }

  @override
  void dispose() {
    _loginBloc.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget getAppLogo() {
      return Container(
        child: Image.asset('assets/images/tibus.png',
          // sucasaSelected
          //     ? 'assets/images/sucasa.png'
          //     : 'assets/images/Kenjin_logo.png',
          //  color: Colors.white,
          fit: BoxFit.fill,
          alignment: Alignment.bottomCenter,
          width: 100,
          // height: 60,
        ),
      );
    }

    Widget cardLogin() {
      return ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              /*Card(
                margin: const EdgeInsets.all(16.0),
                color: Colors.black.withAlpha(99),
                elevation: 0.0,
                child: */
              Container(
//              height: 245,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    getAppLogo(),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomTextField(
                      emailController,
                      _autoValidate,
                      TextInputType.emailAddress,
                      Theme.of(context)
                          .textTheme
                          .bodyText2
                          .apply(color: colorPrimaryText),
                      ClubApp.hint_user_name,
                      validator: (String text) {
                        return Validator.validateEmail(text);
                      },
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    StreamBuilder<bool>(
                        stream: _loginBloc.visibleStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> snapshot) {
                          if (snapshot.hasData) {
                            _isPasswordVisible = snapshot.data;
                          }

                          return TextFormField(
                            controller: passwordController,
                            autovalidateMode: _autoValidate
                                ? AutovalidateMode.always
                                : AutovalidateMode.disabled,
                            cursorColor: colorPrimaryText,
                            validator: (String value) {
                              if (value == '' && value.isEmpty) {
                                return ClubApp.password_empty_msg;
                              } else {
                                return null;
                              }
                            },
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .apply(color: colorPrimaryText),
                            autofocus: false,
                            // visibility of password according to flag selected.
                            obscureText: _isPasswordVisible,
                            maxLines: 1,
                            decoration: InputDecoration(
                              labelText: ClubApp.hint_password,
                              suffixIcon: IconButton(
                                iconSize: 22,
                                color: colorPrimaryText,
                                icon: _isPasswordVisible
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                                onPressed: () {
                                  _isPasswordVisible = !_isPasswordVisible;
                                  _loginBloc.visibleController
                                      .add(_isPasswordVisible);
                                },
                              ),
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .apply(color: colorPrimaryText),
                              contentPadding: const EdgeInsets.only(
                                  left: 5.0,
                                  top: 10.0,
                                  right: 0.0,
                                  bottom: 5.0),
                              focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red,
                                      style: BorderStyle.solid),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red,
                                      style: BorderStyle.solid),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: colorPrimaryText,
                                      style: BorderStyle.solid),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: colorPrimaryText,
                                      style: BorderStyle.solid),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                            ),
                          );
                        }),
                    const SizedBox(
                      height: 24.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        RoundedButton(
                            buttonBackground,
                            12.0,
                            72.0,
                            ClubApp.sign_in,
                            Theme.of(context).textTheme.subtitle1.apply(
                                color: Colors.white), onPressed: () async {
                          final FormState form = _formKey.currentState;
                          if (form.validate()) {
                            final bool isInternetAvailable =
                                await isNetworkAvailable();
                            if (isInternetAvailable) {
                              final String username =
                                  emailController.text.toLowerCase();
                              final String password = passwordController.text;
                              _loginBloc.loginUser(username, password,
                                  widget.type, widget.eventModel, context);
                            } else {
                              ackAlert(context, ClubApp.no_internet_message);
                            }
                          } else {
                            _loginBloc.autoValidateController.add(true);
                            /*setState(() {
                          _autoValidate = true;
                        });*/
                          }
                        }),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding:
                              const EdgeInsets.only(top: 16.0, bottom: 8.0),
                          child: GestureDetector(
                            child: Text(
                              ClubApp.forget_password,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .apply(color: colorPrimaryText),
                            ),
                            onTap: () {
                              TextEditingController emailController =
                                  TextEditingController();
                              showDialog(
                                context: _scaffoldKey.currentContext,
                                barrierColor: Colors.black87,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: backgroundColor,
//                                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                    title: const Text(
                                      'Forgot Password',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomTextField(
                                          emailController,
                                          true,
                                          TextInputType.emailAddress,
                                          Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .apply(color: colorPrimaryText),
                                          ClubApp.hint_user_name,
                                          validator: (String text) {
                                            return Validator.validateEmail(
                                                text);
                                          },
                                        ),
                                        const SizedBox(
                                          height: 16.0,
                                        ),
                                        RoundedButton(
                                            buttonBackground,
                                            12.0,
                                            72.0,
                                            ClubApp.btn_submit,
                                            Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                .apply(color: Colors.white),
                                            onPressed: () async {
                                          String emailValidation =
                                              Validator.validateEmail(
                                                  emailController.text.trim());
                                          if (emailValidation == null) {
                                            final bool isInternetAvailable =
                                                await isNetworkAvailable();
                                            if (isInternetAvailable) {
                                              Navigator.of(context).pop();
                                              final String username =
                                                  emailController.text
                                                      .toLowerCase();
                                              _loginBloc.forgetPassword(
                                                  username,
                                                  _scaffoldKey.currentContext);
                                            } else {
                                              ackAlert(context,
                                                  ClubApp.no_internet_message);
                                            }
                                          } else {
//                                            Utility.showSnackBarMessage(_scaffoldKey, emailValidation);
                                          }
                                        }),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //),
              //const SizedBox(height: 8,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: <Widget>[
              //     Text(
              //       ClubApp.label_or,
              //       style: Theme.of(context)
              //           .textTheme
              //           .bodyText2
              //           .apply(color: colorPrimaryText),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 16.0,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: <Widget>[
              //     GestureDetector(
              //       child: CircleAvatar(
              //         child: Image.asset(
              //           'assets/images/google_plus.png',
              //           height: 24,
              //           width: 24,
              //           color: Colors.red,
              //         ),
              //         backgroundColor: colorPrimaryText,
              //         radius: 28,
              //       ),
              //       onTap: () {
              //         _handleSignIn();
              //       },
              //     ),
              //     const SizedBox(
              //       width: 16.0,
              //     ),
              //     /*GestureDetector(
              //       child: CircleAvatar(
              //         child: Image.asset(
              //           'assets/images/instagram.png',
              //           height: 24,
              //           width: 24,
              //         ),
              //         backgroundColor: colorPrimaryText,
              //         radius: 28,
              //       ),
              //       onTap: () {},
              //     ),
              //     const SizedBox(
              //       width: 16.0,
              //     ),*/
              //     GestureDetector(
              //       child: CircleAvatar(
              //         child: Image.asset(
              //           'assets/images/facebook.png',
              //           height: 24,
              //           width: 24,
              //           color: Colors.blue,
              //         ),
              //         backgroundColor: colorPrimaryText,
              //         radius: 28,
              //       ),
              //       onTap: () {
              //         _handleFacebookLogin();
              //       },
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 16.0,
              // ),
              Container(
                margin: const EdgeInsets.all(1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      child: Text(
                          '${ClubApp.label_dont_have_account} ${ClubApp.label_sign_up}',
                          style: TextStyle(color: colorPrimaryText)),
                      onPressed: () {
                        final Route<SignUp> route = MaterialPageRoute<SignUp>(
                            builder: (BuildContext context) => SignUp());
                        Navigator.push(context, route);
                      },
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: widget.type == "Events" ||
              widget.type == "cart"

          ? AppBar(
              toolbarHeight: 0,
            )
          : AppBar(
              // title: Text('Cart'),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: StreamBuilder<bool>(
          stream: _loginBloc.loaderController.stream,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            bool isLoading = false;
            if (snapshot.hasData) {
              isLoading = snapshot.data;
            }
            return ModalProgressHUD(
              inAsyncCall: isLoading,
              color: Colors.black,
              progressIndicator: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
              dismissible: false,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: transparentBlack,
                  ),
                  Center(
                      child: StreamBuilder<bool>(
                          stream: _loginBloc.autoValidateController.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
                            if (snapshot.hasData) {
                              _autoValidate = snapshot.data;
                            }
                            return Form(
                              key: _formKey,
                              autovalidateMode: _autoValidate
                                  ? AutovalidateMode.always
                                  : AutovalidateMode.disabled,
                              child: cardLogin(),
                            );
                          })),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
