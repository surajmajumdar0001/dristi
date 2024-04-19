import 'dart:async';

import 'package:digit_components/digit_components.dart';
import 'package:digit_components/widgets/atoms/digit_toaster.dart';
import 'package:digit_components/widgets/digit_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pucardpg/app/bloc/registration_login_bloc/registration_login_bloc.dart';
import 'package:pucardpg/app/bloc/registration_login_bloc/registration_login_event.dart';
import 'package:pucardpg/app/bloc/registration_login_bloc/registration_login_state.dart';
import 'package:pucardpg/app/presentation/widgets/back_button.dart';
import 'package:pucardpg/app/presentation/widgets/help_button.dart';
import 'package:pucardpg/config/mixin/app_mixin.dart';

import '../../../domain/entities/litigant_model.dart';

class OtpScreen extends StatefulWidget with AppMixin{

  UserModel userModel = UserModel();

  OtpScreen({super.key, required this.userModel});

  @override
  OtpScreenState createState() => OtpScreenState();

}

class OtpScreenState extends State<OtpScreen> {

  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  late Timer _timer;
  int _start = 25;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                digitSvg,
                fit: BoxFit.contain,
              ),
              const VerticalDivider(
                color: Colors.white,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "State",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          centerTitle: false,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DigitBackButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
                DigitHelpButton()
              ],
            ),
            DigitCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("OTP Verification", style: widget.theme.text32W700RobCon(),),
                  const SizedBox(height: 20,),
                  Text("Enter the OTP sent to + 91 - ${widget.userModel.mobileNumber}", style: widget.theme.text16W400Rob(),),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      6, (index) => SizedBox(
                        width: 40,
                        child: TextField(
                          controller: _otpControllers[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 1,
                          onChanged: (value) {
                            if (value.isNotEmpty && index < _otpControllers.length - 1) {
                              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                            } else if (value.isEmpty && index > 0) {
                              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                            }
                          },
                          focusNode: _focusNodes[index],
                          decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  _start == 0 ?
                  Center(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          _start = 25;
                        });
                        startTimer();
                      },
                      child: Text('Resend OTP', style: widget.theme.text16W400Rob()?.apply(color: widget.theme.defaultColor),),
                    ),
                  ) : Center(child: Text('Resend OTP in $_start seconds')),
                  const SizedBox(height: 10,),
                  BlocListener<RegistrationLoginBloc, RegistrationLoginState>(
                    bloc: widget.registrationLoginBloc,
                    listener: (context, state) {

                      Navigator.pushNamed(context, '/IdVerificationScreen', arguments: widget.userModel);

                      // switch (state.runtimeType) {
                      //
                      //   case OtpFailedState:
                      //     DigitToast.show(context,
                      //       options: DigitToastOptions(
                      //         (state as OtpFailedState).errorMsg,
                      //         false,
                      //         widget.theme.theme(),
                      //       ),
                      //     );
                      //     break;
                      //   case OtpSuccessState:
                      //     Navigator.pushNamed(context, '/IdVerificationScreen', arguments: widget.userModel);
                      //     break;
                      //   default:
                      //     break;
                      // }
                    },
                    child: DigitElevatedButton(
                        onPressed: () {
                          String otp = '';
                          _otpControllers.forEach((controller) {
                            otp += controller.text;
                          });
                          widget.registrationLoginBloc.add(SubmitRegistrationOtpEvent(username: widget.userModel.mobileNumber!, otp: otp, userModel: widget.userModel));
                          // Navigator.pushNamed(context, '/IdVerificationScreen', arguments: widget.userModel);
                        },
                        child: Text('Submit',  style: widget.theme.text20W700()?.apply(color: Colors.white, ),)
                    ),
                  )


                ],
              ),
            ),
          ],
        )
    );

  }

}