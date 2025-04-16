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
import 'package:handyman_bbk_panel/modules/home/home_page.dart';
import 'package:handyman_bbk_panel/modules/login/bloc/login_bloc.dart';
import 'package:handyman_bbk_panel/services/auth_services.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:image_picker/image_picker.dart';

class WorkerDetailPage extends StatefulWidget {
  const WorkerDetailPage({super.key, required this.isProfile});
  final bool isProfile;
  @override
  State<WorkerDetailPage> createState() => _WorkerDetailPageState();
}

class _WorkerDetailPageState extends State<WorkerDetailPage> {
  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Selected values
  String? selectedTitle;
  String? selectedPhoneCode;
  String? selectedGender;
  String? selectedService;
  String? selectedExperience;
  DateTime selectedDate = DateTime.now();

  // Image files
  File? _profileImageFile;
  File? _idImageFile;

  // UI state
  bool isEdit = false;
  bool isLoading = false;

  // Dropdown options
  final titleOptions = ['Mr.', 'Ms.', 'Mrs.', 'Dr.'];
  final phoneCodeOptions = ['+91', '+955', '+965'];
  final genderOptions = ['Male', 'Female', 'Other'];
  final serviceOptions = [
    'Plumbing',
    'Electrical',
    'Carpentry',
    'Painting',
    'Cleaning'
  ];
  final experienceOptions = [
    'Less than 1 year',
    '1-3 years',
    '3-5 years',
    '5+ years'
  ];

