import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';
import 'package:handyman_bbk_panel/common_widget/custom_drop_drown.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/text_field.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:image_picker/image_picker.dart';

class WorkerDetailPage extends StatefulWidget {
  const WorkerDetailPage({super.key});

  @override
  State<WorkerDetailPage> createState() => _WorkerDetailPageState();
}

class _WorkerDetailPageState extends State<WorkerDetailPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  File? _imageFile;
  File? _idImageFile;

  Future<void> _pickImage({required bool isProfilePic}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      isProfilePic
          ? setState(() {
              _imageFile = File(pickedFile.path);
            })
          : setState(() {
              _idImageFile = File(pickedFile.path);
            });
    }
  }

  final _formKey = GlobalKey<FormState>();
  final genderOptions = ['Male', 'Female', 'Other'];
  final titleOptions = ['Mr.', 'Ms.', 'Mrs.', 'Dr.'];
  final phoneCodeOptions = ['+91', '+955', '+965'];
  final serviceOptions = ['Plumbing', 'Electrical'];
  final experienceOptions = [
    'Less than 1 year',
    '1-3 years',
    '3-5 years',
    '5+ years'
  ];
  _formattedDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          handyAppBar("Register", context, isCenter: true, isneedtopop: true),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 26),
        child: HandymanButton(
          text: "Submit Registration",
          onPressed: () {},
          isLoading: false,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.grey[200],
                        backgroundImage:
                            _imageFile != null ? FileImage(_imageFile!) : null,
                        child: _imageFile == null
                            ? Icon(Icons.person, size: 50, color: Colors.grey)
                            : null,
                      ),
                      GestureDetector(
                        onTap: () => _pickImage(isProfilePic: true),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.edit,
                            size: 18,
                            color: AppColor.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                HandyLabel(
                  text: "Name",
                  isBold: true,
                  fontSize: 16,
                ),
                const SizedBox(height: 8),
                _buildDropDownTextField(
                    "Enter Your Name", nameController, titleOptions),
                const SizedBox(height: 15),
                HandyLabel(
                  text: "Mobile Number",
                  isBold: true,
                  fontSize: 16,
                ),
                const SizedBox(height: 8),
                _buildDropDownTextField(
                    "Enter Mobile Number ", phoneController, phoneCodeOptions),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: HandyLabel(
                          text: "Gender", isBold: true, fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child:
                          HandyLabel(text: "D.O.B", isBold: true, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child:
                          CustomDropdown(items: genderOptions, hasBorder: true),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDOBPicker(),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                HandyLabel(text: "Address", isBold: true, fontSize: 16),
                const SizedBox(height: 8),
                _buildLocationPicker(),
                const SizedBox(height: 15),
                HandyLabel(text: "Service", isBold: true, fontSize: 16),
                const SizedBox(height: 8),
                CustomDropdown(items: serviceOptions, hasBorder: true),
                const SizedBox(height: 15),
                HandyLabel(text: "Experience", isBold: true, fontSize: 16),
                const SizedBox(height: 8),
                CustomDropdown(items: experienceOptions, hasBorder: true),
                const SizedBox(height: 15),
                HandyLabel(text: "Email ID", isBold: true, fontSize: 16),
                const SizedBox(height: 8),
                HandyTextField(
                  hintText: "Email ID",
                  controller: emailController,
                  borderColor: AppColor.lightGrey300,
                  textcolor: AppColor.greyDark,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: HandyLabel(
                    text: 'Upload ID Proof',
                    isBold: true,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => _pickImage(isProfilePic: false),
                  child: _idImageFile != null
                      ? Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width * 0.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _idImageFile!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: -5,
                              right: -15,
                              child: Container(
                                height: 25,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white, // white background
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  iconSize: 17,
                                  padding: EdgeInsets.all(4),
                                  constraints: BoxConstraints(),
                                  onPressed: () {
                                    setState(() {
                                      _idImageFile = null;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      : DottedBorder(
                          borderType: BorderType.RRect,
                          strokeWidth: 2,
                          radius: Radius.circular(12),
                          color: AppColor.lightGrey400,
                          dashPattern: [6, 5],
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Icon(Icons.add_photo_alternate_outlined,
                                color: AppColor.lightGrey400, size: 40),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropDownTextField(
      String hinttext, TextEditingController controller, List<String> items) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.lightGrey300),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: CustomDropdown(
              items: items,
              hasBorder: false,
            ),
          ),
          Container(
            height: 30,
            width: 1,
            color: AppColor.lightGrey400,
          ),
          Expanded(
            flex: 9,
            child: HandyTextField(
              hintText: hinttext,
              controller: controller,
              borderColor: AppColor.transparent,
            ),
          ),
        ],
      ),
    );
  }

  _buildDOBPicker() {
    return GestureDetector(
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColor.yellow,
                  onPrimary: AppColor.white,
                  onSurface: AppColor.black,
                ),
                dialogBackgroundColor: AppColor.white,
              ),
              child: child!,
            );
          },
        ).then((value) {
          if (value != null) {
            setState(() {
              selectedDate = value;
            });
          }
        });
      },
      child: Container(
          padding: EdgeInsets.fromLTRB(12, 15, 12, 15),
          decoration: BoxDecoration(
              border: Border.all(color: AppColor.lightGrey300),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Row(
            children: [
              Expanded(
                  child: HandyLabel(text: "${_formattedDate(selectedDate)}")),
              Icon(
                Icons.calendar_today,
                color: AppColor.black,
              )
            ],
          )),
    );
  }

  Widget _buildLocationPicker() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.lightGrey300),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Row(
        children: [
          Expanded(
              child: HandyTextField(
            hintText: "Enter Address",
            controller: locationController,
            borderColor: AppColor.transparent,
          )),
          IconButton(
            onPressed: () {},
            iconSize: 20,
            icon: Icon(
              Icons.location_on_outlined,
              color: AppColor.black,
            ),
          )
        ],
      ),
    );
  }
}
