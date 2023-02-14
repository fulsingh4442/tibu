import 'dart:async';

import 'package:club_app/constants/constants.dart';
import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/bloc/add_addon_to_cart_bloc.dart';
import 'package:club_app/logic/bloc/add_on_bloc.dart';
import 'package:club_app/logic/bloc/category_bloc.dart';
import 'package:club_app/logic/models/add_on_model.dart';
import 'package:club_app/logic/models/cart_table_event_model.dart';
import 'package:club_app/logic/models/category.dart';
import 'package:club_app/observer/add_on_observable.dart';
import 'package:club_app/observer/add_on_observer.dart';
import 'package:club_app/ui/utils/utility.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:club_app/ui/widgets/dialog_addons_dart.dart';

import '../select_branch.dart';

class AddOns extends StatefulWidget {
  @override
  _AddOnsState createState() => _AddOnsState();

}

class _AddOnsState extends State<AddOns> implements AddOnObserver {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AddOnsBloc _addOnsBloc;
  double totalAmount = 0.0;

  List<AddOnModel> addOnBestSellerList;
  List<AddOnModel> addOnFoodPackagesList;
  List<AddOnModel> addOnDrinksList;
  List<AddOnModel> cartAddOn;
  List<CategoryList> categoryList;
  var catId = "1";
  final CarouselController _bestSellerController = CarouselController();
  final CarouselController _foodPackagesController = CarouselController();
  final CarouselController _drinksController = CarouselController();
  AddOnObservable _addOnObservable;
  AddAddonToCartBloc _addAddonToCartBloc;
  CategoryBloc _categoryBloc;
  int addonID;

  @override
  void initState() {
    super.initState();
    if (sucasaSelected) {
      debugPrint("YAAAAAAAAA");
      catId = "1";
    }
    else
      {
          debugPrint("NAAAAAAAAA");
          catId = "5";
      }
    _addOnsBloc = AddOnsBloc();
    _addOnObservable = AddOnObservable();
    _addAddonToCartBloc = AddAddonToCartBloc();
    _addOnObservable.register(this);
    _categoryBloc = CategoryBloc();
    fetchAddOns();

    print("Add ons");
  }

  Future<void> fetchAddOns() async {
//    _addOnsBloc.fetchDummyAddOns();
    final bool isInternetAvailable = await isNetworkAvailable();
    if (isInternetAvailable) {
      _categoryBloc.isLoadingController.add(true);
      await _addOnsBloc.fetchTableCartList();
      print("AAAAAAAAAAAAAAA fetchTableCartList Done");
      await _addOnsBloc.fetchAddOns();
      print("AAAAAAAAAAAAAAA fetchAddOns Done");
      await _categoryBloc.getCategory(context).then((value) => {
      catId = _categoryBloc.categoryList.first.id,
      print("AAAAAAAAAAAAAAA getCategory in Done")
      });
      print("AAAAAAAAAAAAAAA getCategory Done");
      // Timer(Duration(seconds: 0), () {
      //   print("Callingverewrewrew");
      //
      // });

      setState(() {

      });
      print("AAAAAAAAAAAAAAA All Done");

    } else {

      ackAlert(context, ClubApp.no_internet_message);
    }
  }

