class DefaultResponse {
  DefaultResponse(this.message, this.success);

  DefaultResponse.fromJson(Map jsonMap)
      : message = jsonMap['message'],
        success = jsonMap['success'];
  
  String message = '';
  bool success;

}
