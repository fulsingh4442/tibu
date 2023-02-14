class EventBookingModel {
  EventBookingModel(this.passId, this.passName, this.passDescription,
      this.passCost, this.selectedCount);

  int passId;
  String passName;
  String passDescription;
  double passCost;
  int selectedCount;
  int totalCount;
}