  @override
  void dispose() {
    _addOnsBloc.dispose();
    _addOnObservable.unRegister(this);
    _categoryBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _categoryBloc.isLoadingController.stream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          bool isLoading = false;
          if (snapshot.hasData) {
            isLoading = snapshot.data;
          }

          return ModalProgressHUD(
            inAsyncCall: isLoading,
            //color: dividerColor,
            progressIndicator: const CircularProgressIndicator(
              backgroundColor: dividerColor,
            ),
            child: _categoryBloc.categoryList.length > 0
                ? DefaultTabController(
                    initialIndex: 0,
                    length: _categoryBloc.categoryList.length,
                    child: Scaffold(
                      key: _scaffoldKey,
                      backgroundColor: appBackgroundColor,
                      appBar: AppBar(
                        title: const Text('Add On Packages'),
                        leading: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(56.0),
                          child: TabBar(
                            isScrollable: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            unselectedLabelColor: Colors.white.withOpacity(0.3),
                            indicatorColor: Colors.white,
                            onTap: (value) {
                              catId =
                                  _categoryBloc.categoryList[value].id ?? "";
                            },
                            tabs: List<Widget>.generate(
                                _categoryBloc.categoryList.length, (int index) {
                              return Tab(
                                child: Text(
                                  _categoryBloc.categoryList[index].name,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      body: SafeArea(
                        child: StreamBuilder<bool>(
                          stream: _addOnsBloc.loaderController.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
                            bool isLoading = false;
                            if (snapshot.hasData) {
                              isLoading = snapshot.data;
                            }

                            return ModalProgressHUD(
                              inAsyncCall: false,
                              //color: dividerColor,
                              progressIndicator:
                                  const CircularProgressIndicator(
                                backgroundColor: dividerColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TabBarView(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      children: List<Widget>.generate(
                                          _categoryBloc.categoryList.length,
                                          (int index) {
                                        return getBestSeller();
                                      }),
                                    ),
                                  ),
                                  getBottomView(context),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : Container(
                   // child: Text("No addons available"),
                  ),
          );
        });
  }

  Widget getBottomView(context) {
    return Container(
      color: transparentBlack,
//      color: Colors.grey.withAlpha(75),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: (() {
              AppNavigator.gotoTableCart(
                  context, _addOnsBloc.tableCart, _addOnsBloc.eventCart);
            }),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.90,
              decoration: BoxDecoration(
                  color: colorAccent,
                  border: Border.all(
                    color: colorAccent,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    ClubApp.btn_go_cart,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .apply(color: buttonBackground),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getBestSeller() {
    return StreamBuilder<AddOnState>(
      stream: _addOnsBloc.addOnListController.stream,
      builder: (BuildContext context, AsyncSnapshot<AddOnState> snapshot) {
        //debugPrint('In aad ons list controller stream builder ');
        if (snapshot.hasError || !snapshot.hasData) {
          // debugPrint(
          //     'In aad ons list controller snapshot has error or has not data ');
          print("iterator is $addOnBestSellerList");
          Container();
        }

        // if (snapshot.data == AddOnState.NoData) {
        //   debugPrint('In aad ons list controller snapshot no data ');
        //   return Center(
        //     child: Text(
        //       'No Data',
        //       style: Theme.of(context)
        //           .textTheme
        //           .subtitle2
        //           .apply(color: textColorDarkPrimary),
        //     ),
        //   );
        // }

        if (addOnBestSellerList == null) {
          addOnBestSellerList = <AddOnModel>[];
        } else {
          addOnBestSellerList.clear();
        }

        addOnBestSellerList.addAll(_addOnsBloc.addOnList);

        print("addOnBestSellerList  ${catId}");
        addOnBestSellerList = addOnBestSellerList

            .where((element) => element.categoryId == catId)
            .toList();

        if (addOnBestSellerList.length > 0) {


          return ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: addOnBestSellerList.length,

              separatorBuilder: (context, itemIndex) =>
                  Divider(height: 1, color: dividerColor),
              itemBuilder: (context, itemIndex) {
                return packageAdd(addOnBestSellerList[itemIndex]);
              });
        }
        else {
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

  Widget getFoodPackages() {
    return StreamBuilder<AddOnState>(
      stream: _addOnsBloc.addOnListController.stream,
      builder: (BuildContext context, AsyncSnapshot<AddOnState> snapshot) {
        //debugPrint('In oad ons list controller stream builder ');
        if (snapshot.hasError || !snapshot.hasData) {
          debugPrint(
              'In oad ons list controller snapshot has error or has not data ');
          return Container();
        }
        if (snapshot.data == AddOnState.NoData) {
          debugPrint('In oad ons list controller snapshot no data ');
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

        if (addOnFoodPackagesList == null) {
          addOnFoodPackagesList = <AddOnModel>[];
        } else {
          addOnFoodPackagesList.clear();
        }
        for (int i = 0; i < _addOnsBloc.addOnList.length; i++) {
          if (_addOnsBloc.addOnList[i].addOnType == 2) {
            addOnFoodPackagesList.add(_addOnsBloc.addOnList[i]);
          }
        }
        if (addOnFoodPackagesList.length > 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: addOnFoodPackagesList.length,
                separatorBuilder: (context, itemIndex) =>
                    Divider(height: 1, color: dividerColor),
                itemBuilder: (context, itemIndex) {
                  return packageAdd(addOnFoodPackagesList[itemIndex]);
                }),

            // CarouselSlider.builder(
            //   carouselController: _foodPackagesController,
            //   options: CarouselOptions(
            //     height: MediaQuery.of(context).size.height,
            //     autoPlay: false,
            //     scrollPhysics: NeverScrollableScrollPhysics(),
            //     viewportFraction: 1.0,
            //     enlargeCenterPage: false,
            //   ),
            //   itemCount: addOnFoodPackagesList.length,
            //   itemBuilder: (BuildContext context, int itemIndex) => Column(
            //     //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Padding(
            //         padding:
            //             const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceAround,
            //           children: [
            //             InkWell(
            //               onTap: () {
            //                 _foodPackagesController.previousPage();
            //               },
            //               child: Icon(
            //                 Icons.arrow_back_ios,
            //                 color: textColorDarkPrimary,
            //                 size: 40,
            //               ),
            //             ),
            //             const SizedBox(
            //               width: 16,
            //             ),
            //             Expanded(
            //               child: Container(
            //                 color: Colors.green,
            //                 height: 200,
            //                 child: addOnFoodPackagesList[itemIndex].imageLink ==
            //                             null ||
            //                         addOnFoodPackagesList[itemIndex]
            //                             .imageLink
            //                             .isEmpty
            //                     ? Image.asset(
            //                         'assets/images/placeholder.png',
            //                         fit: BoxFit.fill,
            //                         alignment: Alignment.center,
            //                       )
            //                     : FadeInImage.assetNetwork(
            //                         placeholder:
            //                             'assets/images/placeholder.png',
            //                         image: addOnFoodPackagesList[itemIndex]
            //                             .imageLink,
            //                         fadeInDuration:
            //                             const Duration(milliseconds: 300),
            //                         fit: BoxFit.fill,
            //                         alignment: Alignment.center,
            //                       ),
            //               ),
            //             ),
            //             const SizedBox(
            //               width: 16,
            //             ),
            //             InkWell(
            //               onTap: () {
            //                 _foodPackagesController.nextPage();
            //               },
            //               child: Icon(
            //                 Icons.arrow_forward_ios,
            //                 color: textColorDarkPrimary,
            //                 size: 40,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       const SizedBox(
            //         height: 16,
            //       ),
            //       Text(
            //         addOnFoodPackagesList[itemIndex].name,
            //         style: Theme.of(context)
            //             .textTheme
            //             .subtitle1
            //             .apply(color: textColorDarkPrimary, fontWeightDelta: 1),
            //       ),
            //       const SizedBox(
            //         height: 16,
            //       ),
            //       Text(
            //         'Price: ${ClubApp.currencyLbl} ${addOnFoodPackagesList[itemIndex].cost}',
            //         style: Theme.of(context).textTheme.subtitle1.apply(
            //               color: textColorDarkPrimary,
            //             ),
            //       ),
            //       const SizedBox(
            //         height: 16,
            //       ),
            //     ],
            //   ),
            // ),
          );
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

  Widget getDrinks() {
    return StreamBuilder<AddOnState>(
      stream: _addOnsBloc.addOnListController.stream,
      builder: (BuildContext context, AsyncSnapshot<AddOnState> snapshot) {
        debugPrint('In oad ons list controller stream builder ');
        if (snapshot.hasError || !snapshot.hasData) {
          debugPrint(
              'In oad ons list controller snapshot has error or has not data ');
          return Container();
        }
        if (snapshot.data == AddOnState.NoData) {
          debugPrint('In oad ons list controller snapshot no data ');
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

        if (addOnDrinksList == null) {
          addOnDrinksList = <AddOnModel>[];
        } else {
          addOnDrinksList.clear();
        }
        for (int i = 0; i < _addOnsBloc.addOnList.length; i++) {
          if (_addOnsBloc.addOnList[i].addOnType == 3) {
            addOnDrinksList.add(_addOnsBloc.addOnList[i]);
          }
        }
        if (addOnDrinksList.length > 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: addOnDrinksList.length,
                separatorBuilder: (context, itemIndex) =>
                    Divider(height: 1, color: dividerColor),
                itemBuilder: (context, itemIndex) {
                  return packageAdd(addOnDrinksList[itemIndex]);
                }),
          );
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

  @override
  void removeAddOn(int addOnId, int tableId) {
    for (int i = 0; i < _addOnsBloc.addOnList.length; i++) {
      if (_addOnsBloc.addOnList[i].id == addOnId) {
        bool isPresent = false;
        int presentCount = 0;
        for (int j = 0; j < _addOnsBloc.tableCart.length; j++) {
          if (_addOnsBloc.tableCart[j].addons
              .contains(_addOnsBloc.addOnList[i])) {
            debugPrint(
                'Add On is Present in carts ${_addOnsBloc.addOnList[i].isAddedToCart}');
            presentCount++;
          }
        }
        if (presentCount > 1) {
          isPresent = true;
        }
        setState(() {
          _addOnsBloc.addOnList[i].isAddedToCart = isPresent;
          totalAmount -= _addOnsBloc.addOnList[i].cost;
          debugPrint(
              'Add On is Present ${_addOnsBloc.addOnList[i].isAddedToCart}');
          _addOnsBloc.addOnListController.add(AddOnState.ListRetrieved);
        });
        break;
      }
    }
  }

  Widget packageAdd(AddOnModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 120,
            child: model.imageLink == null || model.imageLink.isEmpty
                ? Image.asset(
                    'assets/images/placeholder2.gif',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  )
                : FadeInImage.assetNetwork(
                    placeholder: 'assets/images/placeholder2-extra-small.gif',
                    placeholderFit: BoxFit.none,
                    image: model.imageLink,
                    //fadeInDuration: const Duration(milliseconds: 300),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,

                  ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .apply(color: colorSecondaryText, fontWeightDelta: 1),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  model.description,
                  maxLines: 3,
                  style: Theme.of(context).textTheme.subtitle2.apply(
                      overflow: TextOverflow.ellipsis,
                      color: colorPrimaryText,
                      fontWeightDelta: 1),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${ClubApp.currencyLbl}" + model.cost.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          .apply(color: colorPrimaryText, fontWeightDelta: 1),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          border: Border.all(color: colorAccent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(children: [
                        GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              //padding: const EdgeInsets.all(5.0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                              child: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onTap: () {
                            if (model.quantity > 0) {
                              setState(() {
                                model.quantity -= 1;
                                if (model.quantity == 0) {
                                  model.isAddedToCart = false ;
                                }
                                // totalAmount -= model.rate;
                                // model.remaining++;
                              });
                              //
                              if (model.quantity == 0)
                                {
                                  _addOnsBloc.deleteAddonFromList(model.id, context);
                                }
                              else
                                {
                                  _addOnsBloc.updateAddon(model.id, model.quantity, context);
                                }
                            }
                            else {
                              setState(() {
                                model.isAddedToCart = false ;
                              });
                            }
                          },
                        ),
                        SizedBox(width: 15),
                        Text(
                          '${model.quantity.toString()}',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .apply(color: textColorDarkPrimary),
                        ),
                        SizedBox(width: 15),
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              model.quantity += 1;
                              _addOnsBloc.updateAddon(model.id, model.quantity, context);
                            });

                          },
                        ),
                        SizedBox(width: 10),
                      ]),
                    ),
                    SizedBox(width: 15),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: InkWell(
                        onTap: () {
                          print("Tapped ${_addOnsBloc.tableCart.isNotEmpty ||
                              _addOnsBloc.eventCart.isNotEmpty}");

                          if (model.quantity > 0) {
                            if (_addOnsBloc.tableCart.isNotEmpty ||
                                _addOnsBloc.eventCart.isNotEmpty) {
                              bool isClaimed = model.isAddedToCart;
                              print("added to card: ${model.isAddedToCart}");
                              if (isClaimed) {
                                for (TableCartModel blocTableModel
                                    in _addOnsBloc.tableCart) {
                                  print("called from btn $blocTableModel");
                                  if (blocTableModel.addons.contains(model)) {
                                    debugPrint(
                                        'Add on food package contains in ${blocTableModel.tableName}');
                                    blocTableModel.addons.remove(model);
                                    totalAmount -= model.cost;
                                  }
                                }
                                setState(() {
                                  model.isAddedToCart = !isClaimed;
                                  model.quantity = 0;
                                });
                                _addOnsBloc.deleteAddonFromList(model.id, context);
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AddOnDialog(
                                        tables: _addOnsBloc.tableCart,
                                        events: _addOnsBloc.eventCart,
                                        selectedTables: const <
                                            TableCartModel>[],
                                        selectedEvents: const <
                                            EventCartModel>[],
                                        onSelectedTablesChanged:
                                            (List<TableCartModel> tables) {},
                                      );
                                    }).then((value) {
                                  print(value);
                                  dynamic tables = value["table"];
                                  dynamic events = value["events"];
                                  if (tables.length > 0 && tables != null) {
                                    String tableUnitIds = "";
                                    if ((tables as List<TableCartModel>)
                                        .isNotEmpty) {
                                      for (final TableCartModel tableModel
                                          in tables) {
                                        for (TableCartModel blocTableModel
                                            in _addOnsBloc.tableCart) {
                                          if (tableModel.id ==
                                              blocTableModel.id) {
                                            if (tableUnitIds == "") {
                                              tableUnitIds =
                                                  blocTableModel.id.toString();
                                            } else {
                                              tableUnitIds =
                                                  "$tableUnitIds,${blocTableModel.id}";
                                            }

                                            setState(() {
                                              addonID = model.id;
                                            });

                                            break;
                                          }
                                        }
                                      }
                                      setState(() {
                                        model.isAddedToCart = !isClaimed;
                                      });
                                    } else {
                                      Utility.showSnackBarMessage(_scaffoldKey,
                                          'Please select at least one table');
                                    }

                                    _addOnsBloc.addAddon(addonID,
                                        tableUnitIds, model.quantity, "table", context);
                                   // _addAddonToCartBloc.addAddon(addonID,
                                   //     tableUnitIds, model.quantity, "table", context);
                                  }
                                  if (events.length > 0) {
                                    String eventUnitIds = "";
                                    if ((events as List<EventCartModel>)
                                        .isNotEmpty) {
                                      for (final EventCartModel eventCartModel
                                          in events) {
                                        print(
                                            "eventCartModel ${eventCartModel.id}");

                                        for (EventCartModel blocEventModel
                                            in _addOnsBloc.eventCart) {
                                          print(
                                              "blocEventModel ${blocEventModel.id}");
                                          if (eventCartModel.eventId ==
                                              blocEventModel.eventId) {
                                            if (eventUnitIds == "") {
                                              eventUnitIds =
                                                  blocEventModel.id.toString();
                                            } else {
                                              eventUnitIds = eventUnitIds +
                                                  "," +
                                                  blocEventModel.id.toString();
                                            }

                                            setState(() {
                                              addonID = model.id;
                                            });

                                            break;
                                          }
                                        }
                                      }
                                      setState(() {
                                        model.isAddedToCart = !isClaimed;
                                      });
                                    } else {
                                      Utility.showSnackBarMessage(_scaffoldKey,
                                          'Please select at least one table');
                                    }

                                    _addOnsBloc.addAddon(addonID,
                                        eventUnitIds, model.quantity, "event", context);
                                  }
                                });
                              }
                            } else {
                              Utility.showSnackBarMessage(_scaffoldKey,
                                  'Please add table before adding add ons');
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 95,
                          decoration: BoxDecoration(
                              color: colorAccent,
                              border: Border.all(
                                color: colorAccent,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                model.isAddedToCart ? 'Remove' : 'Add',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .apply(color: buttonBackground),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // void addAddOnApi() {
  //
  // }
  //
  // void deleteAddOnApi() {
  //
  // }
  //
  // void updateQuantityOnApi(model) {
  //   _addOnsBloc.updateAddon(model.id, model.quantity, context).then((value) =>
  //
  //   );
  // }
}
