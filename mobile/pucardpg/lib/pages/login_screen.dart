import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_components/widgets/atoms/digit_toaster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pucardpg/blocs/app-localization-bloc/app_localization.dart';
import 'package:pucardpg/blocs/auth-bloc/authbloc.dart';
import 'package:pucardpg/mixin/app_mixin.dart';
import 'package:pucardpg/model/advocate-clerk-registration-model/advocate_clerk_registration_model.dart';
import 'package:pucardpg/model/advocate-registration-model/advocate_registration_model.dart';
import 'package:pucardpg/model/litigant-registration-model/litigant_registration_model.dart';
import '../utils/i18_key_constants.dart' as i18;
import 'package:pucardpg/routes/routes.dart';
import 'package:pucardpg/utils/constants.dart';
import 'package:pucardpg/utils/i18_key_constants.dart';

import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class LoginNumberScreen extends StatefulWidget with AppMixin {
  LoginNumberScreen({super.key});

  @override
  LoginNumberScreenState createState() => LoginNumberScreenState();
}

class LoginNumberScreenState extends State<LoginNumberScreen> {
  bool isSubmitting = false;
  String mobileNumberKey = 'mobileNumber';

  TextEditingController searchController = TextEditingController();

  int _counter = 0;
  late StreamController<int> _events;

  @override
  void initState() {
    super.initState();
    _getStoragePermission();
    _events = StreamController<int>.broadcast();
    _events.add(25);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _events.close();
    super.dispose();
  }

