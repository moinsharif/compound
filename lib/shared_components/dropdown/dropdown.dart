import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdown extends StatefulWidget {
  final String text;

  const CustomDropdown({Key key, @required this.text}) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  GlobalKey actionKey;
  double height, width, xPosition, yPosition;
  bool isDropdownOpened = false;
  OverlayEntry floatingDropdown;

  @override
  void initState() {
    actionKey = LabeledGlobalKey(widget.text);
    super.initState();
  }

  @override
  void dispose() {
    if (isDropdownOpened) {
      floatingDropdown.remove();
    }
    super.dispose();
  }

  void findDropdownData() {
    RenderBox renderBox = actionKey.currentContext.findRenderObject();
    height = renderBox.size.height;
    width = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;
  }

  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: xPosition,
        width: width,
        top: yPosition - 30.h,
        height: 2.5 * height,
        child: DropDown(
          itemHeight: height,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: actionKey,
      onTap: () {
        setState(() {
          if (isDropdownOpened) {
            floatingDropdown.remove();
          } else {
            findDropdownData();
            floatingDropdown = _createFloatingDropdown();
            Overlay.of(context).insert(floatingDropdown);
          }

          isDropdownOpened = !isDropdownOpened;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0xffdbdbdb)),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(widget.text.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppTheme.instance.textStyleSmall(
                      fontWeight: FontWeight.w400, color: Colors.black)),
            ),
            Icon(
              isDropdownOpened
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_up,
              color: Color(0xff004A05),
            ),
          ],
        ),
      ),
    );
  }
}

class DropDown extends StatelessWidget {
  final double itemHeight;

  const DropDown({Key key, this.itemHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: itemHeight,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0xffdbdbdb)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DropDownItem.first(
            text: "Add new",
            iconData: Icons.add_circle_outline,
            isSelected: false,
          ),
          DropDownItem(
            text: "View Profile",
            iconData: Icons.person_outline,
            isSelected: false,
          ),
          DropDownItem(
            text: "Settings",
            iconData: Icons.settings,
            isSelected: false,
          ),
          DropDownItem.last(
            text: "Logout",
            iconData: Icons.exit_to_app,
            isSelected: true,
          ),
        ],
      ),
    );
  }
}

class DropDownItem extends StatelessWidget {
  final String text;
  final IconData iconData;
  final bool isSelected;
  final bool isFirstItem;
  final bool isLastItem;

  const DropDownItem(
      {Key key,
      this.text,
      this.iconData,
      this.isSelected = false,
      this.isFirstItem = false,
      this.isLastItem = false})
      : super(key: key);

  factory DropDownItem.first(
      {String text, IconData iconData, bool isSelected}) {
    return DropDownItem(
      text: text,
      iconData: iconData,
      isSelected: isSelected,
      isFirstItem: true,
    );
  }

  factory DropDownItem.last({String text, IconData iconData, bool isSelected}) {
    return DropDownItem(
      text: text,
      iconData: iconData,
      isSelected: isSelected,
      isLastItem: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: isFirstItem ? Radius.circular(8) : Radius.zero,
            bottom: isLastItem ? Radius.circular(8) : Radius.zero,
          ),
          color: isSelected ? Color(0XFFF8F8F8) : Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: <Widget>[
          Text(
            text.toUpperCase(),
            style: AppTheme.instance.textStyleSmall(
                fontWeight: FontWeight.w400, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
