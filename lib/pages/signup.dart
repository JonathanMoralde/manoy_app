import 'package:flutter/material.dart';
import 'package:manoy_app/provider/signup/isNext_provider.dart';
import 'package:manoy_app/widgets/signup_details.dart';
import 'package:manoy_app/widgets/signup_next.dart';
import 'package:manoy_app/widgets/styledButton.dart';
import 'package:manoy_app/widgets/styledDatapicker.dart';
import 'package:manoy_app/widgets/styledDropdown.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';

// PROVIDER
import "package:flutter_riverpod/flutter_riverpod.dart";

import '../provider/signup/signup_provider.dart';

class SignupPage extends ConsumerWidget {
  SignupPage({super.key});

//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {

  // final emailController = TextEditingController();

  // final passwordController = TextEditingController();

  // final phoneNumController = TextEditingController();

  // final addressController = TextEditingController();

  // String? gender;

  // DateTime? selectedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.read(isNextProvider.notifier).state = false;
    final isNext = ref.watch(isNextProvider);

    final firstNameValue =
        ref.watch(firstNameControllerProvider('first_name')).text;
    final lastNameValue =
        ref.watch(lastNameControllerProvider('last_name')).text;
    final phoneNumValue =
        ref.watch(phoneNumControllerProvider('phoneNum')).text;
    final addressValue = ref.watch(addressControllerProvider('address')).text;

    final emailValue = ref.watch(emailControllerProvider('email')).text;
    final passwordValue =
        ref.watch(passwordControllerProvider('password')).text;
    final gender = ref.watch(genderProvider);

    final selectedDate = ref.watch(selectedDateProvider);

    return WillPopScope(
      onWillPop: () async {
        ref.read(firstNameControllerProvider('first_name')).clear();
        ref.read(lastNameControllerProvider('last_name')).clear();
        ref.read(phoneNumControllerProvider('phoneNum')).clear();
        ref.read(addressControllerProvider('address')).clear();
        ref.read(genderProvider.notifier).state = null;
        ref.read(selectedDateProvider.notifier).state = null;
        ref.read(isNextProvider.notifier).state = false;

        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "CREATE NEW ACCOUNT",
                  style: TextStyle(fontSize: 24, letterSpacing: 1),
                ),
                const SizedBox(
                  height: 20,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isNext ? SignupNext() : SignupDetails(),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isNext
                        ? StyledButton(
                            btnText: "BACK",
                            onClick: () {
                              ref.read(isNextProvider.notifier).state = false;
                            })
                        : SizedBox(),
                    isNext
                        ? SizedBox(
                            width: 10,
                          )
                        : SizedBox(),
                    StyledButton(
                      btnText: isNext ? "SUBMIT" : "NEXT",
                      onClick: () {
                        if (isNext == false) {
                          ref.read(isNextProvider.notifier).state = true;
                        } else {
                          //TODO SIGN UP SUBMIT HERE
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
