import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manoy_app/widgets/styledButton.dart';
import 'package:manoy_app/widgets/styledDropdown.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';
import 'package:manoy_app/widgets/timePicker.dart';
import 'package:manoy_app/widgets/uploadImage_input.dart';

class ApplyProvider extends StatefulWidget {
  ApplyProvider({super.key});

  @override
  State<ApplyProvider> createState() => _ApplyProviderState();
}

class _ApplyProviderState extends State<ApplyProvider> {
  final providerNameController = TextEditingController();

  final providerAddressController = TextEditingController();

  final providerDescriptionController = TextEditingController();

  TimeOfDay? selectedTime1;
  TimeOfDay? selectedTime2;

  String? category;

  String? selectedImagePath1;
  String? selectedImagePath2;

  void _showTimePicker1() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        selectedTime1 = value;
      });
    });
  }

  void _showTimePicker2() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        selectedTime2 = value;
      });
    });
  }

  Future<void> _pickImage1() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImagePath1 = image.path; // Store the selected image path
      });
    }
  }

  Future<void> _pickImage2() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImagePath2 = image.path; // Store the selected image path
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? time1 = selectedTime1?.format(context).toString();
    String? time2 = selectedTime2?.format(context).toString();
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Text(
                "APPLY AS",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
              ),
              const Text(
                "SERVICE PROVIDER",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                  width: 250,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Shop/Service Name:"))),
              StyledTextField(
                  controller: providerNameController,
                  hintText: "Enter Name",
                  obscureText: false),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                  width: 250,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Shop/Service Address:"))),
              StyledTextField(
                  controller: providerAddressController,
                  hintText: "Enter Address",
                  obscureText: false),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                  width: 250,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Description:"))),
              StyledTextField(
                  controller: providerDescriptionController,
                  hintText: "Enter Description",
                  obscureText: false),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                width: 250,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Business Hours:")),
              ),
              SizedBox(
                width: 250,
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: TimePicker(
                          onTap: _showTimePicker1,
                          selectedTime: time1,
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    Text("TO"),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        flex: 1,
                        child: TimePicker(
                          onTap: _showTimePicker2,
                          selectedTime: time2,
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                width: 250,
                child: Align(
                    alignment: Alignment.centerLeft, child: Text("Category:")),
              ),
              StyledDropdown(
                  value: category,
                  onChange: (newValue) {
                    setState(() {
                      category = newValue;
                    });
                  },
                  hintText: "Select Category",
                  items: const [
                    "Accessories & Repair Service",
                    "Accessories",
                    "Repair Service",
                  ]),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                width: 250,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Shop/Service Profile Photo:")),
              ),
              UploadImage(
                onPressed: _pickImage1,
                text: selectedImagePath1,
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                width: 250,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Shop/Service Cover Photo:")),
              ),
              UploadImage(
                onPressed: _pickImage2,
                text: selectedImagePath2,
              ),
              const SizedBox(
                height: 20,
              ),
              StyledButton(btnText: "CONFIRM", onClick: () {})
            ],
          ),
        ),
      )),
    );
  }
}
