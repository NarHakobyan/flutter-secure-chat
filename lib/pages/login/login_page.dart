import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:pedantic/pedantic.dart';
import 'package:secure_chat/constants/app_theme.dart';
import 'package:secure_chat/helpers/keyboard_helper.dart';
import 'package:secure_chat/helpers/toast_helper.dart';
import 'package:secure_chat/models/user/user.dart';
import 'package:secure_chat/routes.dart';
import 'package:secure_chat/store/auth/auth_state.dart';
import 'package:secure_chat/store/form_group/form_group_state.dart';
import 'package:secure_chat/store/loading/loading_state.dart';
import 'package:secure_chat/store/login/login_state.dart';
import 'package:secure_chat/widget/clip_shadow_path.dart';
import 'package:secure_chat/widget/green_clipper.dart';

final _log = Logger('LoginPage');

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginState loginState = LoginState();
  final FormGroupState formState = FormGroupState();
  final LoadingState loadingState = LoadingState();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final AuthState authState = GetIt.I<AuthState>();
  final Dio dio = GetIt.I<Dio>();
  final Router router = GetIt.I<Router>();

  Future<void> _loginHandler(BuildContext context) async {
    final FormBuilderState form = _fbKey.currentState;

    if (!form.validate()) {
      formState.setAutoValidate(autoValidate: true);
      return;
    }

    form.save();

    try {
      unawaited(KeyboardHelper.hideKeyboard());
      loadingState.startLoading();

      authState.setCurrentUser(User(firstName: 'Narek', lastName: 'Hakobyan'));

      await router.navigateTo(
        context,
        Routes.rooms,
        clearStack: true,
        transition: TransitionType.native,
      );
    } on DioError catch (e) {
      final String message = e.response?.data['message'];
      await ToastHelper.showErrorToast(message);
    } finally {
      loadingState.stopLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    buildGradientClipPath(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/logo-white.png',
                          width: 400,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: <Widget>[
                              _buildForm(context),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          unselectedWidgetColor: Colors.white,
                                        ),
                                        child: Observer(
                                          builder: (BuildContext context) {
                                            return Checkbox(
                                              activeColor: Colors.white,
                                              checkColor:
                                                  AppColors.primaryColor,
                                              value: loginState.rememberMe,
                                              onChanged: (bool rememberMe) {
                                                loginState.setRememberMe(
                                                  rememberMe: rememberMe,
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            loginState.setRememberMe(
                                              rememberMe:
                                                  !loginState.rememberMe,
                                            );
                                          });
                                        },
                                        child: const Text(
                                          'Remember Me',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  FlatButton(
                                    onPressed: () => _log.info('pressed'),
                                    child: const Text(
                                      'Forgot password?',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              RaisedButton(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                onPressed: () => _loginHandler(context),
                                elevation: 0,
                                child: Text(
                                  'Sign In'.toUpperCase(),
                                  style: const TextStyle(
                                    color: Color(0xFF83A4D4),
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: <InlineSpan>[
                      const TextSpan(text: 'Don’t have an account? '),
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            router.navigateTo(
                              context,
                              Routes.register,
                            );
                          },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ClipShadowPath buildGradientClipPath() {
    return ClipShadowPath(
      clipper: GreenClipper(),
      shadow: Shadow(blurRadius: 5, color: Colors.grey),
      child: Container(
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: const <double>[0, 0.2, 1],
            colors: const <Color>[
              // Colors are easy thanks to Flutter's Colors class.
              Color(0xFF7196CD),
              Color(0xFF83A4D4),
              Color(0xFFA1D7ED),
            ],
          ),
        ),
      ),
    );
  }

  Observer _buildForm(BuildContext context) {
    _log.info('repaint _buildForm');
    final FormBuilderTextField emailField = formBuilderTextField(
      attribute: 'email',
      hintText: 'Email',
      validators: <FormFieldValidator<dynamic>>[
        FormBuilderValidators.email(),
        FormBuilderValidators.required(),
      ],
    );
    final FormBuilderTextField passwordField = formBuilderTextField(
      attribute: 'password',
      hintText: 'Password',
      obscureText: true,
      validators: <FormFieldValidator<dynamic>>[
        FormBuilderValidators.minLength(6),
        FormBuilderValidators.required(),
      ],
    );

    return Observer(
      builder: (BuildContext context) {
        return FormBuilder(
          key: _fbKey,
          autovalidate: formState.autoValidate,
          child: Column(
            children: <Widget>[
              emailField,
              passwordField,
            ],
          ),
        );
      },
    );
  }

  FormBuilderTextField formBuilderTextField(
      {@required String attribute,
      @required String hintText,
      bool obscureText = false,
      Color color = Colors.white,
      List<FormFieldValidator<dynamic>> validators}) {
    return FormBuilderTextField(
      attribute: attribute,
      cursorColor: color,
      style: TextStyle(color: color),
      decoration: InputDecoration(
        hintText: hintText,
        border: const UnderlineInputBorder(),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color.withOpacity(0.2),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFA1D7ED),
          ),
        ),
        hintStyle: TextStyle(fontWeight: FontWeight.w400, color: color),
      ),
      obscureText: obscureText,
      validators: validators,
    );
  }
}
