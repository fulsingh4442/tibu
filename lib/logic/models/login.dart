class LoginResponse {
  LoginResponse.fromJson(Map jsonMap) {
    status = jsonMap['status'];
    error = jsonMap['error'];
    if (jsonMap['data'] != null) {
      userDetails = UserDetails.fromJson(jsonMap['data']);
    }
  }

  bool status;
  String error;
  UserDetails userDetails;
}

class UserDetails {
  UserDetails();

  UserDetails.fromJson(Map<String, dynamic> json) {
    userId = json['id'];
    username = json['first_name'];
    lastName = json['last_name'];
    staff = json['staff'];
    gender = json['gender'];
    // role = json['role'];
//    nationality = json['nationality'];
    //phone = json['phone'];
    email = json['email'];
    status = json['status'];
    accessKey = json['access_key'];
    photo = json['photo'];
  }

  int userId;
  String username;
  String lastName;
  String email;
  int role;
  String status;
  String gender;
  String staff;
  String token;
  String accessKey;
  String photo;
}
