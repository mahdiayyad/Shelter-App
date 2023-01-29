
/// Session saves the values that can be access from anywhere in the app
mixin Session {

  static late UserType userType;

}
enum UserType {
  customer,
  clinic,
  store,
}
