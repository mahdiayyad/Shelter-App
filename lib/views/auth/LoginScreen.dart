import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shelter/Core/managers/NavgationManager.dart';
import 'package:shelter/Core/managers/Session.dart';
import 'package:shelter/Core/managers/SharedPreferencesManager.dart';
import 'package:shelter/generated/locale_keys.g.dart';
import 'package:shelter/router/AppRouter.gr.dart';
import 'package:shelter/style/AssetsKeys.dart';
import 'package:shelter/style/Style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shelter/views/common/CommonWidgets.dart';
import 'package:shelter/views/common/ImageLoader.dart';

//*************************************************************************************/
//**************************************LoginScreen************************************/
//*************************************************************************************/

/// this is the _auth for the login form from firebase
final _auth = FirebaseAuth.instance;

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// this is the _formKey for the login form
    final _formKey = GlobalKey<FormBuilderState>();

    /// this is the email field inside the form
    final emailField = FormBuilderTextField(
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return (LocaleKeys.enter_your_email.tr());
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return (LocaleKeys.enter_valid_email.tr());
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: Style.inputDecoration(context).copyWith(
        prefixIcon: Icon(Icons.mail),
        hintText: LocaleKeys.email.tr(),
      ),
      name: 'email',
    );

    /// this is the password field inside the form
    final passwordField = FormBuilderTextField(
      autofocus: false,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{8,}$');
        if (value!.isEmpty) {
          return (LocaleKeys.passwordRequired.tr());
        }
        if (!regex.hasMatch(value)) {
          return (LocaleKeys.passwordMin_8Char.tr());
        }
      },
      textInputAction: TextInputAction.done,
      decoration: Style.inputDecoration(context).copyWith(
        prefixIcon: Icon(Icons.vpn_key),
        hintText: LocaleKeys.password.tr(),
      ),
      name: 'password',
    );

    /// this is the login button that matches the email and password exists in the database
    final loginButton = CommonButton(
      text: LocaleKeys.login.tr(),
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          _formKey.currentState?.save();
          String email = _formKey.currentState?.value['email'];
          String password = _formKey.currentState?.value['password'];
          signIn(email, password);
        }
      },
    );

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Style.secondary),
            onPressed: () {
              navgationManager.pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  ImageLoader(
                    path: ImageAssets.logo,
                    fit: BoxFit.contain,
                    height: 150,
                    width: 150,
                  ),
                  SizedBox(height: 10),
                  Text(
                    LocaleKeys.login.tr(),
                    style: Style.getFont(context).button,
                  ),
                  SizedBox(height: 45),
                  emailField,
                  SizedBox(height: 25),
                  passwordField,
                  SizedBox(height: 35),
                  loginButton,
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(LocaleKeys.dontHaveAcc.tr()),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          navgationManager.navigatePush(const SelectionRoute());
                        },
                        child: Text(
                          LocaleKeys.signup.tr(),
                          style: Style.getFont(context).button?.copyWith(
                                color: Style.secondary,
                              ),
                        ),
                      )
                    ],
                  ),
                  TextButton(
                    child: Text(LocaleKeys.forget_password.tr()),
                    onPressed: () {
                      navgationManager.navigatePush(ResetRoute());
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

/// sign in with [email] and [password]
void signIn(String email, String password) async {
  await _auth
      .signInWithEmailAndPassword(email: email, password: password)
      .then((uid) async => {
            await getUserType(uid.user?.uid),
            Fluttertoast.showToast(msg: LocaleKeys.loginSuccessful.tr()),
            navgationManager.navigatePush(HomeRoute())
          })
      .catchError((e) {
    Fluttertoast.showToast(msg: e!.message);
  });
}

/// get user type using the [id]
Future getUserType(String? uid) async {
  EasyLoading.show(status: LocaleKeys.loading.tr());
  return await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((value) {
    var usert = EnumToString.fromString<UserType>(
            UserType.values, value.data()?['userType']) ??
        UserType.customer;
    SharedPreferencesManager().setUserType(usert);
    EasyLoading.dismiss();
  });
}
