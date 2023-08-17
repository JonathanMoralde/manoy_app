import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/widgets/styledDatapicker.dart';
import 'package:manoy_app/widgets/styledDropdown.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';

import '../provider/signup/signup_provider.dart';

class SignupDetails extends ConsumerWidget {
  const SignupDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstNameController =
        ref.watch(firstNameControllerProvider('first_name'));
    final lastNameController =
        ref.watch(lastNameControllerProvider('last_name'));
    final phoneNumController =
        ref.watch(phoneNumControllerProvider('phoneNum'));
    final addressController = ref.watch(addressControllerProvider('address'));

    final gender = ref.watch(genderProvider);

    final selectedDate = ref.watch(selectedDateProvider);
    final emailController = ref.watch(emailControllerProvider('email'));
    final passwordController =
        ref.watch(passwordControllerProvider('password'));

    void onDateSelected(DateTime? date) {
      ref.read(selectedDateProvider.notifier).state = date;
    }

    return Column(
      children: [
        Text("First Name"),
        StyledTextField(
            controller: firstNameController,
            hintText: "Enter First Name",
            obscureText: false),
        const SizedBox(
          height: 10,
        ),
        Text("Last Name"),
        StyledTextField(
            controller: lastNameController,
            hintText: "Enter Last Name",
            obscureText: false),
        const SizedBox(
          height: 10,
        ),
        Text("Phone Number"),
        StyledTextField(
            controller: phoneNumController,
            hintText: "Enter Phone Number",
            obscureText: false),
        const SizedBox(
          height: 10,
        ),
        Text("Complete Address"),
        StyledTextField(
            controller: addressController,
            hintText: "Enter Address",
            obscureText: false),
        const SizedBox(
          height: 10,
        ),
        Text("Gender"),
        StyledDropdown(
            value: gender,
            onChange: (String? newValue) {
              ref.read(genderProvider.notifier).state = newValue;
            },
            hintText: "Select Gender",
            items: ["Male", "Female"]),
        const SizedBox(
          height: 10,
        ),
        Text('Date of Birth'),
        SizedBox(
          width: 250,
          child: StyledDatepicker(onDateSelected: onDateSelected),
        ),
      ],
    );
  }
}
