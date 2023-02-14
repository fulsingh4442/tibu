import 'package:club_app/constants/strings.dart';

class AddOnResponse {
  AddOnResponse.fromJson(Map<String, dynamic> jsonMap) {
    status = jsonMap['status'];
    error = jsonMap['error'];
    addOnModelList = <AddOnModel>[];
    if (jsonMap['data'] != null) {
      for (Map<String, dynamic> json in jsonMap['data']) {
        addOnModelList.add(AddOnModel.fromJson(json));
      }
    }
  }

  bool status;
  String error;
  List<AddOnModel> addOnModelList;
}

class AddOnModel {
  AddOnModel(this.id, this.addOnType, this.description, this.imageLink,
      this.cost, this.currency, this.categoryId,
      {this.isAddedToCart = false});

  AddOnModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
//    addOnType = (json['id'] % 3 + 1);   ///  Just for now as we don't have type in api response
    String type = json['type'];
    if (type == null) {
      addOnType = 2;
    } else {
      switch (type.toLowerCase()) {
        case 'best sellers':
          addOnType = 1;
          break;
        case 'food':
          addOnType = 2;
          break;
        case 'drinks':
          addOnType = 3;
          break;
        default:
          addOnType = 1;
      }
    }
    name = json['name'];
    description = json['description'];
    imageLink = json['thumbnail'];
    cost = json['base_rate'];
    currency = ClubApp.currencyLbl;
    priority = json['priority'];
    isAddedToCart = false;
    categoryId = json['category_id'];
  }

  int id;
  int addOnType;
  String name;
  String description;
  String imageLink;
  int cost;
  String currency;
  bool isAddedToCart;
  int priority;
  String categoryId;
  int quantity = 0;
}
