import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown(
      {super.key, required this.items, required this.hasBorder});
  final List<String> items;
  final bool hasBorder;
  @override
  // ignore: library_private_types_in_public_api
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  GlobalKey buttonKey = GlobalKey();

  String? selectedValue = "";

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _showAbove = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  void _showOverlay() {
    RenderBox buttonBox =
        buttonKey.currentContext!.findRenderObject() as RenderBox;
    Offset buttonPosition = buttonBox.localToGlobal(Offset.zero);
    double buttonHeight = buttonBox.size.height;
    double screenHeight = MediaQuery.of(context).size.height;

    double estimatedDropdownHeight =
        widget.items.length * 56.0 + 16; // ListTile height + padding
    bool willOverflow =
        buttonPosition.dy + buttonHeight + estimatedDropdownHeight >
            screenHeight;

    _showAbove = willOverflow;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: buttonBox.size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: _showAbove
              ? Offset(0, -estimatedDropdownHeight - 8)
              : Offset(0, buttonHeight + 8),
          showWhenUnlinked: false,
          child: Material(
            color: Colors.transparent,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                alignment:
                    _showAbove ? Alignment.bottomCenter : Alignment.topCenter,
                child: Material(
                  color: AppColor.white,
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.items.map((item) {
                        return ListTile(
                          tileColor: AppColor.white,
                          title: Text(item),
                          onTap: () {
                            setState(() => selectedValue = item);
                            _hideOverlay();
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
  }

  void _hideOverlay() {
    _controller.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isOverlayVisible => _overlayEntry != null && _overlayEntry!.mounted;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (!_isOverlayVisible) {
            _showOverlay();
          } else {
            _hideOverlay();
          }
        },
        child: Container(
          key: buttonKey,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
                color: widget.hasBorder
                    ? AppColor.lightGrey300
                    : AppColor.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: HandyLabel(
                  fontSize: 14,
                  text: selectedValue == "" ? "Choose" : selectedValue!,
                  textcolor: AppColor.black,
                  isBold: false,
                ),
              ),
              const Icon(CupertinoIcons.chevron_down, size: 15),
            ],
          ),
        ),
      ),
    );
  }
}
