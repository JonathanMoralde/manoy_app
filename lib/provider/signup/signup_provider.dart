import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:flutter/material.dart';

final firstNameControllerProvider =
    ProviderFamily<TextEditingController, String>(
        (ref, _) => TextEditingController());

final lastNameControllerProvider =
    ProviderFamily<TextEditingController, String>(
        (ref, _) => TextEditingController());

final emailControllerProvider = ProviderFamily<TextEditingController, String>(
    (ref, _) => TextEditingController());

final passwordControllerProvider =
    ProviderFamily<TextEditingController, String>(
        (ref, _) => TextEditingController());

final phoneNumControllerProvider =
    ProviderFamily<TextEditingController, String>(
        (ref, _) => TextEditingController());

final addressControllerProvider = ProviderFamily<TextEditingController, String>(
    (ref, _) => TextEditingController());

final genderProvider = StateProvider<String?>((ref) => null);
final selectedDateProvider = StateProvider<DateTime?>((ref) => null);
