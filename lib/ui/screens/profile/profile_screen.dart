import 'dart:typed_data';

import 'package:club_app/constants/constants.dart';
import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/constants/validator.dart';
import 'package:club_app/logic/bloc/sign_up_bloc.dart';
import 'package:club_app/ui/screens/login.dart';
import 'package:club_app/ui/screens/select_branch.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:club_app/ui/widgets/button_rounded_border.dart';
import 'package:club_app/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/photo_selector.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  SignUpBloc _signUpBloc;
  XFile _pickedImg;

  @override
  void initState() {
    super.initState();
    _signUpBloc = SignUpBloc();
    handleProfileAPI();
  }

  Future<void> handleProfileAPI() async {
    final bool isInternetAvailable = await isNetworkAvailable();
    if (isInternetAvailable) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt(ClubApp.userId);
      _signUpBloc.getUserDetails(userId.toString(), context);
    } else {
      ackAlert(context, ClubApp.no_internet_message);
    }
  }

  @override
  void dispose() {
    _signUpBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget getAppLogo() {
      return Container(
        child: Image.asset(
          'assets/images/ic_launcher.png',
//          color: Colors.white,
//          fit: BoxFit.fill,
          width: 100,
          // height: 60,
        ),
      );
    }

    Future<void> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          helpText: ClubApp.hint_dob,
          initialDate: _signUpBloc.selectedDate,
          firstDate: DateTime(1950),
          lastDate: DateTime.now());
      if (picked != null && picked != _signUpBloc.selectedDate)
        setState(() {
          final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
          final String formatDate = dateFormat.format(picked);
          _signUpBloc.dobController.text = formatDate;
          _signUpBloc.selectedDate = picked;
        });
    }

    Widget cardProfileScreen() {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    child: Image.asset(
                      sucasaSelected
                          ? 'assets/images/sucasa.png'
                          : 'assets/images/Kenjin_logo.png',
                      //  color: Colors.white,
                      fit: BoxFit.fill,
                      alignment: Alignment.bottomCenter,
                      width: 100,
                      // height: 60,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),

                  Container(

                    child: GestureDetector(

                        onTap: () {
                          _pickedImage();
                        },
                        child: FutureBuilder(builder: (c,d){
                          return d.hasData ?UserProfilePic(
                            width: 75,
                            height: 75,
                            onCameraTap: () {},
                            onGalleryTap: () {},
                            data: d.data,
                          ) : UserProfilePic(
                            url: _signUpBloc.photoURL,
                            width: 75,
                            height: 75,
                            onCameraTap: () {},
                            onGalleryTap: () {},
                          );
                        },future: _pickedImg == null ? null :_pickedImg.readAsBytes(),)),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomTextField(
                    _signUpBloc.nameController,
                    _autoValidate,
                    TextInputType.text,
                    Theme.of(context)
                        .textTheme
                        .bodyText2
                        .apply(color: colorPrimaryText),
                    ClubApp.hint_name,
                    validator: (String text) {
                      if (text == '' && text.isEmpty) {
                        return ClubApp.name_empty_msg;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomTextField(
                    _signUpBloc.lastNameController,
                    _autoValidate,
                    TextInputType.text,
                    Theme.of(context)
                        .textTheme
                        .bodyText2
                        .apply(color: colorPrimaryText),
                    ClubApp.hint_last_name,
                    validator: (String text) {
                      if (text == '' && text.isEmpty) {
                        return ClubApp.last_name_empty_msg;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomTextField(
                    _signUpBloc.emailController,
                    _autoValidate,
                    TextInputType.emailAddress,
                    Theme.of(context)
                        .textTheme
                        .bodyText2
                        .apply(color: colorPrimaryText),
                    ClubApp.hint_email,
                    isEnabled: false,
                    validator: (String text) {
//                      return Validator.validateEmail(text);
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  /*CustomTextField(
                    _signUpBloc.passwordController,
                    _autoValidate,
                    TextInputType.text,
                    Theme.of(context)
                        .textTheme
                        .bodyText2
                        .apply(color: colorPrimaryText),
                    ClubApp.hint_password,
                    obscureText: true,
                    validator: (String text) {
                      if (text == '' && text.isEmpty) {
                        return ClubApp.password_empty_msg;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomTextField(
                    _signUpBloc.confirmPasswordController,
                    _autoValidate,
                    TextInputType.text,
                    Theme.of(context)
                        .textTheme
                        .bodyText2
                        .apply(color: colorPrimaryText),
                    ClubApp.hint_confirm_password,
                    validator: (String text) {
                      if (text == '' && text.isEmpty) {
                        return ClubApp.confirm_password_empty_msg;
                      } else if (text.trim() !=
                          _signUpBloc.passwordController.text.trim()) {
                        return ClubApp.password_un_match_msg;
                      } else {
                        return null;
                      }
                    },
                  ),*/
                  const SizedBox(
                    height: 10.0,
                  ),
                  /*InkWell(
                    onTap: () {
                      _selectDate(
                          context); // Call Function that has showDatePicker()
                    },
                    child: IgnorePointer(
                      child: CustomTextField(
                        _signUpBloc.dobController,
                        _autoValidate,
                        TextInputType.text,
                        Theme.of(context)
                            .textTheme
                            .bodyText2
                            .apply(color: colorPrimaryText),
                        ClubApp.hint_dob,
                        validator: (String text) {
                          if (text == '' && text.isEmpty) {
                            return ClubApp.dob_empty_msg;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),*/
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      ClubApp.hint_gender,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .apply(color: colorPrimaryText),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Theme(
                      data: ThemeData.dark(),
                      //set the dark theme or write your own theme
                      child: Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: _signUpBloc.genderValue,
                            onChanged: _handleGenderChanged,
                            activeColor: colorPrimaryText,
                            focusColor: colorPrimaryText,
                            hoverColor: colorPrimaryText,
                          ),
                          Text(
                            'Male',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .apply(color: colorPrimaryText),
                          ),
                          Radio(
                            value: 2,
                            groupValue: _signUpBloc.genderValue,
                            onChanged: _handleGenderChanged,
                            activeColor: colorPrimaryText,
                            focusColor: colorPrimaryText,
                            hoverColor: colorPrimaryText,
                          ),
                          Text(
                            'Female',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .apply(color: colorPrimaryText),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  // CustomTextField(
                  //   _signUpBloc.residenceController,
                  //   _autoValidate,
                  //   TextInputType.text,
                  //   Theme.of(context)
                  //       .textTheme
                  //       .bodyText2
                  //       .apply(color: colorPrimaryText),
                  //   ClubApp.hint_place_of_residence,
                  //   validator: (String text) {
                  //     /*if (text == '' && text.isEmpty) {
                  //       return ClubApp.por_empty_msg;
                  //     } else {
                  //       return null;
                  //     }*/
                  //     return null;
                  //   },
                  // ),
                  // const SizedBox(
                  //   height: 10.0,
                  // ),
                  CustomTextField(
                    _signUpBloc.mobileController,
                    _autoValidate,
                    TextInputType.numberWithOptions(signed: true),
                    Theme.of(context)
                        .textTheme
                        .bodyText2
                        .apply(color: colorPrimaryText),
                    ClubApp.hint_phone,
                    maxLength: 12,
                    isEnabled: _signUpBloc.isEnabled,
                    validator: (String text) {
                      if (_signUpBloc.isEnabled) {
                        if (text == '' && text.isEmpty) {
                          return null;
                        } else if (text.trim().length != 10 ||
                            text.trim().length != 12) {
                          return ClubApp.phone_valid_msg;
                        } else {
                          return null;
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  RoundedButton(
                      buttonBackground,
                      12.0,
                      72.0,
                      ClubApp.label_update_profile,
                      Theme.of(context)
                          .textTheme
                          .subtitle1
                          .apply(color: Colors.white), onPressed: () async {
                    final FormState form = _formKey.currentState;
                    if (form.validate()) {
                      final bool isInternetAvailable =
                          await isNetworkAvailable();
                      if (isInternetAvailable) {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        int userId = prefs.getInt(ClubApp.userId);

                        final String name =
                            _signUpBloc.nameController.text.trim();
                        final String lastName =
                        _signUpBloc.lastNameController.text.trim();
                        final String email =
                            _signUpBloc.emailController.text.trim();
                        final String password =
                            _signUpBloc.passwordController.text.trim();
                        final String confirmPassword =
                            _signUpBloc.confirmPasswordController.text.trim();
                        final String phone =
                            _signUpBloc.mobileController.text.trim();
                        final nationality =
                            _signUpBloc.residenceController.text.trim();
                        //final String address = addressController.text.trim();
                        String gender = '';

                        Uint8List imgData = Uint8List(0);
                        if (_pickedImg != null)
                        {
                          imgData = await _pickedImg.readAsBytes();
                        }
                        if (_signUpBloc.genderValue != -1) {
                          if (_signUpBloc.genderValue == 1) {
                            gender = 'Male';
                          } else {
                            gender = 'Female';
                          }
                        }
                        _signUpBloc.updateUserDetails(userId.toString(), name, lastName,
                            gender, nationality, phone, email, imgData, context);
                      } else {
                        ackAlert(context, ClubApp.no_internet_message);
                      }
                    } else {
                      setState(() {
                        _autoValidate = true;
                      });
                    }
                  }),
                ],
              )),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(ClubApp.label_update_profile),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: StreamBuilder<bool>(
            stream: _signUpBloc.loaderController.stream,
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
                      child: Form(
                        key: _formKey,
                        autovalidateMode: _autoValidate
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        child: cardProfileScreen(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _pickedImage() {
    showDialog<ImageSource>(
      context: context,
      builder: (context) =>
          AlertDialog(content: Text("Choose image source"), actions: [
            TextButton(
                child: Text('Camera'),
                onPressed: () {
                  Navigator.pop(context, ImageSource.camera);
                }),
            // FlatButton(
            //   child: Text("Camera"),
            //   onPressed: () => Navigator.pop(context, ImageSource.camera),
            // ),
            TextButton(
                child: Text('Gallery'),
                onPressed: () {
                  Navigator.pop(context, ImageSource.gallery);
                }),
            // FlatButton(
            //   child: Text("Gallery"),
            //   onPressed: () => Navigator.pop(context, ImageSource.gallery),
            // ),
          ]),
    ).then((ImageSource source) async {
      if (source != null) {
        try {
          print('in');
          final f = ImagePicker();
          final pickedFile = await f.pickImage(source: source);

          setState(() => _pickedImg = pickedFile);
        }catch(e){
          print('pick error $e');
        }
      }
    });
  }

  void _handleGenderChanged(int value) {
    setState(() {
      _signUpBloc.genderValue = value;
    });
  }
}
