import 'package:club_app/observer/observable.dart';
import 'package:club_app/observer/user_profile_observer.dart';

class UserProfileObservable implements Observable<UserProfileObserver>{
  static List<UserProfileObserver> userProfileObserverList = <UserProfileObserver>[];
  @override
  void register(UserProfileObserver observer) {
    if(!userProfileObserverList.contains(observer)){
      userProfileObserverList.add(observer);
    }
  }

  @override
  void unRegister(UserProfileObserver observer) {
    if(userProfileObserverList.contains(observer)){
      userProfileObserverList.remove(observer);
    }
  }

  void notifyUpdateUserName(String name){
    for(UserProfileObserver observer in userProfileObserverList){
      observer.updateUserName(name);
    }
  }

}