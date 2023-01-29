import 'package:flutter/material.dart';

//*************************************************************************************/
//************************************GenNotifier**************************************/
//*************************************************************************************/

/// This is a generic class that can be used to create a provider with multi states.
class GenState<T> {
  T? object;
  bool isloading;
  String? errorMsg;
  bool loadmore;
  GenState(
      {this.object,
      this.isloading = true,
      this.errorMsg,
      this.loadmore = false});

  /// This method is used to return the state of the provider.
  Widget when({
    required Widget Function(GenState<T> value) data,
    required Widget Function() loading,
    Widget Function(String msg)? error,
    Function(String? msg)? onError,
  }) {
    if (errorMsg != null) {
      if (onError == null) {
        return error!.call(errorMsg ?? "");
      } else {
        onError.call(errorMsg);
      }
    }
    if (isloading || object == null) {
      return loading();
    }

    return data(this);
  }
}
