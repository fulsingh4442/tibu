import 'package:club_app/observer/add_on_observer.dart';
import 'package:club_app/observer/observable.dart';

class AddOnObservable implements Observable<AddOnObserver> {
  static List<AddOnObserver> addOnObserverList = <AddOnObserver>[];

  @override
  void register(AddOnObserver observer) {
    if (!addOnObserverList.contains(observer)) {
      addOnObserverList.add(observer);
    }
  }

  @override
  void unRegister(AddOnObserver observer) {
    if (addOnObserverList.contains(observer)) {
      addOnObserverList.remove(observer);
    }
  }

  void notifyRemoveAddOn(int addOnId, int tableId) {
    for (AddOnObserver observer in addOnObserverList) {
      observer.removeAddOn(addOnId, tableId);
    }
  }
}
