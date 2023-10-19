part of violation_by_property_view;

class _ViolationByPropertyMobileState extends StatefulWidget {
  @override
  __ViolationByPropertyMobileStateState createState() =>
      __ViolationByPropertyMobileStateState();
}

class __ViolationByPropertyMobileStateState
    extends State<_ViolationByPropertyMobileState> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViolationByPropertyViewModel>.reactive(
        viewModelBuilder: () => ViolationByPropertyViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() async {
            await model.load(ModalRoute.of(context).settings.arguments);
          });
        },
        builder: (context, model, child) => model.busy
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : BackgroundPattern(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _header(model),
                      Container(
                        margin: EdgeInsets.only(bottom: 30.0),
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                              offset: Offset(0.0, 6.0),
                              blurRadius: 2,
                              color: Colors.black.withOpacity(0.1))
                        ]),
                        child: Container(
                          margin: EdgeInsets.all(20.0.w),
                          child: _Slides(
                              model.violations
                                  .map((e) => _page(
                                      e,
                                      model,
                                      model.violations.indexWhere(
                                              (element) => element.id == e.id) +
                                          1))
                                  .toList(),
                              model),
                        ),
                      ),
                      if (!model.isSingleViolation)
                        _Dots(model.violations.length, model),
                      if (!model.isSingleViolation)
                        SizedBox(
                          height: 10.0,
                        ),
                      if (!model.isSingleViolation)
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              model.violations[0]?.property
                                      ?.specialInstructions ??
                                  '',
                              style: AppTheme.instance
                                  .textStyleSmall(color: Colors.grey[700]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color(0XFFF2F2F2),
                              border: Border.all(color: Colors.grey[400]),
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      if (!model.isSingleViolation)
                        SizedBox(
                          height: 10.0,
                        ),
                      ButtonsChoose(
                        buttons: [
                          ButtonsChooseModel(
                              icon: Center(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: Container(
                                    child: Icon(
                                      Icons.arrow_back_ios_rounded,
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color:
                                          AppTheme.instance.primaryColorBlue),
                                ),
                              ),
                              title: Container(
                                margin: EdgeInsets.only(top: 10.0),
                                child: Text('Back',
                                    style: AppTheme.instance.textStyleSmall(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme
                                            .instance.primaryColorBlue)),
                              ),
                              function: () async {
                                await model.navigatoToBack();
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
  }

  GestureDetector _page(ViolationModel _violation,
      ViolationByPropertyViewModel model, int index) {
    final FocusNode focusViolation = FocusNode();
    final TextEditingController controller = TextEditingController();
    controller.text = _violation.description;
    return GestureDetector(
      onTap: () {
        focusViolation?.unfocus();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!model.changeTextInstructions)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      if (!model.isSingleViolation)
                        Row(
                          children: [
                            Expanded(
                              child: _infoViolation(
                                  title: '${Config.oneViolation}: ',
                                  description: index.toString()),
                            ),
                          ],
                        ),
                      if (model.isSingleViolation)
                        _infoViolationSummary(
                            title: '${Config.oneViolation} Type: ',
                            description:
                                '${_violation.violationType.join(", ")}.'),
                      SizedBox(
                        height: 5.0,
                      ),
                      _infoViolation(
                          title: 'Added By: ',
                          description: _violation.employeeName),
                      SizedBox(
                        height: 5.0,
                      ),
                      _infoViolation(
                          title: 'Time of ${Config.oneViolation}: ',
                          description: model.loadHours(_violation.createdAt.local())),
                      SizedBox(
                        height: 5.0,
                      ),
                      _infoViolation(
                          title: 'Date of ${Config.oneViolation}: ',
                          description: model.loadDates(_violation.createdAt.local())),
                    ],
                  ),
                ),
              ],
            ),
          if (!model.changeTextInstructions)
            SizedBox(
              height: 20.0,
            ),
          if (!model.changeTextInstructions)
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _violation.images
                  .map(
                    (e) => Container(
                      height: 80.0.w,
                      width: 80.0.w,
                      decoration: BoxDecoration(
                          color: Colors.grey[700],
                          border:
                              Border.all(color: Colors.grey[700], width: 0.1),
                          image: DecorationImage(
                              fit: BoxFit.cover, image: NetworkImage(e))),
                    ),
                  )
                  .toList(),
            )),
          Flexible(
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      if (!model.changeTextInstructions) {
                        model.changeText();
                      } else {
                        model.updateTextViolation(_violation, controller.text);
                      }
                    },
                    icon: Icon(
                      !model.changeTextInstructions ? Icons.edit : Icons.save,
                      color: AppTheme.instance.primaryColorBlue,
                    )),
                !model.changeTextInstructions
                    ? Expanded(
                        child: Container(
                          child: _description(_violation),
                        ),
                      )
                    : Expanded(
                        child: Container(
                          child: _aditPropertyInstructionsTextField(
                              _violation, controller, focusViolation),
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _aditPropertyInstructionsTextField(ViolationModel violation,
      TextEditingController controller, FocusNode focusViolation) {
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
            controller: controller,
            focusNode: focusViolation,
            maxLines: 5,
            style: AppTheme.instance.textStyleSmall(
                fontWeight: FontWeight.w500, color: Color(0xFFAEAEAE)),
            decoration: InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.all(10.0),
                fillColor: Colors.white,
                hintText: 'Take a photo of unit 221',
                enabledBorder: const OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
        ],
      ),
    );
  }

  RichText _description(ViolationModel violation) {
    return RichText(
      text: new TextSpan(
        style: AppTheme.instance
            .textStyleSmall(color: Colors.black, fontWeight: FontWeight.w600),
        children: <TextSpan>[
          new TextSpan(
              text: '${Config.oneViolation} Description: ',
              style: AppTheme.instance.textStyleSmall(
                  color: Colors.black, fontWeight: FontWeight.w600)),
          new TextSpan(
            text: violation.description,
            style: AppTheme.instance.textStyleSmall(color: Colors.grey[700]),
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Container _header(ViolationByPropertyViewModel model) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
      child: Container(
        margin: EdgeInsets.all(20.0.w),
        child: Column(
          children: [
            _namePropertyAndFlag(model.violations[0], model),
            _violationInfo(model.violations[0], model, model.violations.length)
          ],
        ),
      ),
    );
  }

  Row _namePropertyAndFlag(
      ViolationModel violation, ViolationByPropertyViewModel model) {
    return Row(
      children: [
        Text('${violation.property.propertyName}:',
            style: AppTheme.instance.textStyleSmall(
                color: AppTheme.instance.primaryDarkColorBlue,
                fontWeight: FontWeight.w600)),
        Spacer(),
      ],
    );
  }

  Row _violationInfo(ViolationModel violation,
      ViolationByPropertyViewModel model, int numberOfViolations) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 5.0,
              ),
              _infoViolation(
                  title: 'Market: ',
                  description: violation.property.marketName),
              SizedBox(
                height: 5.0,
              ),
              if (!model.isSingleViolation)
                _infoViolation(
                    title: 'Number of ${Config.violations}: ',
                    description: numberOfViolations.toString()),
              SizedBox(
                height: 5.0,
              ),
              _infoViolation(
                  title: 'Location: ', description: violation.property.address),
            ],
          ),
        ),
      ],
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
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
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
    maxLines: 3,
    overflow: TextOverflow.ellipsis,
  );
}

class _Dots extends StatelessWidget {
  final int totalSlides;
  final ViolationByPropertyViewModel model;

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
  final ViolationByPropertyViewModel model;

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
  final ViolationByPropertyViewModel model;

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
      height: 250.h,
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
