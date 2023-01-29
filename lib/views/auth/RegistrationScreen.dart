import 'package:easy_localization/easy_localization.dart';
// import 'package:encrypt/encrypt.dart' as eq;
import 'package:shelter/generated/locale_keys.g.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';

import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:shelter/Core/managers/NavgationManager.dart';
import 'package:shelter/Core/managers/Session.dart';
import 'package:shelter/router/AppRouter.gr.dart';
import 'package:shelter/style/AssetsKeys.dart';
import 'package:shelter/style/Style.dart';
import 'package:shelter/views/common/CommonWidgets.dart';
import 'package:shelter/views/common/ImageLoader.dart';
import 'package:shelter/views/common/common_ui.dart';
import 'package:shelter/views/common/form_builder_map_field.dart';

//*************************************************************************************/
//**************************************RegistrationScreen*****************************/
//*************************************************************************************/

/// this is the _auth for the registration form from firebase
final _auth = FirebaseAuth.instance;

/// this is the _formKey for the login form
final _formKey = GlobalKey<FormBuilderState>();

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final passwordEditingController = TextEditingController();
    // this is the name field inside the form
    final nameField = FormBuilderTextField(
      keyboardType: TextInputType.name,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(context,
            errorText: LocaleKeys.nameNotEmpty.tr()),
        FormBuilderValidators.minLength(context, 3,
            errorText: LocaleKeys.enter_valid_name.tr()),
      ]),
      textInputAction: TextInputAction.next,
      decoration: Style.inputDecoration(context).copyWith(
        prefixIcon: Icon(Icons.account_circle),
        hintText: LocaleKeys.name.tr(),
      ),
      name: 'name',
    );

    // this is the phone number field inside the form only for [store] and [clinic]
    final phoneNumberField = FormBuilderPhoneField(
      keyboardType: TextInputType.phone,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(context,
            errorText: LocaleKeys.phoneNumberNotEmpty.tr()),
      ]),
      textInputAction: TextInputAction.next,
      decoration: Style.inputDecoration(context).copyWith(
        // prefixIcon: Icon(Icons.account_circle),
        hintText: LocaleKeys.pNumber.tr(),
      ),
      name: 'phoneNumber',
    );

    // this is the location field inside the form only for [store] and clinic
    final locationField = FormBuilderLocationField(
      valueTransformer: (value) {
        return value?.target.toJson();
      },
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(context,
            errorText: LocaleKeys.locationNotEmpty.tr()),
      ]),
      decoration: Style.inputDecoration(context).copyWith(
        prefixIcon: Icon(Icons.pin_drop),
        hintText: LocaleKeys.location.tr(),
      ),
      name: 'location',
    );

    // this is email field inside the form
    final emailField = FormBuilderTextField(
      keyboardType: TextInputType.emailAddress,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(context,
            errorText: LocaleKeys.enter_your_email.tr()),
        FormBuilderValidators.email(
          context,
          errorText: LocaleKeys.enter_valid_email.tr(),
        ),
      ]),
      textInputAction: TextInputAction.next,
      decoration: Style.inputDecoration(context).copyWith(
        prefixIcon: Icon(Icons.mail),
        hintText: LocaleKeys.email.tr(),
      ),
      name: 'email',
    );

    // this is the description field inside the form only for [clinics]
    final descriptionField = FormBuilderTextField(
      keyboardType: TextInputType.name,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(context,
            errorText: LocaleKeys.description_not_empty.tr()),
        FormBuilderValidators.minLength(context, 3,
            errorText: LocaleKeys.enter_valid_description.tr()),
      ]),
      textInputAction: TextInputAction.next,
      decoration: Style.inputDecoration(context).copyWith(
        hintText: LocaleKeys.description.tr(),
      ),
      name: 'description',
    );
    // this is the password field inside the form
    final passwordField = FormBuilderTextField(
      obscureText: true,
      controller: passwordEditingController,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(context,
            errorText: LocaleKeys.passwordRequired.tr()),
        FormBuilderValidators.minLength(
          context,
          8,
          errorText: LocaleKeys.passwordMin_8Char.tr(),
        ),
      ]),
      textInputAction: TextInputAction.next,
      decoration: Style.inputDecoration(context).copyWith(
        prefixIcon: Icon(Icons.vpn_key),
        hintText: LocaleKeys.password.tr(),
      ),
      name: 'password',
    );

    // this is the confirmation password field inside the form 
    final confirmpasswordField = FormBuilderTextField(
      obscureText: true,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(context,
            errorText: LocaleKeys.passwordRequired.tr()),
        (value) {
          if (passwordEditingController.text != value) {
            return LocaleKeys.passwordWithNoMatch.tr();
          }
          return null;
        },
      ]),
      textInputAction: TextInputAction.done,
      decoration: Style.inputDecoration(context).copyWith(
        prefixIcon: Icon(Icons.vpn_key),
        hintText: LocaleKeys.cpassword.tr(),
      ),
      name: 'cpassword',
    );

    // this is the signup button that saves the data in the firebase database
    final signupButton = CommonButton(
      text: LocaleKeys.signup.tr(),
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          _formKey.currentState?.save();

          signup(_formKey.currentState?.value ?? {}, context);
        }
      },
    );

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonUi.appbar(context,
            title: LocaleKeys.signup.tr(), iconColor: Style.secondary),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ImageLoader(
                        fit: BoxFit.contain,
                        height: 150,
                        width: 150,
                        path: ImageAssets.logo),
                    SizedBox(height: 10),
                    Text(
                      LocaleKeys.signup.tr(),
                      style: Style.getFont(context).button,
                    ),
                    SizedBox(height: 45),
                    nameField,
                    SizedBox(height: 20),
                    emailField,
                    Session.userType != UserType.customer
                        ? Column(
                            children: [
                              SizedBox(height: 20),
                              phoneNumberField,
                              SizedBox(height: 20),
                              locationField,
                            ],
                          )
                        : Container(),
                        Session.userType == UserType.clinic ? Column(
                          children: [
                            SizedBox(height: 20),
                              descriptionField,
                          ],
                        ) : Container(),
                    SizedBox(height: 20),
                    passwordField,
                    SizedBox(height: 20),
                    confirmpasswordField,
                    SizedBox(height: 20),
                    signupButton,
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text(LocaleKeys.already_have_an_account).tr(),
                          onPressed: () {
                            navgationManager.navigateRoot(LoginRoute());
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }


  /// signup with input using [email] and [password]
  void signup(Map<String, dynamic> input, BuildContext context) async {
    await _auth
        .createUserWithEmailAndPassword(
            email: input['email'], password: input['password'])
        .then((value) => {postDetailsToFirestore(input, context)})
        .catchError((e) {
      Fluttertoast.showToast(msg: e!.message);
    });
  }

  /// posting details into firebase firestore database
  postDetailsToFirestore(
      Map<String, dynamic> input, BuildContext context) async {
    EasyLoading.show(status: LocaleKeys.loading.tr());
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    
    Map<String, dynamic> temp = {};
    temp.addAll(input);
    temp.remove('cpassword');
    temp.remove('password');
    if (Session.userType != UserType.customer) {
      temp.addAll({"is_approved": false});
    }
    temp.addAll({'userType': EnumToString.convertToString(Session.userType)});
    await firebaseFirestore.collection("users").doc(user?.uid).set(temp);
    EasyLoading.dismiss();
    Fluttertoast.showToast(msg: LocaleKeys.account_success.tr());
    navgationManager.navigateReplace(LoginRoute());
  }
}