  Timer? _timer;
  void _startTimer() {
    _counter = 25;
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //setState(() {
      (_counter > 0) ? _counter-- : _timer!.cancel();
      //});
      print(_counter);
      _events.add(_counter);
    });
  }

  bool _validateMobile(String value) {
    final RegExp mobileRegex =
    RegExp(r'^[6789][0-9]{9}$', caseSensitive: false);
    return mobileRegex.hasMatch(value);
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future _getStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    _handleLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 90,
                      ),
                      Image.asset(
                        govtIndia,
                        height: 100,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate(i18.login.csSignInProvideMobileNumber),
                        textAlign: TextAlign.center,
                        style: widget.theme.text32W700RobCon(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate(i18.login.csWelcome),
                        style: widget.theme.text14W400Rob(),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ReactiveFormBuilder(
                          form: buildForm,
                          builder: (context, form, child) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                DigitTextFormField(
                                  label: AppLocalizations.of(context)
                                      .translate(i18.login.coreCommonPhoneNumber),
                                  prefixIcon: Container(
                                    margin: const EdgeInsets.only(left: 1, right: 8),
                                    padding: EdgeInsets.zero,
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFFAFAFA),
                                        border: Border(right: BorderSide(width: 1), )
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 11,
                                          left: 10,
                                          bottom: 11,
                                          right: 0),
                                      child: Text(
                                        "+91  ",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: DigitTheme.instance.colorScheme.onBackground,
                                        ),
                                      ),
                                    ),
                                  ),
                                  formControlName: mobileNumberKey,
                                  isRequired: true,
                                  maxLength: 10,
                                  onChanged: (val) {
                                    context.read<AuthBloc>().userModel.mobileNumber = val.value.toString();
                                  },
                                  keyboardType: TextInputType.number,
                                  validationMessages: {
                                    'required': (_) => 'Mobile number is required',
                                    'number': (_) =>
                                    'Mobile number should contain digits 0-9',
                                    'minLength': (_) =>
                                    'Mobile number should have 10 digits',
                                    'maxLength': (_) =>
                                    'Mobile number should have 10 digits',
                                    'pattern': (_) => 'Invalid Mobile Number'
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                ),
                                BlocListener<AuthBloc, AuthState>(
                                  bloc: context.read<AuthBloc>(),
                                  listener: (context, state) {
                                    state.maybeWhen(
                                      orElse: (){},
                                      requestOtpFailed: (error){
                                        isSubmitting = false;
                                        widget.theme.showDigitDialog(
                                            true,
                                            error,
                                            context);
                                      },
                                      otpGenerationSucceed: (type){
                                        isSubmitting = false;
                                        context.read<AuthBloc>().userModel.type = type;
                                        if (context.read<AuthBloc>().userModel.type == "login") {
                                          _startTimer();
                                          showOtpDialog();
                                        }
                                      },

                                    );
                                  },
                                  child: DigitElevatedButton(
                                      onPressed: isSubmitting
                                          ? null
                                          : () {
                                        FocusScope.of(context).unfocus();
                                        form.markAllAsTouched();
                                        if (!form.valid) return;
                                        bool isValidNumber = _validateMobile(
                                            form
                                                .control(mobileNumberKey)
                                                .value);
                                        if (!isValidNumber) {
                                          widget.theme.showDigitDialog(
                                              true,
                                              "Mobile Number is not valid",
                                              context);

                                          return;
                                        }
                                        isSubmitting = true;
                                        context.read<AuthBloc>().add(
                                            AuthEvent.requestOtp(context.read<AuthBloc>().userModel.mobileNumber!, appConstants.login)
                                        );
                                      },
                                      child: Text(
                                          AppLocalizations.of(context)
                                              .translate(i18.login.csSignInNext))),
                                )
                              ],
                            );
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                          text: TextSpan(
                            style: widget.theme.text16W400Rob(),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                  AppLocalizations.of(context)
                                      .translate(i18.login.csRegisterAccount)),
                              TextSpan(
                                text: ' ${AppLocalizations.of(context)
                                    .translate(i18.login.csRegisterLink)}',
                                style:
                                TextStyle(fontWeight: FontWeight.bold, color: widget.theme.defaultColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    AutoRouter.of(context)
                                        .push(MobileNumberRoute());
                                  },
                              ),
                            ],
                          )
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: RichText(
                  text: TextSpan(
                    style: widget.theme.text14W400Rob(),
                    children: const <TextSpan>[
                      TextSpan(
                          text:
                          "Powered by"),
                      TextSpan(
                        text: ' DRISTI',
                        style:
                        TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
              ),
            )
          ],
        )
    );
  }

  FormGroup buildForm() => fb.group(<String, Object>{
    mobileNumberKey: FormControl<String>(
        value: context.read<AuthBloc>().userModel.mobileNumber,
        validators: [
          Validators.required,
          Validators.number,
          Validators.minLength(10),
          Validators.maxLength(10),
          Validators.pattern(r'^[6789][0-9]{9}$')
        ]),
  });

  showOtpDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
          final List<TextEditingController> _otpControllers =
          List.generate(6, (index) => TextEditingController());
          bool isSubmit = false;
          return AlertDialog(
            titlePadding: EdgeInsets.only(left: 20),
            title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 38,
                        width: 38,
                        decoration: const BoxDecoration(
                          color: Color(0XFF505A5F),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.close),
                          color: Colors.white,
                          onPressed: () {
                            isSubmitting = false;
                            _timer?.cancel();
                            _events.close();
                            _events = StreamController<int>.broadcast();
                            _events.add(25);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10, top: 10),
                        child: Text(
                          AppLocalizations.of(context).translate(
                            i18.registerMobile.csVerifyMobile),
                          style: widget.theme.text24W700(),
                        ),
                      ),
                    ],
                  ),
                ]
            ),
            actionsPadding: const EdgeInsets.only(left: 60, right: 60, bottom: 20),
            content: StreamBuilder<int>(
                stream: _events.stream,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${AppLocalizations.of(context).translate(
                                  i18.common.csLoginOtpText)} +91******${context.read<AuthBloc>().userModel
                                  .mobileNumber!.substring(6, 10)}",
                              style: widget.theme.text14W400Rob(),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            6,
                                (index) =>
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 2, right: 2, top: 20),
                                  child: SizedBox(
                                    width: 40,
                                    child: TextField(
                                      controller: _otpControllers[index],
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                      ],
                                      maxLength: 2,
                                      onChanged: (value) {
                                        if (value.length > 1) {
                                          _otpControllers[index].text =
                                              value.substring(0, 1);
                                          if (index <
                                              _otpControllers.length - 1) {
                                            _otpControllers[index + 1].text =
                                                value.substring(1, 2);
                                          }
                                        }
                                        if (value.length > 1 &&
                                            index < _otpControllers.length - 1) {
                                          FocusScope.of(context)
                                              .requestFocus(
                                              _focusNodes[index + 1]);
                                        } else if (value.isEmpty && index > 0) {
                                          FocusScope.of(context)
                                              .requestFocus(
                                              _focusNodes[index - 1]);
                                        }
                                      },
                                      focusNode: _focusNodes[index],
                                      decoration: InputDecoration(
                                        counterText: "",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          ),
                        ),
                        _counter == 0
                            ? GestureDetector(
                          onTap: () {
                            setState(() {
                              _counter = 25;
                            });
                            _startTimer();
                            // startTimer();
                            for (int i = 0; i < 6; i++) {
                              _otpControllers[i].text = "";
                            }
                            FocusScope.of(context).unfocus();
                            context.read<AuthBloc>().add(
                              AuthEvent.resendOtp(context.read<AuthBloc>().userModel.mobileNumber!, appConstants.login)
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate(
                                    i18.common.csResendOtp),
                                  style: widget.theme
                                      .text16W400Rob()
                                      ?.apply(color: widget.theme.defaultColor),
                                ),
                              ],
                            ),
                          ),
                        )
                            : Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                '${AppLocalizations.of(context).translate(
                                    i18.common.csResendAnotherOtp)} 0:${(snapshot.data == 0) || (snapshot.data == null) ? 25
                                    : snapshot.data! < 10 ? "0${snapshot.data}" : snapshot.data}',
                                style: widget.theme.text14W400Rob(),),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: 150,
                                child: BlocListener<AuthBloc, AuthState>(
                                  bloc: context.read<AuthBloc>(),
                                  listener: (context, state) {
                                    state.maybeWhen(
                                        orElse: (){},
                                        requestFailed: (error) {
                                          isSubmit = false;
                                          DigitToast.show(
                                            context,
                                            options: DigitToastOptions(
                                              error,
                                              true,
                                              widget.theme.theme(),
                                            ),
                                          );
                                        },
                                        resendOtpGenerationSucceed: (type) {
                                          DigitToast.show(
                                            context,
                                            options: DigitToastOptions(
                                              "OTP sent successfully",
                                              false,
                                              DigitTheme.instance.mobileTheme,
                                            ),
                                          );
                                        },
                                        individualSearchSuccessState: (individualSearchResponse) {
                                          List<Individual> listIndividuals = individualSearchResponse.individual;
                                          if (listIndividuals.isEmpty) {
                                            DigitToast.show(
                                              context,
                                              options: DigitToastOptions(
                                                "OTP Verified",
                                                false,
                                                DigitTheme.instance.mobileTheme,
                                              ),
                                            );
                                            Future.delayed(const Duration(seconds: 1), () {
                                              isSubmit = false;
                                              Navigator.of(context).pop();
                                              AutoRouter.of(context)
                                                  .push(NotRegisteredRoute());
                                            });
                                          } else {
                                            if (context.read<AuthBloc>().userModel.userType == 'LITIGANT') {
                                              DigitToast.show(
                                                context,
                                                options: DigitToastOptions(
                                                  "OTP Verified",
                                                  false,
                                                  DigitTheme.instance.mobileTheme,
                                                ),
                                              );
                                              Future.delayed(const Duration(seconds: 2), () {
                                                isSubmit = false;
                                                Navigator.of(context).pop();
                                                context.read<AuthBloc>().add(
                                                  const AuthEvent.login(),
                                                );
                                              });
                                            }
                                          }
                                        },
                                        advocateSearchSuccessState: (advocateSearchResponse) {
                                          List<Advocate> advocates = advocateSearchResponse.advocates;
                                          Advocate advocate = advocates[0];
                                          if (advocates.isNotEmpty) {
                                            DigitToast.show(
                                              context,
                                              options: DigitToastOptions(
                                                "OTP Verified",
                                                false,
                                                DigitTheme.instance.mobileTheme,
                                              ),
                                            );
                                            if (advocate.status != "INACTIVE" && advocate.isActive == false) {
                                              Future.delayed(const Duration(seconds: 1), () {
                                                isSubmit = false;
                                                Navigator.of(context).pop();
                                                AutoRouter.of(context)
                                                    .push(AdvocateSuccessRoute());
                                              });
                                            }
                                            if (advocate.status == "INACTIVE" && advocate.isActive == false) {
                                              Future.delayed(const Duration(seconds: 1), () {
                                                isSubmit = false;
                                                Navigator.of(context).pop();
                                                AutoRouter.of(context)
                                                    .push(NameDetailsRoute());
                                              });
                                            }
                                            if (advocate.status == "ACTIVE" && advocate.isActive == true) {
                                              Future.delayed(const Duration(seconds: 1), () {
                                                isSubmit = false;
                                                context.read<AuthBloc>().add(
                                                  const AuthEvent.login(),
                                                );
                                              });
                                            }
                                          }
                                        },
                                        advocateClerkSearchSuccessState: (advocateClerkSearchResponse) {
                                          List<Clerk> clerks = advocateClerkSearchResponse.clerks;
                                          Clerk clerk = clerks[0];
                                          if (clerks.isNotEmpty) {
                                            DigitToast.show(
                                              context,
                                              options: DigitToastOptions(
                                                "OTP Verified",
                                                false,
                                                DigitTheme.instance.mobileTheme,
                                              ),
                                            );
                                            if (clerk.status != "INACTIVE" && clerk.isActive == false) {
                                              Future.delayed(const Duration(seconds: 1), () {
                                                isSubmit = false;
                                                Navigator.of(context).pop();
                                                AutoRouter.of(context)
                                                    .push(AdvocateSuccessRoute());
                                              });
                                            }
                                            if (clerk.status == "INACTIVE" && clerk.isActive == false) {
                                              Future.delayed(const Duration(seconds: 1), () {
                                                isSubmit = false;
                                                Navigator.of(context).pop();
                                                AutoRouter.of(context)
                                                    .push(NameDetailsRoute());
                                              });
                                            }
                                            if (clerk.status == "ACTIVE" && clerk.isActive == true) {
                                              Future.delayed(const Duration(seconds: 1), () {
                                                isSubmit = false;
                                                context.read<AuthBloc>().add(
                                                  const AuthEvent.login(),
                                                );
                                              });
                                            }
                                          }
                                        },
                                    );
                                  },
                                  child: DigitElevatedButton(
                                      onPressed: isSubmit
                                          ? null
                                          : () {
                                        FocusScope.of(context).unfocus();
                                        String otp = '';
                                        for (var controller in _otpControllers) {
                                          otp += controller.text;
                                        }
                                        if (otp.length != 6) {
                                          DigitToast.show(
                                            context,
                                            options: DigitToastOptions(
                                              "Invalid OTP",
                                              true,
                                              DigitTheme.instance.mobileTheme,
                                            ),
                                          );
                                          return;
                                        }
                                        if (context.read<AuthBloc>().userModel.type == "login" && otp.length == 6) {
                                          context.read<AuthBloc>().add(
                                            AuthEvent.submitLoginOtpEvent(context.read<AuthBloc>().userModel.mobileNumber!, otp, context.read<AuthBloc>().userModel)
                                          );
                                        }
                                        isSubmitting = false;
                                        isSubmit = true;
                                      },
                                      child: Text(
                                        AppLocalizations.of(context).translate(
                                        i18.common.verify),
                                        style: widget.theme.text20W700()?.apply(
                                          color: Colors.white,
                                        ),
                                      )),
                                )
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }
            ),
          );
        }
    );
  }
}