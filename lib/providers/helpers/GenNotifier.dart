import 'package:hooks_riverpod/hooks_riverpod.dart';

//*************************************************************************************/
//************************************GenNotifier**************************************/
//*************************************************************************************/
/// this notifier will notfiy the widget tree when the state changes
class GenNotifier<T> extends StateNotifier<T> {
  Function(GenNotifier<T>) getData;
  T? cState;
  GenNotifier(T newsState, this.getData) : super(newsState) {
    cState = newsState;
    getData(this);
  }

  void setState(T newstate) {
    cState = newstate;
    if (mounted) {
      state = newstate;
    }
  }
}
