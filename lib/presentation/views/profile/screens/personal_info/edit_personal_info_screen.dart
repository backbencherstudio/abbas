// import 'package:cinact/presentation/widgets/secondary_appber.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../../cors/theme/app_colors.dart';
// import '../../../../widgets/custom_button.dart';
// import '../../../../widgets/custom_text_field.dart';
//
// class EditPersonalInfoScreen extends StatefulWidget {
//   const EditPersonalInfoScreen({super.key});
//
//   @override
//   State<EditPersonalInfoScreen> createState() => _EditPersonalInfoScreenState();
// }
//
// class _EditPersonalInfoScreenState extends State<EditPersonalInfoScreen> {
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _dobController = TextEditingController();
//   final TextEditingController _experienceController = TextEditingController();
//   final TextEditingController _goalsController = TextEditingController();
//
//   final List<String> experienceLevels = ['Beginner', 'Intermediate', 'Expert'];
//   String? _selectedExperienceLevel;
//
//   Future<void> _selectDate(BuildContext context) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2100),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SecondaryAppBar(title: 'Edit Personal Info'),
//             const SizedBox(height: 20),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.w),
//               child: Column(
//                 spacing: 20.h,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildField(
//                     context,
//                     controller: _fullNameController,
//                     title: 'Full Name',
//                     hintText: 'Full Name',
//                   ),
//                   _buildField(
//                     context,
//                     controller: _emailController,
//                     title: 'Email for Invoice',
//                     hintText: 'your@gmail.com',
//                   ),
//                   _buildField(
//                     context,
//                     controller: _phoneController,
//                     title: 'Phone',
//                     hintText: 'e.g. +123456 78 90',
//                   ),
//                   _buildField(
//                     context,
//                     controller: _dobController,
//                     title: 'Date of Birth',
//                     hintText: "mm/ dd/ yyyy",
//                     isDatePicker: true,
//                     suffixIcon: Icons.calendar_month,
//                     validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
//                   ),
//                   _buildDropdownField(
//                     context,
//                     controller: _experienceController,
//                     title: 'Experience Level',
//                     hintText: 'Select your Experience Level',
//                     items: experienceLevels,
//                   ),
//                   _buildField(
//                     context,
//                     controller: _goalsController,
//                     title: 'Acting Goals/Interests',
//                     hintText: 'Acting Goals/Interests',
//                     maxLines: 3,
//                   ),
//                   CustomButton(
//                     title: 'Save',
//                     textColor: Colors.black,
//                     color: Colors.white,
//                     onTap: () {},
//                   ),
//                   SizedBox(height: 20.h),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   Widget _buildField(
//       BuildContext context, {
//         required String title,
//     required TextEditingController controller,
//     required String hintText,
//     IconData? icon,
//     IconData? suffixIcon,
//     TextStyle? hintStyle,
//     VoidCallback? suffixIconOnTap,
//     bool obscureText = false,
//     String? Function(String?)? validator,
//     bool isDatePicker = false,
//         int maxLines = 1,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.greyTextColor),
//         ),
//         SizedBox(height: 4.h),
//         Container(
//           decoration: BoxDecoration(
//             color: AppColors.background,
//             borderRadius: BorderRadius.circular(16.r),
//             border: Border.all(color: AppColors.borderColor),
//           ),
//           child: TextFormField(
//             controller: controller,
//             obscureText: obscureText,
//             validator: validator,
//             readOnly: isDatePicker,
//             maxLines: maxLines,
//             decoration: InputDecoration(
//               hintText: hintText,
//               hintStyle: hintStyle ?? TextStyle(color: AppColors.borderColor, fontSize: 14.sp, fontWeight: FontWeight.w500),
//               prefixIcon: icon == null ? null : Icon(icon, color: Colors.grey),
//               suffixIcon: (suffixIcon != null)
//                   ? GestureDetector(onTap: suffixIconOnTap, child: Icon(suffixIcon, color: Colors.grey))
//                   : null,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(45.r),
//                 borderSide: BorderSide.none,
//               ),
//               contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
//               filled: true,
//               fillColor: AppColors.background,
//             ),
//             onTap: isDatePicker
//                 ? () async {
//               FocusScope.of(context).unfocus();
//               final selectedDate = await showDatePicker(
//                 context: context,
//                 initialDate: DateTime.now(),
//                 firstDate: DateTime(1900),
//                 lastDate: DateTime(2101),
//               );
//               if (selectedDate != null) {
//                 setState(() => controller.text = '${selectedDate.toLocal()}'.split(' ')[0]);
//               }
//             }
//                 : null,
//           ),
//         ),
//       ],
//     );
//   }
//   Widget _buildDropdownField(
//       BuildContext context, {
//         required TextEditingController controller,
//         required String title,
//         required String hintText,
//         required List<String> items,
//       }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.greyTextColor),
//         ),
//         SizedBox(height: 8.h),
//         SizedBox(
//           width: double.infinity,
//           child: DropdownButtonFormField<String>(
//             value: _selectedExperienceLevel,
//             isExpanded: false,
//             onChanged: (newValue) {
//               setState(() {
//                 _selectedExperienceLevel = newValue;
//                 controller.text = newValue ?? '';
//               });
//             },
//             borderRadius: BorderRadius.circular(16.r),
//             dropdownColor: AppColors.containerColor,
//             menuMaxHeight: 140.h,
//             icon: Center(child: SvgPicture.asset("assets/icons/arrow_down.svg", height: 24.h, width: 24.h, fit: BoxFit.cover)),
//             items: items.map((String level) {
//               return DropdownMenuItem<String>(
//                 value: level,
//                 child: Text(
//                   level,
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//               );
//             }).toList(),
//             decoration: InputDecoration(
//               hint: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
//                 child: Text(hintText, style: TextStyle(color: AppColors.borderColor, fontSize: 14.sp, fontWeight: FontWeight.w500),),
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16.sp),
//                 borderSide: BorderSide(
//                   color: AppColors.borderColor,
//                   width: 1.5.w,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16.sp),
//                 borderSide: BorderSide(
//                   color: AppColors.borderColor,
//                   width: 1.5.w,
//                 ),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16.sp),
//                 borderSide: BorderSide(
//                   color: AppColors.borderColor,
//                   width: 1.5.w,
//                 ),
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

