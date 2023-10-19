import 'package:compound/shared_models/property_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlagModal extends StatefulWidget {
  final PropertyModel property;
  final Function function;
  const FlagModal({Key key, @required this.property, @required this.function})
      : super(key: key);

  @override
  _FlagModalState createState() => _FlagModalState();
}

class _FlagModalState extends State<FlagModal> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController instructionController = TextEditingController();

  @override
  void initState() {
    instructionController.text = widget.property?.specialInstructions ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        clipBehavior: Clip.hardEdge,
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Colors.red,
              ),
            ),
          ),
          FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _addPropertyInstructionsTextField(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: Text("Flag Property"),
                    onTap: () async => widget.function,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addPropertyInstructionsTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Special Instructions:',
            style: AppTheme.instance.textStyleSmall(
                fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(
            height: 10.h,
          ),
          FormBuilderTextField(
            name: 'specialInstructions',
            // focusNode: focusInstructions,
            maxLines: 5,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(context),
            ]),
            controller: instructionController,
            style: AppTheme.instance.textStyleSmall(
                fontWeight: FontWeight.w500, color: Color(0xFFAEAEAE)),
            decoration: InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.all(10.0),
                fillColor: Colors.white,
                hintText: 'Take a photo of unit 221',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
        ],
      ),
    );
  }
}
