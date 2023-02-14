/// generic class used to register and unregister classes to implements observable interfaces so that they can get notify about latest data
class Observable<T> {
  void register(T observer) {}

  void unRegister(T observer) {}
}
