part of watchlist_view;

class _WatchlistViewMobileState extends StatefulWidget {
  @override
  __WatchlistViewMobileStateState createState() =>
      __WatchlistViewMobileStateState();
}

class __WatchlistViewMobileStateState extends State<_WatchlistViewMobileState> {
  Timer _everySecond;

  @override
  void initState() {
    Timer.periodic(Duration(milliseconds: 200), (_) {
      if (!mounted) return;
      setState(() {});
    });
    super.initState();
  }

  dispose() {
    _everySecond?.cancel();
    super.dispose();
  }

  void _onEditImage(WatchlistModel model, WatchlistViewModel viewModel) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ImageSourcePicker(
            onImageSelected: (dynamic image) {
              viewModel.selectImage(image, model);
            },
            croppedImage: true,
            croppedSize: 200,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WatchlistViewModel>.reactive(
        viewModelBuilder: () => WatchlistViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() async {
            await model.load();
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
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        _infoDateService(model),
                        SizedBox(
                          height: 20.0,
                        ),
                        _infoLocationService(model),
                        SizedBox(
                          height: 20.0,
                        ),
                        Divider(
                          thickness: 2.0,
                        ),
                        _textToComplete(model),
                        _task(model, 'Check in to property', true),
                        _task(model, 'Take picture of the waste area', true),
                        InkWell(
                          onTap: () => model.changeDocumentIncidents(),
                          child: _task(
                              model,
                              'Document all ${Config.violations.toLowerCase()} during service',
                              model.documentIncidents),
                        ),
                        _task(model, 'Confirm all watch list units',
                            model.endWatchlist),
                        Container(
                          child: Column(
                            children: model.watchlist
                                .map((e) => Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 40),
                                      padding: EdgeInsets.only(
                                          bottom: 5.0.h, top: 10.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Image.asset(
                                              e.image == null
                                                  ? 'assets/icons/done.png'
                                                  : 'assets/icons/check_green.png',
                                              width: 30.0,
                                              color: e.image == null
                                                  ? Colors.black
                                                  : null,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0.w),
                                            child: Text(e.name,
                                                style: AppTheme.instance
                                                    .textStyleSmall(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                          ),
                                          _photos(e, model),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                        model.checkInModel.imageCheckOut != null
                            ? _task(model,
                                'Take a check out picture of waste area', true)
                            : _takePhotoCheckOut(
                                model,
                                'Take a check out picture of waste area',
                              ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          child: ButtonsChoose(
                            buttons: [
                              ButtonsChooseModel(
                                  margin: EdgeInsets.symmetric(vertical: 10.0),
                                  icon: Icon(
                                    Icons.arrow_back_ios_sharp,
                                    size: 23.0,
                                    color: Color(0XFF606060),
                                  ),
                                  rounderColor: Colors.black,
                                  title: Text('Back',
                                      style: AppTheme.instance.textStyleSmall(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),
                                  function: () async {
                                    await model.goToManage();
                                  }),
                              ButtonsChooseModel(
                                  icon: model.performingTask
                                      ? LoadingCustom()
                                      : Image.asset(
                                          'assets/icons/check_green.png'),
                                  title: Text('Send',
                                      style: AppTheme.instance.textStyleSmall(
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme
                                              .instance.primaryColorBlue)),
                                  function: () async {
                                    String response = await model.checkOut();
                                    if (response != 'success') {
                                      ScaffoldMessenger.of(
                                              locator<DialogService>()
                                                  .scaffoldKey
                                                  .currentContext)
                                          .showSnackBar(SnackBar(
                                        content: Text(response),
                                      ));
                                    } else {
                                      model.endCheckOutandGoToHome();
                                    }
                                  }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }

  Row _photos(WatchlistModel model, WatchlistViewModel viewModel) {
    return Row(
      children: [
        Container(
          height: 45.0,
          child: model.imageFile != null || model.image != null
              ? Stack(
                  children: [
                    Container(
                      width: 45.w,
                      height: 45.w,
                      margin: EdgeInsets.only(right: 10.0),
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: Color(0xffeeefee),
                          image: model.imageFile != null || model.image != null
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: model.imageFile != null
                                      ? FileImage(model.imageFile)
                                      : NetworkImage(model.image))
                              : null,
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    Positioned(
                      top: 0,
                      child: InkWell(
                        child: Icon(
                          Icons.highlight_remove,
                          size: 20.sp,
                        ),
                        onTap: () {
                          viewModel.removeImage(model);
                        },
                      ),
                    ),
                  ],
                )
              : InkWell(
                  onTap: () {
                    _onEditImage(model, viewModel);
                  },
                  child: Container(
                      width: 45.w,
                      height: 45.w,
                      margin: EdgeInsets.only(right: 10.0),
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: Color(0xffeeefee),
                          image: DecorationImage(
                              image: AssetImage('assets/icons/camera.png')),
                          borderRadius: BorderRadius.circular(10.0))),
                ),
        ),
      ],
    );
  }

  Container _infoDateService(WatchlistViewModel model) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            child: Column(
              children: [
                Text(
                    model.dateToService(TimestampUtils.safeLocal(
                        model.checkInModel.dateCheckIn)),
                    style: AppTheme.instance.textStyleRegular(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                Text(
                    model.dayToService(TimestampUtils.safeLocal(
                        model.checkInModel.dateCheckIn)),
                    style: AppTheme.instance.textStyleRegular(
                        color: Colors.black, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Spacer(),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Check in: ${model.loadHours(model.checkInModel.dateCheckIn.local())}',
                    style: AppTheme.instance.textStyleSmall(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                Text(model.checkInModel.marketName,
                    style: AppTheme.instance.textStyleSmall(
                        color: Colors.black, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Spacer()
        ],
      ),
    );
  }

  Container _infoLocationService(WatchlistViewModel model) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            child: Column(
              children: [
                Image.asset(
                  'assets/icons/done.png',
                  width: 30.0,
                  color: Colors.black,
                )
              ],
            ),
          ),
          Spacer(),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${model.checkInModel.propertyName}',
                    style: AppTheme.instance.textStyleSmall(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                Text('Info: ${model.checkInModel.units}',
                    style: AppTheme.instance
                        .textStyleVerySmall(color: Colors.black)),
                Text('Opening Checklist',
                    style: AppTheme.instance
                        .textStyleVerySmall(color: Colors.black)),
              ],
            ),
          ),
          Spacer()
        ],
      ),
    );
  }

  Container _textToComplete(WatchlistViewModel model) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            child: Column(
              children: [Icon(Icons.list)],
            ),
          ),
          SizedBox(
            width: 30.0,
          ),
          Container(
            child: Text('Tasks to Complete',
                style: AppTheme.instance.textStyleSmall(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          Spacer()
        ],
      ),
    );
  }

  Container _task(WatchlistViewModel model, String text, bool check) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Container(
            child: Image.asset(
              !check ? 'assets/icons/done.png' : 'assets/icons/check_green.png',
              width: 30.0,
              color: !check ? Colors.black : null,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Container(
              child: Text(text,
                  style: AppTheme.instance.textStyleSmall(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Container _takePhotoCheckOut(WatchlistViewModel model, String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          EvidencePicture(
              icon: Container(
                child: Image.asset(
                  'assets/icons/done.png',
                  width: 30.0,
                  color: Colors.black,
                ),
              ),
              changeIcon: true,
              evidenceUpdateMedia: EvidenceUpdateMedia(
                  "checkIns",
                  "check_out",
                  "imageCheckOut",
                  "checkIn_resources",
                  " Uploading checkout image "),
              url: model.checkInModel.imageCheckOut),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Container(
              child: Text(text,
                  style: AppTheme.instance.textStyleSmall(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
