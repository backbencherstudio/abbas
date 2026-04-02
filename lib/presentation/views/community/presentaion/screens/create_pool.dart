import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/community_screen_provider.dart';
import 'package:abbas/presentation/views/profile/view_model/profil_screen_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/secondary_appber.dart';

class CreatePool extends StatefulWidget {
  const CreatePool({super.key});

  @override
  State<CreatePool> createState() => _CreatePoolState();
}

class _CreatePoolState extends State<CreatePool> {
  final TextEditingController _questionController = TextEditingController();
  List<TextEditingController> optionControllers = [
    TextEditingController(text: "Option 1"),
  ];

  final FocusNode _questionFocusNode = FocusNode();
  final List<FocusNode> _optionFocusNodes = [];
  bool _isLoading = false;

  Color _postButtonColor = const Color(0xFF0A1A29);
  Color _postTextColor = const Color(0xFF3D4566);

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < optionControllers.length; i++) {
      _optionFocusNodes.add(FocusNode()..addListener(_handleFocusChange));
    }

    _questionFocusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_questionFocusNode.hasFocus ||
        _optionFocusNodes.any((node) => node.hasFocus)) {
      setState(() {
        _postButtonColor = Color(0xFFE9201D);
        _postTextColor = Colors.white;
      });
    } else {
      setState(() {
        _postButtonColor = const Color(0xFF0A1A29);
        _postTextColor = const Color(0xFF3D4566);
      });
    }
  }

  void _addOption() {
    setState(() {
      optionControllers.add(
        TextEditingController(text: "Option ${optionControllers.length + 1}"),
      );
      _optionFocusNodes.add(FocusNode()..addListener(_handleFocusChange));
    });
  }

  @override
  void dispose() {
    _questionFocusNode.dispose();
    for (var node in _optionFocusNodes) {
      node.dispose();
    }
    for (var controller in optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  /// --------------------- Create Poll --------------
  Future<void> createPoll() async {
    if (_questionController.text.isEmpty) {
      Utils.showToast(
        msg: 'Please enter a question',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
    if (optionControllers.any((controller) => controller.text.isEmpty)) {
      Utils.showToast(
        msg: 'Please enter all options',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
    final provider = Provider.of<CommunityScreenProvider>(
      context,
      listen: false,
    );
    final response = await provider.createPoll(
      _questionController.text,
      optionControllers.map((controller) => controller.text).toList(),
    );
    if (response) {
      Utils.showToast(
        msg: 'Poll created successfully',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.pop(context);
    } else {
      Utils.showToast(
        msg: 'Failed to create poll',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileScreenProvider>(context);
    final profileName = profileProvider.profile?.data?.name;
    final profileImage = profileProvider.profile?.data?.avatar;
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<CommunityScreenProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                SecondaryAppBar(title: 'Create Poll'),
                SizedBox(height: 10.h),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20.r,
                            backgroundImage: NetworkImage(profileImage!),
                            backgroundColor: Colors.blueGrey,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            profileName!,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          PopupMenuButton<String>(
                            initialValue: provider.privacy,
                            color: const Color(0xFF0A1A29),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            onSelected: (String newValue) {
                              provider.setPrivacy(newValue);
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'PUBLIC',
                                    child: Text(
                                      'PUBLIC',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'FRIENDS',
                                    child: Text(
                                      'FRIENDS',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'ONLY ME',
                                    child: Text(
                                      'ONLY ME',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0A1A29),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    provider.privacy == 'PUBLIC'
                                        ? Icons.public
                                        : provider.privacy == 'FRIENDS'
                                        ? Icons.group
                                        : Icons.lock,
                                    color: Colors.white,
                                    size: 16.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    provider.privacy,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                    size: 16.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      _buildFormSection(
                        label: 'Poll Question',
                        child: _buildFormFillField(
                          hintText: 'Ask a question...',
                          controller: _questionController,
                          hasIcon: true,
                          focusNode: _questionFocusNode,
                        ),
                      ),

                      _buildFormSection(
                        label: 'Poll Options',
                        child: Column(
                          children: [
                            for (int i = 0; i < optionControllers.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: _buildFormFillField(
                                  controller: optionControllers[i],
                                  hintText: "Option ${i + 1}",
                                  hasIcon: false,
                                  focusNode: _optionFocusNodes[i],
                                ),
                              ),
                            SizedBox(height: 10.h),

                            Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: _addOption,
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(12),
                                  dashPattern: const [6, 3],
                                  color: const Color(0xFF3D4566),
                                  strokeWidth: 1.5,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    color: Colors.transparent,
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.add,
                                            color: Color(0xFFB2B5B8),
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "Add Option",
                                            style: TextStyle(
                                              color: Color(0xFFB2B5B8),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),

                            PrimaryButton(
                              onTap: () async {
                                List<String> finalOptions = optionControllers
                                    .map((controller) => controller.text)
                                    .toList();

                                debugPrint("Poll Question submitted!");
                                debugPrint("Options: $finalOptions");

                                await createPoll();
                              },

                              color: _postButtonColor,
                              textColor: _postTextColor,
                              icon: '',
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : Text(
                                      "Post",
                                      style: TextStyle(
                                        color: _postTextColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget _buildFormSection({required String label, required Widget child}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 16.h),
      if (label.isNotEmpty)
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      SizedBox(height: 8.h),
      child,
    ],
  );
}

Widget _buildFormFillField({
  required String hintText,
  bool hasIcon = true,
  FocusNode? focusNode,
  TextEditingController? controller,
}) {
  return TextFormField(
    controller: controller,
    focusNode: focusNode,
    decoration: InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0.r),
        borderSide: BorderSide(color: Color(0xFF3D4566), width: 1.5.w),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0.r),
        borderSide: BorderSide(color: Color(0xFF3D4566), width: 1.5.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0.r),
        borderSide: BorderSide(color: Color(0xFF3D4566), width: 1.w),
      ),
    ),
  );
}
