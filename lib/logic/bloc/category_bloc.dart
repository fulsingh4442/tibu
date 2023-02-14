import 'dart:convert';
import 'dart:ffi';

import 'package:club_app/logic/models/category.dart';

import '../../repository/club_app_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';

import '../../ui/utils/utils.dart';


enum CategoryState { Busy, NoData, ListRetrieved }

class CategoryBloc {
   final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> isLoadingController = BehaviorSubject<bool>();
  BehaviorSubject<CategoryState> categoryListController =
      BehaviorSubject<CategoryState>();
  List<CategoryList> categoryList = <CategoryList>[];



  void dispose() {
    isLoadingController.close();
    categoryListController.close();
  }
  
   Future<Response> getCategory( BuildContext context) {
    debugPrint('in fetchCategory');
    isLoadingController.add(true);
   return  _repository.getCategory().then((Response response) {
      isLoadingController.add(false);
      debugPrint('Fetch Category response is ${json.decode(response.body)}');
      CategoryModel categoryModelResponse =
          CategoryModel.fromJson(json.decode(response.body));
      if (categoryModelResponse.status) {
        if (categoryModelResponse.data != null &&
            categoryModelResponse.data.isNotEmpty) {
          categoryList.clear();
          categoryList.addAll(categoryModelResponse.data);
          categoryListController.add(CategoryState.ListRetrieved);
        } else {
          categoryListController.add(CategoryState.NoData);
        }
      } else {
        ackAlert(context, categoryModelResponse.error);
      }
    }).catchError((Object error) {
      print(error.toString());
      isLoadingController.add(false);
    });
  }

}