// import 'package:cinact/presentation/widgets/secondary_appber.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../../cors/theme/app_colors.dart';
// import '../../../../../domain/entities/profile/personal_info_entity.dart';
// import '../../../../viewmodels/auth/profile/edit_personal_info_viewmodel.dart';
// import '../../../../widgets/custom_button.dart';
//
// class EditPersonalInfoScreen extends StatefulWidget {
//   const EditPersonalInfoScreen({super.key});
//
//   @override
//   State<EditPersonalInfoScreen> createState() => _EditPersonalInfoScreenState();
// }
//
// class _EditPersonalInfoScreenState extends State<EditPersonalInfoScreen> {
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _dobController = TextEditingController();
//   final TextEditingController _experienceController = TextEditingController();
//   final TextEditingController _goalsController = TextEditingController();
//
//   final List<String> experienceLevels = ['BEGINNER', 'INTERMEDIATE', 'EXPERT'];
//   String? _selectedExperienceLevel;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadPersonalInfo();
//     });
//   }
//
//   void _loadPersonalInfo() {
//     final viewModel = context.read<EditPersonalInfoViewModel>();
//     viewModel.loadPersonalInfo().then((_) {
//       if (viewModel.personalInfo != null) {
//         _populateForm(viewModel.personalInfo!);
//       }
//     });
//   }
//
//   void _populateForm(PersonalInfoEntity personalInfo) {
//     setState(() {
//       _fullNameController.text = personalInfo.name;
//       _emailController.text = personalInfo.email;
//       _phoneController.text = personalInfo.phoneNumber;
//       _dobController.text = personalInfo.dateOfBirth;
//       _selectedExperienceLevel = personalInfo.experienceLevel.isNotEmpty
//           ? personalInfo.experienceLevel.first
//           : null;
//       _experienceController.text = _selectedExperienceLevel ?? '';
//       _goalsController.text = personalInfo.actingGoals;
//     });
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2100),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         _dobController.text = DateFormat('MM-dd-yyyy').format(pickedDate);
//       });
//     }
//   }
//
//   Future<void> _savePersonalInfo() async {
//     final viewModel = context.read<EditPersonalInfoViewModel>();
//
//     final updatedInfo = PersonalInfoEntity(
//
//       actingGoals: _goalsController.text.trim(), id: '', experienceLevel: '', roles: [], userRole: '', createdAt: null, name: '', email: '', phoneNumber: '', dateOfBirth: '',
//     );
//
//     final success = await viewModel.updatePersonalInfo(updatedInfo, context);
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Consumer<EditPersonalInfoViewModel>(
//         builder: (context, viewModel, child) {
//           return Stack(
//             children: [
//               SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     SecondaryAppBar(title: 'Edit Personal Info'),
//                     const SizedBox(height: 20),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 16.w),
//                       child: Column(
//                         spacing: 20.h,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildField(
//                             context,
//                             controller: _fullNameController,
//                             title: 'Full Name',
//                             hintText: 'Full Name',
//                           ),
//                           _buildEmailField(
//                             context,
//                             controller: _emailController,
//                             title: 'Email for Invoice',
//                             hintText: 'your@gmail.com',
//                           ),
//                           _buildField(
//                             context,
//                             controller: _phoneController,
//                             title: 'Phone',
//                             hintText: 'e.g. +123456 78 90',
//                           ),
//                           _buildField(
//                             context,
//                             controller: _dobController,
//                             title: 'Date of Birth',
//                             hintText: "mm/dd/yyyy",
//                             isDatePicker: true,
//                             suffixIcon: Icons.calendar_month,
//                             validator: (v) => (v == null || v.trim().isEmpty)
//                                 ? 'Required'
//                                 : null,
//                           ),
//                           _buildExperienceLevelSelector(
//                             context,
//                             title: 'Experience Level',
//                           ),
//                           _buildField(
//                             context,
//                             controller: _goalsController,
//                             title: 'Acting Goals/Interests',
//                             hintText: "Tell us why you\'re here...",
//                             maxLines: 4,
//                           ),
//                           CustomButton(
//                             title: 'Save',
//                             textColor: Colors.black,
//                             color: Colors.white,
//                             onTap: _savePersonalInfo,
//                           ),
//                           SizedBox(height: 20.h),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (viewModel.isLoading)
//                 Container(
//                   color: Colors.black.withOpacity(0.3),
//                   child: Center(child: CircularProgressIndicator()),
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildEmailField(
//     BuildContext context, {
//     required String title,
//     required TextEditingController controller,
//     required String hintText,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: Theme.of(
//             context,
//           ).textTheme.bodyMedium?.copyWith(color: AppColors.greyTextColor),
//         ),
//         SizedBox(height: 4.h),
//         Container(
//           height: 48.h, // Consistent height
//           decoration: BoxDecoration(
//             color: AppColors.background,
//             borderRadius: BorderRadius.circular(16.r),
//             border: Border.all(color: AppColors.borderColor),
//           ),
//           child: TextFormField(
//             controller: controller,
//             readOnly: true,
//             style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
//             decoration: InputDecoration(
//               hintText: hintText,
//               hintStyle: TextStyle(
//                 color: Colors.grey[400],
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w500,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16.r),
//                 borderSide: BorderSide.none,
//               ),
//               contentPadding: EdgeInsets.symmetric(
//                 vertical: 14.h,
//                 horizontal: 16.w,
//               ),
//               filled: true,
//               fillColor: Colors.transparent,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildField(
//     BuildContext context, {
//     required String title,
//     required TextEditingController controller,
//     required String hintText,
//     IconData? icon,
//     IconData? suffixIcon,
//     TextStyle? hintStyle,
//     VoidCallback? suffixIconOnTap,
//     bool obscureText = false,
//     String? Function(String?)? validator,
//     bool isDatePicker = false,
//     int maxLines = 1,
//     bool readOnly = false,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: Theme.of(
//             context,
//           ).textTheme.bodyMedium?.copyWith(color: AppColors.greyTextColor),
//         ),
//         SizedBox(height: 4.h),
//         Container(
//           height: maxLines > 1 ? null : 48.h,
//           // Consistent height for single-line fields
//           decoration: BoxDecoration(
//             color: AppColors.background,
//             borderRadius: BorderRadius.circular(16.r),
//             border: Border.all(color: AppColors.borderColor),
//           ),
//           child: TextFormField(
//             controller: controller,
//             obscureText: obscureText,
//             validator: validator,
//             readOnly: readOnly || isDatePicker,
//             maxLines: maxLines,
//             decoration: InputDecoration(
//               hintText: hintText,
//               hintStyle:
//                   hintStyle ??
//                   TextStyle(
//                     color: AppColors.borderColor,
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w500,
//                   ),
//               prefixIcon: icon == null ? null : Icon(icon, color: Colors.grey),
//               suffixIcon: (suffixIcon != null)
//                   ? GestureDetector(
//                       onTap: suffixIconOnTap,
//                       child: Icon(suffixIcon, color: Colors.grey),
//                     )
//                   : null,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16.r),
//                 borderSide: BorderSide.none,
//               ),
//               contentPadding: EdgeInsets.symmetric(
//                 vertical: maxLines > 1 ? 12.h : 14.h,
//                 horizontal: 16.w,
//               ),
//               filled: true,
//               fillColor: readOnly
//                   ? AppColors.grey.withOpacity(0.3)
//                   : AppColors.background,
//             ),
//             onTap: isDatePicker
//                 ? () async {
//                     FocusScope.of(context).unfocus();
//                     final selectedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(1900),
//                       lastDate: DateTime(2101),
//                     );
//                     if (selectedDate != null) {
//                       setState(
//                         () => controller.text = DateFormat(
//                           'MM-dd-yyyy',
//                         ).format(selectedDate),
//                       );
//                     }
//                   }
//                 : null,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildExperienceLevelSelector(
//     BuildContext context, {
//     required String title,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: Theme.of(
//             context,
//           ).textTheme.bodyMedium?.copyWith(color: AppColors.greyTextColor),
//         ),
//         SizedBox(height: 4.h),
//         Container(
//           height: 48.h, // Same height as TextFormFields
//           decoration: BoxDecoration(
//             color: AppColors.background,
//             borderRadius: BorderRadius.circular(16.r),
//             border: Border.all(color: AppColors.borderColor, width: 1.5.w),
//           ),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: _selectedExperienceLevel,
//                 isExpanded: true,
//                 icon: Padding(
//                   padding: EdgeInsets.only(left: 8.w),
//                   child: SvgPicture.asset(
//                     "assets/icons/arrow_down.svg",
//                     height: 24.h,
//                     width: 24.w,
//                   ),
//                 ),
//                 dropdownColor: AppColors.containerColor,
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   color: Colors.black,
//                   fontSize: 14.sp,
//                 ),
//                 hint: Text(
//                   'Select',
//                   style: TextStyle(
//                     color: AppColors.borderColor,
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 items: experienceLevels.map((String level) {
//                   return DropdownMenuItem<String>(
//                     value: level,
//                     child: Text(
//                       level,
//                       style: Theme.of(
//                         context,
//                       ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedExperienceLevel = newValue;
//                     _experienceController.text = newValue ?? '';
//                   });
//                 },
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

