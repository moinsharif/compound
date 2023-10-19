import 'package:compound/modules/calendar/calendar_schedule_view_model.dart';
import 'package:compound/shared_components/add_porter_schedule/add_porter_schedule.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/colors_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

class CalendarScheduleState extends StatefulWidget {
  @override
  _CalendarScheduleStateState createState() => _CalendarScheduleStateState();
}

class _CalendarScheduleStateState extends State<CalendarScheduleState> {
  final TextEditingController streetController = TextEditingController();
  final FocusNode focusStreet = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CalendarScheduleViewModel>.reactive(
        viewModelBuilder: () => CalendarScheduleViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() async {
            await model.load();
            streetController.addListener(() {
              model.updateProperites(
                  streetController.text != null && streetController.text != ""
                      ? streetController.text
                      : null);
            });
          });
        },
        builder: (context, model, child) => model.busy
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 10.0),
                    child: Row(
                      children: [
                        Container(
                          height: 30.0,
                          width: 230.w,
                          child: _streets(model, context),
                        )
                      ],
                    ),
                  ),
                  model.properties.length > 0
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              _tableDays(model),
                              _tableSearch(model),
                            ],
                          ))
                      : Center(
                          child: Text("Nothing to show",
                              style: AppTheme.instance.textStyleSmall())),
                ],
              ));
  }

  Table _tableDays(CalendarScheduleViewModel model) {
    return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        defaultColumnWidth: FixedColumnWidth(175.0.sp),
        children: [
          TableRow(
              decoration: BoxDecoration(color: Colors.grey[100]),
              children: model.daysToService
                  .map((e) => Container(
                        padding: EdgeInsets.only(
                            left: 10.0, top: 10.0, bottom: 10.0),
                        child: Text(e.nameDay,
                            style: AppTheme.instance.textStyleSmall(
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                      ))
                  .toList()
                ..insert(0, Container()))
        ]);
  }

  Table _tableSearch(CalendarScheduleViewModel model) {
    return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        defaultColumnWidth: FixedColumnWidth(175.0.sp),
        children: model.propertiesFiltered.length > 0
            ? _createList(model.propertiesFiltered, model)
            : _createList(model.properties, model));
  }

  List<TableRow> _createList(
      List<PropertyModel> properties, CalendarScheduleViewModel model) {
    return properties
        .map((e) => TableRow(
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Color(0XFF4A4A4A).withOpacity(0.5)))),
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(e.propertyName,
                    style: AppTheme.instance.textStyleSmall(
                        fontWeight: FontWeight.w600, color: Colors.black)),
              ),
            ]..addAll(model.daysToService.map((day) {
                var evalDay = e.configProperty.daysSelected.firstWhere(
                    (element) => (element.id == day.id),
                    orElse: () => null);
                var end = !e.configProperty.end ||
                        (e.configProperty.end &&
                            e.configProperty.endDate
                                .toDate()
                                .isAfter(day.date.toDate()))
                    ? true
                    : false;
                if (evalDay != null && end) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                            padding: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                                color: model.getColor(e, day),
                                border: Border.all(
                                    color: AppTheme.instance.colorGreyLight),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Column(
                              children: [
                                _text(model.getHour(e.configProperty.startTime,
                                    e.configProperty.endTime)),
                                _text(model.getDifferenceHour(
                                    e.configProperty.startTime,
                                    e.configProperty.endTime)),
                                _textSmall(
                                    "Local Time: " + model.getLocalTime(e))
                              ],
                            )),
                        SizedBox(
                          width: 3.0,
                        ),
                        model.validateAddPorter(e, day)
                            ? GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder:
                                          (BuildContext context, _, __) {
                                        return AddPorterSchedule(
                                            e, day, model.checkinsToday);
                                      }));
                                },
                                child: Container(
                                  height: 45.0,
                                  width: 25.0,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              AppTheme.instance.colorGreyLight),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                height: 45.0,
                                width: 25.0,
                              )
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              }))))
        .toList();
  }

  Container _text(String data) {
    return Container(
      padding: EdgeInsets.only(left: 8.0),
      child: Text(data,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: AppTheme.instance.textStyleSmall(
              fontWeight: FontWeight.w500, color: Colors.black)),
    );
  }

  Container _textSmall(String data) {
    return Container(
      padding: EdgeInsets.only(left: 4.0),
      child: Text(data,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: AppTheme.instance.textStyleVerySmall(
              fontWeight: FontWeight.w500, color: Colors.black)),
    );
  }

  Widget _streets(CalendarScheduleViewModel model, BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: streetController,
        focusNode: focusStreet,
        onSubmitted: (_) {
          model.changeArrowPositionStreet(false);
          streetController.clear();
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
              padding: EdgeInsets.only(bottom: 2.0),
              icon: Icon(streetController.text.length > 0
                  ? Icons.close_rounded
                  : !model.openBoxProperty
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up),
              onPressed: () {
                if (streetController.text.length > 0) {
                  streetController.clear();
                } else if (model.openBoxProperty) {
                  model.changeArrowPositionStreet(false, opneBox: 'close');
                } else {
                  model.changeArrowPositionStreet(true, opneBox: 'open');
                }
              },
              color: Color(0xff004A05),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsUtils.getMaterialColor(0x304A4A4A),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            hintText: 'Filter by: Property Name'),
      ),
      suggestionsCallback: (pattern) async {
        List<PropertyModel> data = await model.getProperties(pattern);
        setState(() {});
        return data;
      },
      noItemsFoundBuilder: (context) => Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(model.properties == null || model.properties.length <= 0
              ? 'You don\'t have properties'
              : 'this search does not match'),
        ),
      ),
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      itemBuilder: (context, PropertyModel suggestion) {
        return ListTile(
            title: Text(suggestion.propertyName,
                style: AppTheme.instance.textStyleSmall()));
      },
      onSuggestionSelected: (PropertyModel suggestion) async {
        model.changeArrowPositionStreet(false);
        streetController.text = suggestion.propertyName;
        model.chooseProperty(suggestion);
      },
      suggestionsBoxController: model.propertyBoxController,
    );
  }
}