  // Email validation regex
  final emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+"
    r"@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
    r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
  );

  @override
  void initState() {
    super.initState();
    // Set default values for dropdowns
    selectedTitle = titleOptions.first;
    selectedPhoneCode = phoneCodeOptions.first;
    selectedGender = genderOptions.first;
    selectedService = serviceOptions.first;
    selectedExperience = experienceOptions.first;

    // Enable editing by default for registration
    if (!widget.isProfile) {
      isEdit = true;
    }

    if (AuthServices.userName != null ||
        (AuthServices.userName?.isNotEmpty ?? false)) {
      nameController.text = AuthServices.userName ?? '';
    }

    // For profile page, you could load existing data here
    // loadProfileData();
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
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
        imageQuality: 80, // Optimize image quality
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
        message: "Error picking image: $e",
        isTrue: false,
      );
    }
  }

  String _formattedDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  bool _validateForm() {
    if (nameController.text.isEmpty) {
      _showValidationError("Please enter name");
      return false;
    } else if (phoneController.text.isEmpty) {
      _showValidationError("Please enter mobile number");
      return false;
    } else if (phoneController.text.length < 10) {
      _showValidationError("Please enter a valid mobile number");
      return false;
    } else if (emailController.text.isEmpty) {
      _showValidationError("Please enter email");
      return false;
    } else if (!emailRegExp.hasMatch(emailController.text)) {
      _showValidationError("Please enter a valid email");
      return false;
    } else if (locationController.text.isEmpty) {
      _showValidationError("Please enter location");
      return false;
    } else if (_idImageFile == null) {
      _showValidationError("Please upload ID proof");
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

  Map<String, dynamic> _collectFormData() {
    // Collect all form data in a structured way
    return {
      'name': nameController.text,
      'title': selectedTitle,
      'gender': selectedGender,
      'dateOfBirth': _formattedDate(selectedDate),
      'address': locationController.text,
      'service': selectedService,
      'experience': selectedExperience,
      'email': emailController.text,
      'hasProfileImage': _profileImageFile != null,
      'hasIdProof': _idImageFile != null,
    };
  }

  void _handleSubmitRegistration() async {
    // Validate and submit
    if (!_validateForm()) return;

    setState(() {
      isLoading = true;
    });

    // Collect form data
    final userData = UserData(
      address: locationController.text,
      service: selectedService,
      experience: selectedExperience,
      email: emailController.text,
      hasProfileImage: _profileImageFile != null,
      hasIdProof: _idImageFile != null,
      gender: selectedGender,
      dateOfBirth: _formattedDate(selectedDate),
      latitude: 0.0,
      longitude: 0.0,
      userType: "Worker",
      location: locationController.text,
      loginType: AuthServices.loginType,
      name: nameController.text,
      phoneNumber: phoneController.text,
      title: selectedTitle,
      uid: HiveHelper.getUID(),
    );

    // Log the collected data (for demonstration)
    print('User Registration Data: $userData');

    // Here you would typically send this data to your backend service

    // Simulate a network request
    context.read<LoginBloc>().add(CreateAccountEvent(userData: userData));
  }

  void _handleProfileUpdate() {
    // For the profile edit mode
    if (!_validateForm()) return;

    // Collect and log profile data
    final profileData = _collectFormData();
    print('Updated Profile Data: $profileData');

    // Show success message
    HandySnackBar.show(
      context: context,
      isTrue: true,
      message: "Profile updated successfully",
    );

    setState(() {
      isEdit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar(widget.isProfile ? "Profile" : "Register", context,
          isCenter: true,
          isneedtopop: true,
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
                        isEdit ? "Save" : "Edit",
                        style: TextStyle(color: AppColor.blue, fontSize: 16),
                      ))
                ]
              : []),
      bottomNavigationBar: widget.isProfile
          ? null
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 26),
              child: HandymanButton(
                text: "Submit Registration",
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
                  builder: (context) => HomePage(
<<<<<<< Updated upstream
                    isAdmin: false,
=======
                 isAdmin: true,
>>>>>>> Stashed changes
                  ),
                ),
                (route) => false);
            HandySnackBar.show(
              context: context,
              message: "Registration successful",
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
          text: "Name",
          isBold: true,
          fontSize: 16,
        ),
        const SizedBox(height: 8),
        _buildDropDownTextField(
          "Enter Your Name",
          nameController,
          titleOptions,
          (value) => setState(() => selectedTitle = value),
          selectedTitle,
          [],
          TextInputType.name,
        ),
        const SizedBox(height: 15),
        HandyLabel(
          text: "Mobile Number",
          isBold: true,
          fontSize: 16,
        ),
        const SizedBox(height: 8),
        _buildDropDownTextField(
          "Enter Mobile Number",
          phoneController,
          phoneCodeOptions,
          (value) => setState(() => selectedPhoneCode = value),
          selectedPhoneCode,
          [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10)
          ],
          TextInputType.phone,
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: HandyLabel(
                text: "Gender",
                isBold: true,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: HandyLabel(text: "D.O.B", isBold: true, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: CustomDropdown(
                items: genderOptions,
                hasBorder: true,
                // onChanged: (value) => setState(() => selectedGender = value),
                // initialValue: selectedGender,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildDOBPicker(),
            ),
          ],
        ),
        const SizedBox(height: 15),
        HandyLabel(text: "Email ID", isBold: true, fontSize: 16),
        const SizedBox(height: 8),
        HandyTextField(
          hintText: "Email ID",
          controller: emailController,
          borderColor: AppColor.lightGrey300,
          textcolor: AppColor.greyDark,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 15),
        HandyLabel(text: "Address", isBold: true, fontSize: 16),
        const SizedBox(height: 8),
        _buildLocationPicker(),
      ],
    );
  }

  Widget _buildProfessionalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HandyLabel(text: "Service", isBold: true, fontSize: 16),
        const SizedBox(height: 8),
        CustomDropdown(
          items: serviceOptions,
          hasBorder: true,
          // onChanged: (value) => setState(() => selectedService = value),
          // initialValue: selectedService,
        ),
        const SizedBox(height: 15),
        HandyLabel(text: "Experience", isBold: true, fontSize: 16),
        const SizedBox(height: 8),
        CustomDropdown(
          items: experienceOptions,
          hasBorder: true,
          // onChanged: (value) => setState(() => selectedExperience = value),
          // initialValue: selectedExperience,
        ),
      ],
    );
  }

  Widget _buildIdProofSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HandyLabel(
          text: 'Upload ID Proof',
          isBold: true,
          fontSize: 16,
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _pickImage(
              isProfilePic:
                  false), // Removed isEdit condition to allow upload in registration
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
                    // Show remove button for both profile and registration
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
                          "Upload ID Proof",
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
              // initialValue: selectedDropdownValue,
              // onChanged: onDropdownChanged,
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
        // Removed isEdit condition to allow DOB selection in registration
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
              hintText: "Enter Address",
              controller: locationController,
              borderColor: AppColor.transparent,
            ),
          ),
          IconButton(
            onPressed: () {
              // Removed isEdit condition to allow location selection in registration
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
          )
        ],
      ),
    );
  }
}
