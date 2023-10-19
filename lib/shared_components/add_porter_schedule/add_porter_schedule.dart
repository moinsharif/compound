import 'package:compound/core/services/dialog_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/shared_components/add_porter_schedule/add_porter_schedule_view_model.dart';
import 'package:compound/shared_components/buttons/button_icon.dart';
import 'package:compound/shared_models/checkIn_model.dart';
import 'package:compound/shared_models/days_selected.dart';
import 'package:compound/shared_models/employee_detail_model.dart';
import 'package:compound/shared_models/porter_model.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_models/watchlist_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/colors_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AddPorterSchedule extends StatefulWidget {
  final PropertyModel property;
  final DaysSelected dateService;
  final List<CheckInModel> checkinsToday;
  AddPorterSchedule(this.property, this.dateService, this.checkinsToday)
      : super();

  @override
  _AddPorterScheduleState createState() => _AddPorterScheduleState();
}

class _AddPorterScheduleState extends State<AddPorterSchedule> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final TextEditingController searchPorterController = TextEditingController();
  final FocusNode focusSearchPorter = FocusNode();

  List<WatchlistModel> watchList = [];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddPorterScheduleViewModel>.reactive(
        viewModelBuilder: () => AddPorterScheduleViewModel(),
        onModelReady: (model) {
          model.load(widget.dateService.date.toDate(), widget.property);
          model.portersAvailables = widget.property.configProperty.porters
              .where((element) => (element.temporary == null ||
                  element.temporary == false ||
                  (element.temporary == true &&
                      element.temporaryDate.local().year ==
                          widget.dateService.date.toDate().year &&
                      element.temporaryDate.local().month ==
                          widget.dateService.date.toDate().month &&
                      element.temporaryDate.local().day ==
                          widget.dateService.date.toDate().day)))
              .toList();
          searchPorterController.addListener(() {
            model.addTemporalPorter(
                searchPorterController.text != null &&
                        searchPorterController.text != ""
                    ? searchPorterController.text
                    : null,
                widget.property);
          });
        },
        builder: (context, model, child) => FormBuilder(
            key: _fbKey,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.black.withOpacity(0.5),
              body: Center(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0.w),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Summary',
                              style: AppTheme.instance.textStyleRegular()),
                          SizedBox(
                            height: 15.0,
                          ),
                          _infoViolation(
                              title: 'Market: ',
                              description: widget.property.marketName),
                          _infoViolation(
                              title: 'Name: ',
                              description: widget.property.propertyName),
                          _infoViolation(
                              title: 'Location: ',
                              description: widget.property.address),
                          _infoViolation(
                              title: 'Time: ',
                              description:
                                  '${model.getHour(widget.property.configProperty.startTime, widget.property.configProperty.endTime)} (${model.getDifferenceHour(widget.property.configProperty.startTime, widget.property.configProperty.endTime)})'),
                          Text('Porters',
                              style: AppTheme.instance.textStyleSmall(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                          Column(
                            children: model.portersAvailables
                                .map((e) => Row(
                                      children: [
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text('-',
                                            style: AppTheme.instance
                                                .textStyleSmall(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Row(
                                          children: [
                                            Text('${e.lastName} ${e.firstName}',
                                                style: AppTheme.instance
                                                    .textStyleSmall()),
                                            if (e.temporary != null &&
                                                e.temporary == true)
                                              Text(' (Temporary porter)',
                                                  style: AppTheme.instance
                                                      .textStyleSmall()),
                                            if (widget.checkinsToday.firstWhere(
                                                    (element) => (element
                                                                .employeedId ==
                                                            e.id &&
                                                        widget.property.id ==
                                                            element.propertyId),
                                                    orElse: () => null) !=
                                                null)
                                              Text(' (CheckIn On)',
                                                  style: AppTheme.instance
                                                      .textStyleSmall()),
                                          ],
                                        )
                                      ],
                                    ))
                                .toList(),
                          ),
                          Text('Add temporary porter',
                              style: AppTheme.instance.textStyleRegular()),
                          _searchEmployee(model, context),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: FormBuilderTextField(
                                  name: 'watchlist',
                                  focusNode: model.focusInstructions,
                                  onChanged: (_) {
                                    model.notifyListeners();
                                  },
                                  controller: model.controller,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(context),
                                  ]),
                                  style: AppTheme.instance.textStyleSmall(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFFAEAEAE), width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    contentPadding: EdgeInsets.all(10.0),
                                    fillColor: Colors.white,
                                    hintText: 'Add WatchList Unit',
                                    suffixIcon: InkWell(
                                      onTap: model.controller.text.length > 0
                                          ? () {
                                              if (model.controller.text.length >
                                                  0) {
                                                model.controller.clear();
                                              }
                                            }
                                          : null,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Icon(
                                          Icons.close_rounded,
                                          color:
                                              model.controller.text.length > 0
                                                  ? Color(0xff004A05)
                                                  : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              SizedBox(
                                height: 45.0,
                                width: 45.0,
                                child: ButtonIcon(
                                  onPress: () {
                                    if (!_fbKey.currentState.validate()) {
                                      ScaffoldMessenger.of(
                                              locator<DialogService>()
                                                  .scaffoldKey
                                                  .currentContext)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Please add a name to watchlist.'),
                                      ));
                                      return;
                                    }
                                    model.addWatchlist(
                                        widget.dateService.date.toDate(),
                                        widget.property);
                                  },
                                  icon: Icons.add,
                                  color: AppTheme.instance.primaryColorBlue,
                                ),
                              ),
                            ],
                          ),
                          showWatchlist(model, model.watchlist),
                          showWatchlist(model, model.addedWatchs),
                          _buttons(model)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }

  Container showWatchlist(
      AddPorterScheduleViewModel model, List<WatchlistModel> watchlist) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0.h),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: watchlist
                  .map((e) => Container(
                        margin: EdgeInsets.only(bottom: 10.0.h),
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: Color(0xffB5B2B2),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${e.name}',
                                style: AppTheme.instance.textStyleSmall(
                                    color: Color(0xff000000).withOpacity(1))),
                            Container(
                                height: 20.0,
                                width: 1.0,
                                color: Colors.grey[600]),
                            InkWell(
                              onTap: () {
                                model.removeWatchlist(e);
                              },
                              child: Icon(
                                Icons.clear,
                                size: 15.0,
                              ),
                            )
                          ],
                        ),
                      ))
                  .toList()),
        ));
  }

  Row _buttons(AddPorterScheduleViewModel model) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border:
                            Border.all(color: Color(0XFF606060), width: 1.5),
                        borderRadius: BorderRadius.circular(50.0)),
                    height: kIsWeb ? 30 : 30.w,
                    width: kIsWeb ? 30 : 30.w,
                    child: Icon(
                      Icons.arrow_back_ios_sharp,
                      size: 23.0,
                      color: Color(0XFF606060),
                    ),
                  ),
                ),
                Container(
                  child: Text('Cancel',
                      style: AppTheme.instance.textStyleSmall(
                          fontWeight: FontWeight.w600,
                          color: Color(0XFF606060))),
                )
              ],
            ),
          ),
          Spacer(),
          Column(
            children: [
              InkWell(
                onTap: () async {
                  model.updateProperty(widget.property);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Color(0XFF606060), width: 1.5),
                      borderRadius: BorderRadius.circular(50.0)),
                  height: kIsWeb ? 30 : 30.w,
                  width: kIsWeb ? 30 : 30.w,
                  child: model.busy
                      ? CircularProgressIndicator()
                      : Icon(
                          Icons.done,
                          size: 23.0,
                          color: Color(0XFF606060),
                        ),
                ),
              ),
              Container(
                child: Text('Complete',
                    style: AppTheme.instance.textStyleSmall(
                        fontWeight: FontWeight.w600, color: Color(0XFF606060))),
              )
            ],
          )
        ]);
  }

  Widget _searchEmployee(
      AddPorterScheduleViewModel model, BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: searchPorterController,
        focusNode: focusSearchPorter,
        onSubmitted: (_) {
          model.changeArrowPositionPorter(false);
          searchPorterController.clear();
        },
        style: AppTheme.instance.textStyleSmall(),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(kIsWeb ? 10.0 : 8.w),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsUtils.getMaterialColor(0x304A4A4A),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            suffixIcon: IconButton(
              icon: Icon(searchPorterController.text.length > 0
                  ? Icons.close_rounded
                  : !model.openBoxPorter
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up),
              onPressed: () {
                if (searchPorterController.text.length > 0) {
                  searchPorterController.clear();
                } else if (model.openBoxPorter) {
                  model.changeArrowPositionPorter(false, opneBox: 'close');
                } else {
                  model.changeArrowPositionPorter(true, opneBox: 'open');
                }
              },
              color: Color(0xff004A05),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsUtils.getMaterialColor(0x304A4A4A),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            hintText: 'Select a Porter'),
      ),
      suggestionsCallback: (pattern) async {
        List<EmployeeDetailModel> data = await model.getEmployees(pattern);
        setState(() {});
        return data;
      },
      noItemsFoundBuilder: (context) => Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(model.employees.length <= 0
              ? 'We don\'t find porters availables'
              : 'this search does not match'),
        ),
      ),
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      itemBuilder: (context, EmployeeDetailModel suggestion) {
        return ListTile(
            title: Text('${suggestion.lastName}, ${suggestion.firstName}',
                style: AppTheme.instance.textStyleSmall()));
      },
      onSuggestionSelected: (EmployeeDetailModel suggestion) {
        model.changeArrowPositionPorter(false);
        model.addEmployee(
            suggestion, widget.property, widget.dateService.date.toDate());
        searchPorterController.text =
            '${suggestion.lastName} ${suggestion.firstName}';
      },
      suggestionsBoxController: model.porterBoxController,
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
}
