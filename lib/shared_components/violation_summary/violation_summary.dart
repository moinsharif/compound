import 'package:compound/config.dart';
import 'package:compound/shared_components/buttons/button_blue.dart';
import 'package:compound/shared_components/violation_summary/violation_summary_view_model.dart';
import 'package:compound/shared_models/violation_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViolationSummary extends StatefulWidget {
  @override
  _ViolationSummaryState createState() => _ViolationSummaryState();
}

class _ViolationSummaryState extends State<ViolationSummary> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViolationSummaryViewModel>.reactive(
        viewModelBuilder: () => ViolationSummaryViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() => model.load());
        },
        builder: (context, model, child) => Container(
              color: Colors.white,
              child: Container(
                margin:
                    EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 15.0.w),
                child: Column(
                  children: [
                    _viewViolations(model),
                    _violations(),
                    model.violations.length < 1
                        ? SizedBox(
                            height: 150.w,
                            child: Center(
                                child: Text("Nothing to show",
                                    style: AppTheme.instance.textStyleSmall())))
                        : _Slides(
                            model.violations
                                .map((e) => InkWell(
                                    onTap: () {
                                      model.goToSingleViolation(e);
                                    },
                                    child: _page(e, model)))
                                .toList(),
                            model),
                    model.violations.length < 1
                        ? SizedBox(height: 1.w)
                        : _Dots(model.violations.length, model)
                  ],
                ),
              ),
            ));
  }

  Column _page(ViolationModel _violation, ViolationSummaryViewModel model) {
    return Column(
      children: [
        SizedBox(
          height: 5.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(_violation.images[0]))),
            ),
            SizedBox(
              width: 20.0.w,
            ),
            Expanded(
              child: Column(
                children: [
                  _infoViolation(
                      title: 'Property: ',
                      description: _violation.property.propertyName),
                  _infoViolation(
                      title: 'Market: ',
                      description: _violation.property.marketName),
                  _infoViolation(
                      title: 'Address: ',
                      description: _violation.property.address),
                  _infoViolation(
                      title: 'Date: ',
                      description:
                          model.loadDates(_violation.createdAt.local())),
                  _infoViolationSummary(
                      title: '${Config.oneViolation} Type: ',
                      description: '${_violation.violationType.join(", ")}.')
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Future<dynamic> showAlert(BuildContext context, ViolationModel violation,
      ViolationSummaryViewModel model) {
    final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
    final TextEditingController instructionController = TextEditingController();
    instructionController.text = violation.property.specialInstructions ?? '';
    return showDialog(
        context: context,
        builder: (BuildContext context) {
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
                      _addPropertyInstructionsTextField(instructionController),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            child: Text("Flag Property"),
                            onTap: () {
                              model.updatePropertyFlagged(
                                  violation, instructionController.text,
                                  flaged: true);
                              Navigator.pop(context);
                            }),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _addPropertyInstructionsTextField(
      TextEditingController instructionController) {
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

  Row _infoViolation({@required String title, @required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.instance
              .textStyleSmall(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            description,
            style: AppTheme.instance.textStyleSmall(color: Colors.grey[700]),
            maxLines: 2,
          ),
        )
      ],
    );
  }

  RichText _infoViolationSummary(
      {@required String title, @required String description}) {
    return RichText(
      text: new TextSpan(
        style: AppTheme.instance
            .textStyleSmall(color: Colors.black, fontWeight: FontWeight.w600),
        children: <TextSpan>[
          new TextSpan(
              text: title,
              style: AppTheme.instance.textStyleSmall(
                  color: Colors.black, fontWeight: FontWeight.w600)),
          new TextSpan(
            text: description,
            style: AppTheme.instance.textStyleSmall(color: Colors.grey[700]),
          ),
        ],
      ),
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    );
  }

  Row _violations() {
    return Row(
      children: [
        Text('Recent ${Config.violations}',
            style: AppTheme.instance.textStyleRegular(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            )),
      ],
    );
  }

  Row _viewViolations(ViolationSummaryViewModel model) {
    return Row(
      children: [
        Text('${Config.violations} Summary',
            style: AppTheme.instance.textStyleSmall(
                color: AppTheme.instance.primaryDarkColorBlue,
                fontWeight: FontWeight.w600)),
        Spacer(),
        ButtonBlue(
          onpress: () async {
            await model.goToAllViolations();
          },
        )
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  final int totalSlides;
  final ViolationSummaryViewModel model;

  const _Dots(this.totalSlides, this.model);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(this.totalSlides, (i) => _Dot(i, model)),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final int index;
  final ViolationSummaryViewModel model;

  _Dot(this.index, this.model);

  @override
  Widget build(BuildContext context) {
    double tamano = 0.0;
    Color color;
    BoxShadow boxShadow;
    if (model.currentPage >= index - 0.5 && model.currentPage < index + 0.5) {
      tamano = 15.0;
      color = AppTheme.instance.primaryDarkColorBlue;
      boxShadow = BoxShadow(
          color: Colors.black.withOpacity(0.3),
          spreadRadius: 0,
          blurRadius: 2,
          offset: Offset(1, 3));
    } else {
      tamano = 16.0;
      color = Colors.white;
      boxShadow = new BoxShadow();
    }
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: tamano,
      height: tamano,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [boxShadow],
          border: Border.all(color: Colors.grey)),
    );
  }
}

class _Slides extends StatefulWidget {
  final List<Widget> slides;
  final ViolationSummaryViewModel model;

  const _Slides(this.slides, this.model);

  @override
  __SlidesState createState() => __SlidesState();
}

class __SlidesState extends State<_Slides> {
  final pageViewController = new PageController();

  @override
  void initState() {
    pageViewController.addListener(() {
      widget.model.currentPage = pageViewController.page;
    });
    super.initState();
  }

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170.h,
      child: PageView(
        controller: pageViewController,
        children: widget.slides.map((slide) => _Slide(slide)).toList(),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Widget slide;
  const _Slide(this.slide);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: slide,
    );
  }
}
