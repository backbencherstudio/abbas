
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../widgets/primary_button.dart';
import '../../../../widgets/secondary_appber.dart';


class CreatePool extends StatefulWidget {
  const CreatePool({super.key});

  @override
  State<CreatePool> createState() => _CreatePoolState();
}

class _CreatePoolState extends State<CreatePool> {
  List<TextEditingController> optionControllers = [
    TextEditingController(text: "Option 1"),
  ];

  final FocusNode _questionFocusNode = FocusNode();
  final List<FocusNode> _optionFocusNodes = [];

  Color _postButtonColor = const Color(0xFF0A1A29);
  Color _postTextColor = const Color(0xFF3D4566);
  String _selectedPrivacy = "Public";

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
        _postButtonColor = Colors.red;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                        backgroundImage: AssetImage(
                          'assets/icons/profile_post_screen.png',
                        ),
                        backgroundColor: Colors.blueGrey,
                      ),
                       SizedBox(width: 12.w),
                      const Text(
                        'Sophie Lambert',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          setState(() {
                            _selectedPrivacy = value;
                          });
                        },
                        color: const Color(0xFF0A1A29),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: "Public",
                            child: Text("Public",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600),),
                          ),
                          const PopupMenuItem(
                            value: "Private",
                            child: Text("Private",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600),),
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A1A29),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text(
                                _selectedPrivacy,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down,
                                  color: Colors.white),
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
                      suffixIcon: 'assets/icons/happy.png',
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
                              suffixIcon: '',
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
                                      Icon(Icons.add, color: Color(0xFFB2B5B8)),
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
                          onTap: () {
                            List<String> finalOptions = optionControllers
                                .map((controller) => controller.text)
                                .toList();

                            debugPrint("Poll Question submitted!");
                            debugPrint("Privacy: $_selectedPrivacy");
                            debugPrint("Options: $finalOptions");
                          },

                          color: _postButtonColor,
                          textColor: _postTextColor,
                          icon: '',
                          child: Text("Post"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildFormSection({
  required String label,
  required Widget child,
  bool hasTitle = true,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
       SizedBox(height: 16.h),
      if (label.isNotEmpty)
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8C9196),
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
  required String suffixIcon,
  bool hasIcon = true,
  FocusNode? focusNode,
  TextEditingController? controller,
}) {
  return TextFormField(
    controller: controller,
    focusNode: focusNode,
    decoration: InputDecoration(
      hintText: hintText,
      suffixIcon: hasIcon
          ? Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset(suffixIcon, scale: 3.sp),
      )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0.r),
        borderSide:  BorderSide(color: Color(0xFF3D4566), width: 1.5.w),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0.r),
        borderSide:  BorderSide(color: Color(0xFF3D4566), width: 1.5.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0.r),
        borderSide:  BorderSide(color: Color(0xFF3D4566), width: 1.w),
      ),
    ),
  );
}
