import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';
import 'package:handyman_bbk_panel/common_widget/custom_drop_drown.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/loader.dart';
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
  final bool isProfile;
  UserData? workerData;
  bool? isEditProfile;
  WorkerDetailPage(
      {super.key,
      required this.isProfile,
      this.workerData,
      this.isEditProfile});

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
  String? selectedService = 'Electricity';
  String? selectedExperience = 'Less than 1 year';
  DateTime selectedDate = DateTime.now();
  File? _profileImageFile;
  String? _profileImageUrl;
  File? _idImageFile;
  bool isEdit = false;
  bool isLoading = false;
  Map<String, String>? genderOptions;
  Map<String, String>? serviceOptions;
  Map<String, String>? experienceOptions;

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
    _loadProfileImage();
    selectedTitle = titleOptions.first;
    selectedPhoneCode = phoneCodeOptions.first;
    selectedGender = genderOptions?[selectedGender];
    selectedService = serviceOptions?[selectedService];
    selectedExperience = experienceOptions?[selectedExperience];

    if (!widget.isProfile) {
      isEdit = true;
    }

    if (widget.isEditProfile ?? false) {
      isEdit = false;
      selectedGender = widget.workerData?.gender;
      selectedService = widget.workerData?.service ?? 'Plumbing';
      selectedExperience = widget.workerData?.experience;
      selectedTitle = widget.workerData?.title;
      // selectedDate = widget.workerData?.dateOfBirth;
      nameController.text = widget.workerData?.name ?? '';
      locationController.text = widget.workerData?.location ?? '';
      phoneController.text = widget.workerData?.phoneNumber ?? '';
      emailController.text = widget.workerData?.email ?? '';
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
    serviceOptions = {
      'Electricity': 'Electricity',
      'Plumbing': 'Plumbing',
    };
  }

  Future<void> _loadProfileImage() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('workers')
        .doc(HiveHelper.getUID())
        .get();

    setState(() {
      _profileImageUrl = snapshot.data()?['profilePic'];
    });
  }

  Future<void> _pickImage(bool isprofileimage) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    isprofileimage
        ? setState(() {
            _profileImageFile = File(pickedFile.path);
          })
        : setState(() {
            _idImageFile = File(pickedFile.path);
          });

    await _uploadImageToFirebase();
  }

  Future<void> _uploadImageToFirebase() async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('workers')
        .child('${HiveHelper.getUID()}.jpg');

    await ref.putFile(_profileImageFile!);
    final downloadUrl = await ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('workers')
        .doc(HiveHelper.getUID())
        .update({'profilePic': downloadUrl});

    setState(() {
      _profileImageUrl = downloadUrl;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    genderOptions = {
      'Male': AppLocalizations.of(context)!.male,
      'Female': AppLocalizations.of(context)!.female,
      'Other': AppLocalizations.of(context)!.other,
    };

    serviceOptions = {
      'Electricity': AppLocalizations.of(context)!.electricity,
      'Plumbing': AppLocalizations.of(context)!.plumbing,
    };

    experienceOptions = {
      'Less than 1 year': AppLocalizations.of(context)!.lessthan1year,
      '1-3 years': AppLocalizations.of(context)!.year1to3,
      '3-5 years': AppLocalizations.of(context)!.year3to5,
      '5+ years': AppLocalizations.of(context)!.year5plus,
    };

    if (selectedGender != null && genderOptions != null) {
      selectedGender = selectedGender;
    } else {
      selectedGender = 'Male';
    }

    if (selectedService != null) {
      selectedService = selectedService;
    } else {
      selectedService = 'Plumbing';
    }

    if (selectedExperience != null && experienceOptions != null) {
      selectedExperience = selectedExperience;
    } else {
      selectedExperience = 'Less than 1 year';
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
    } else if (!isEdit && _idImageFile == null) {
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
    context.read<LoginBloc>().add(UpdateProfileEvent(
          username: nameController.text,
          email: emailController.text,
          address: locationController.text,
          service: selectedService ?? "",
          experience: selectedExperience ?? "",
        ));
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
                                isEdit = !isEdit;
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
    final imageWidget = _profileImageFile != null
        ? Image.file(_profileImageFile!, fit: BoxFit.cover)
        : (_profileImageUrl != null
            ? CachedNetworkImage(
                imageUrl: _profileImageUrl!,
                placeholder: (context, url) => HandymanLoader(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              )
            : Icon(Icons.account_circle, size: 100));
    return Align(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
              radius: 70,
              backgroundColor: Colors.grey[300],
              child: ClipOval(
                child: SizedBox(
                  width: 140,
                  height: 140,
                  child: imageWidget,
                ),
              )),
          if (isEdit)
            GestureDetector(
              onTap: () => _pickImage(true),
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
                  items: genderOptions?.values.toList() ?? [],
                  hasBorder: true,
                  selectedValue: genderOptions?[selectedGender],
                  onChanged: (value) {
                    setState(() {
                      selectedGender = genderOptions?.entries
                          .firstWhere((entry) => entry.value == value)
                          .key;
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
            items: serviceOptions?.values.toList() ?? [],
            hasBorder: true,
            selectedValue: serviceOptions?[selectedService] ?? selectedService,
            onChanged: (value) {
              setState(() {
                selectedService = serviceOptions?.entries
                    .firstWhere(
                      (entry) => entry.value == value,
                      orElse: () =>
                          MapEntry(selectedService ?? 'Plumbing', value),
                    )
                    .key;
              });
            }),
        const SizedBox(height: 15),
        HandyLabel(
            text: AppLocalizations.of(context)!.experience,
            isBold: true,
            fontSize: 16),
        const SizedBox(height: 8),
        CustomDropdown(
            items: experienceOptions?.values.toList() ?? [],
            hasBorder: true,
            selectedValue: experienceOptions?[selectedExperience],
            onChanged: (value) {
              setState(() {
                selectedExperience = experienceOptions?.entries
                    .firstWhere((entry) => entry.value == value)
                    .key;
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
        widget.isProfile
            ? GestureDetector(
                onTap: () =>
                    _showEnlargedImage(context, widget.workerData!.idProof!),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    height: 150,
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
                    child: CachedNetworkImage(
                        imageUrl: widget.workerData!.idProof ?? '',
                        fit: BoxFit.cover),
                  ),
                ),
              )
            : GestureDetector(
                onTap: () => _pickImage(false),
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

  void _showEnlargedImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) =>
                        const Center(child: HandymanLoader()),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.error, size: 50, color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
