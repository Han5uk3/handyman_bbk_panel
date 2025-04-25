import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';
import 'package:handyman_bbk_panel/common_widget/custom_drop_drown.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/snakbar.dart';
import 'package:handyman_bbk_panel/common_widget/text_field.dart';
import 'package:handyman_bbk_panel/helpers/hive_helpers.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';
import 'package:handyman_bbk_panel/modules/home/home.dart';
import 'package:handyman_bbk_panel/modules/login/bloc/login_bloc.dart';
import 'package:handyman_bbk_panel/services/auth_services.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkerDetailPage extends StatefulWidget {
  const WorkerDetailPage({super.key, required this.isProfile});
  final bool isProfile;
  @override
  State<WorkerDetailPage> createState() => _WorkerDetailPageState();
}

class _WorkerDetailPageState extends State<WorkerDetailPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? selectedTitle;
  String? selectedPhoneCode = '+966';
  String? selectedGender = 'Male';
  String? selectedService = 'Plumbing';
  String? selectedExperience = 'Less than 1 year';
  DateTime selectedDate = DateTime.now();

  File? _profileImageFile;
  File? _idImageFile;

  bool isEdit = false;
  bool isLoading = false;
  late Map<String, String> genderOptions;
  late Map<String, String> serviceOptions;
  late Map<String, String> experienceOptions;

  final titleOptions = ['Mr.', 'Ms.', 'Mrs.', 'Dr.'];
  final phoneCodeOptions = ['+966', '+965', "+91"];

  final emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+"
    r"@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
    r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
  );

  @override
  void initState() {
    super.initState();
    serviceOptions = {
      'Electricity': AppLocalizations.of(context)!.electricity,
      'Plumbing': AppLocalizations.of(context)!.plumbing,
    };

    genderOptions = {
      'Male': AppLocalizations.of(context)!.male,
      'Female': AppLocalizations.of(context)!.female,
      'Other': AppLocalizations.of(context)!.other,
    };
    experienceOptions = {
      'Less than 1 year': AppLocalizations.of(context)!.lessthan1year,
      '1-3 years': AppLocalizations.of(context)!.year1to3,
      '3-5 years': AppLocalizations.of(context)!.year3to5,
      '5+ years': AppLocalizations.of(context)!.year5plus,
    };

    selectedTitle = titleOptions.first;
    selectedPhoneCode = phoneCodeOptions.first;
    selectedGender = genderOptions[selectedGender];
    selectedService = serviceOptions[selectedService];
    selectedExperience = experienceOptions[selectedExperience];

    if (!widget.isProfile) {
      isEdit = true;
    }

    if (AuthServices.userName != null ||
        (AuthServices.userName?.isNotEmpty ?? false)) {
      nameController.text = AuthServices.userName ?? '';
    }

    if (AuthServices.userEmail != null ||
        (AuthServices.userEmail?.isNotEmpty ?? false)) {
      emailController.text = AuthServices.userEmail ?? '';
    }
    if (AuthServices.phoneNumber != null ||
        (AuthServices.phoneNumber?.isNotEmpty ?? false)) {
      phoneController.text = AuthServices.phoneNumber!.substring(4);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage({required bool isProfilePic}) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          if (isProfilePic) {
            _profileImageFile = File(pickedFile.path);
          } else {
            _idImageFile = File(pickedFile.path);
          }
        });
      }
    } catch (e) {
      HandySnackBar.shower(
        context: context,
        message: "${AppLocalizations.of(context)!.errorpickingimage}: $e",
        isTrue: false,
      );
    }
  }

  String _formattedDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  bool _validateForm() {
    if (nameController.text.isEmpty) {
      _showValidationError(AppLocalizations.of(context)!.pleaseenteryourname);
      return false;
    } else if (phoneController.text.isEmpty) {
      _showValidationError(
          AppLocalizations.of(context)!.pleaseenteryourmobilenumber);
      return false;
    } else if (phoneController.text.length < 9) {
      _showValidationError(
          AppLocalizations.of(context)!.entervalidmobilenumber);
      return false;
    } else if (emailController.text.isEmpty) {
      _showValidationError(AppLocalizations.of(context)!.pleaseeenteryouremail);
      return false;
    } else if (!emailRegExp.hasMatch(emailController.text)) {
      _showValidationError(
          AppLocalizations.of(context)!.pleaseenteravalidemail);
      return false;
    } else if (locationController.text.isEmpty) {
      _showValidationError(
          AppLocalizations.of(context)!.pleaseenteryourlocation);
      return false;
    } else if (_idImageFile == null) {
      _showValidationError(AppLocalizations.of(context)!.pleaseuploadidproof);
      return false;
    }
    return true;
  }

  void _showValidationError(String message) {
    HandySnackBar.shower(
      context: context,
      message: message,
      isTrue: false,
    );
  }

  void _handleSubmitRegistration() async {
    if (!_validateForm()) return;

    setState(() {
      isLoading = true;
    });

    final userData = UserData(
      address: locationController.text,
      service: selectedService,
      experience: selectedExperience,
      email: emailController.text,
      gender: selectedGender,
      dateOfBirth: _formattedDate(selectedDate),
      latitude: 0.0,
      longitude: 0.0,
      userType: "Worker",
      isAdmin: false,
      isUserOnline: false,
      isVerified: false,
      location: locationController.text,
      loginType: AuthServices.loginType,
      name: nameController.text,
      phoneNumber: phoneController.text,
      title: selectedTitle,
      uid: HiveHelper.getUID(),
    );
    context.read<LoginBloc>().add(CreateAccountEvent(
        userData: userData,
        idProof: _idImageFile,
        profilePic: _profileImageFile));
  }

  void _handleProfileUpdate() {
    if (!_validateForm()) return;
    HandySnackBar.show(
      context: context,
      isTrue: true,
      message: AppLocalizations.of(context)!.profileupdatedsuccessfully,
    );
    setState(() {
      isEdit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar(
          widget.isProfile
              ? AppLocalizations.of(context)!.profile
              : AppLocalizations.of(context)!.register,
          context,
          isCenter: true,
          isneedtopop: widget.isProfile ? true : false,
          actions: widget.isProfile
              ? [
                  TextButton(
                      onPressed: isEdit
                          ? _handleProfileUpdate
                          : () {
                              setState(() {
                                isEdit = true;
                              });
                            },
                      child: Text(
                        isEdit
                            ? AppLocalizations.of(context)!.save
                            : AppLocalizations.of(context)!.edit,
                        style: TextStyle(color: AppColor.blue, fontSize: 16),
                      ))
                ]
              : []),
      bottomNavigationBar: widget.isProfile
          ? null
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 26),
              child: HandymanButton(
                text: AppLocalizations.of(context)!.submitregistration,
                onPressed: _handleSubmitRegistration,
                isLoading: isLoading,
              ),
            ),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is CreateAccountFailure) {
            HandySnackBar.shower(
              context: context,
              message: state.error,
              isTrue: false,
            );
            setState(() {
              isLoading = false;
            });
          }
          if (state is CreateAccountSuccess) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
                (route) => false);
            HandySnackBar.show(
              context: context,
              message: AppLocalizations.of(context)!.registrationsuccessful,
              isTrue: true,
            );
            setState(() {
              isLoading = false;
            });
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: IgnorePointer(
                ignoring: widget.isProfile && !isEdit,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileImageSection(),
                    const SizedBox(height: 24),
                    _buildPersonalInfoSection(),
                    const SizedBox(height: 24),
                    _buildProfessionalInfoSection(),
                    const SizedBox(height: 24),
                    _buildIdProofSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 65,
            backgroundColor: Colors.grey[200],
            backgroundImage: _profileImageFile != null
                ? FileImage(_profileImageFile!)
                : null,
            child: _profileImageFile == null
                ? Icon(Icons.person, size: 50, color: Colors.grey)
                : null,
          ),
          if (isEdit)
            GestureDetector(
              onTap: () => _pickImage(isProfilePic: true),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.edit,
                  size: 18,
                  color: AppColor.black,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HandyLabel(
          text: AppLocalizations.of(context)!.name,
          isBold: true,
          fontSize: 16,
        ),
        const SizedBox(height: 8),
        _buildDropDownTextField(
          AppLocalizations.of(context)!.enteryourname,
          nameController,
          titleOptions,
          (value) => setState(() => selectedTitle = value),
          selectedTitle,
          [],
          TextInputType.name,
        ),
        const SizedBox(height: 15),
        HandyLabel(
          text: AppLocalizations.of(context)!.mobileNumber,
          isBold: true,
          fontSize: 16,
        ),
        const SizedBox(height: 8),
        _buildDropDownTextField(
          AppLocalizations.of(context)!.entermobilenumber,
          phoneController,
          phoneCodeOptions,
          (value) => setState(() => selectedPhoneCode = value),
          selectedPhoneCode,
          [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(9)
          ],
          TextInputType.phone,
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: HandyLabel(
                text: AppLocalizations.of(context)!.gender,
                isBold: true,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: HandyLabel(
                  text: AppLocalizations.of(context)!.dateofbirth,
                  isBold: true,
                  fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: CustomDropdown(
                  items: genderOptions.values.toList(),
                  hasBorder: true,
                  selectedValue: genderOptions[selectedGender],
                  onChanged: (value) {
                    setState(() {
                      selectedGender = genderOptions.entries
                          .firstWhere((entry) => entry.value == value)
                          .key; // Store English
                    });
                  }),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildDOBPicker(),
            ),
          ],
        ),
        const SizedBox(height: 15),
        HandyLabel(
            text: AppLocalizations.of(context)!.emailid,
            isBold: true,
            fontSize: 16),
        const SizedBox(height: 8),
        HandyTextField(
          hintText: AppLocalizations.of(context)!.emailid,
          controller: emailController,
          borderColor: AppColor.lightGrey300,
          textcolor: AppColor.greyDark,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 15),
        HandyLabel(
            text: AppLocalizations.of(context)!.address,
            isBold: true,
            fontSize: 16),
        const SizedBox(height: 8),
        _buildLocationPicker(),
      ],
    );
  }

  Widget _buildProfessionalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HandyLabel(
            text: AppLocalizations.of(context)!.service,
            isBold: true,
            fontSize: 16),
        const SizedBox(height: 8),
        CustomDropdown(
            items: serviceOptions.values.toList(),
            hasBorder: true,
            selectedValue: serviceOptions[selectedService],
            onChanged: (value) {
              setState(() {
                selectedService = serviceOptions.entries
                    .firstWhere((entry) => entry.value == value)
                    .key; // Store English
              });
            }),
        const SizedBox(height: 15),
        HandyLabel(
            text: AppLocalizations.of(context)!.experience,
            isBold: true,
            fontSize: 16),
        const SizedBox(height: 8),
        CustomDropdown(
            items: experienceOptions.values.toList(),
            hasBorder: true,
            selectedValue: experienceOptions[selectedExperience],
            onChanged: (value) {
              setState(() {
                selectedExperience = experienceOptions.entries
                    .firstWhere((entry) => entry.value == value)
                    .key; // Store English
              });
            }),
      ],
    );
  }

  Widget _buildIdProofSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HandyLabel(
          text: AppLocalizations.of(context)!.uploadidproof,
          isBold: true,
          fontSize: 16,
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
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
                          color: Colors.white,
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
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
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
                  radius: const Radius.circular(12),
                  color: AppColor.lightGrey400,
                  dashPattern: const [6, 5],
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined,
                            color: AppColor.lightGrey400, size: 40),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.uploadidproof,
                          style: TextStyle(
                            color: AppColor.lightGrey400,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildDropDownTextField(
    String hinttext,
    TextEditingController controller,
    List<String> items,
    Function(String?) onDropdownChanged,
    String? selectedDropdownValue,
    List<TextInputFormatter> inputFormatters,
    TextInputType keyboardType,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.lightGrey300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: CustomDropdown(
              items: items,
              hasBorder: false,
              selectedValue: selectedDropdownValue,
              onChanged: (value) => onDropdownChanged(value),
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
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              controller: controller,
              borderColor: AppColor.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDOBPicker() {
    return GestureDetector(
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: selectedDate,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.lightGrey300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: HandyLabel(
                text: _formattedDate(selectedDate),
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: AppColor.black,
              size: 18,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLocationPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.lightGrey300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: HandyTextField(
              hintText: AppLocalizations.of(context)!.enteraddress,
              controller: locationController,
              borderColor: AppColor.transparent,
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: IconButton(
              onPressed: () {
                HandySnackBar.show(
                  context: context,
                  message: "Location picker would open here",
                  isTrue: true,
                );
              },
              iconSize: 20,
              icon: Icon(
                Icons.location_on_outlined,
                color: AppColor.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
