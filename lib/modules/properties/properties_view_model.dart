import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/locator.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../core/services/navigation/navigator_service.dart';
import '../../router.dart';

class PropertiesViewModel extends BaseViewModel {
  final PropertyService _propertyService = locator<PropertyService>();
  final NavigatorService _navigationService = locator<NavigatorService>();
  List<PropertyModel> properties;
  List<PropertyModel> propertiesToShow;
  PropertyModel selectedPropertyModel;
  List<PropertyModel> propertiesFiltered = [];
  final SuggestionsBoxController propertyBoxController =
      SuggestionsBoxController();
  bool openBoxProperty = false;
  bool prevExist = false;
  bool nextExist = true;
  bool activeProperties = false;

  Future<void> load() async {
    setBusy(true);
    propertiesToShow =
        await _propertyService.getPropertiesAll(!activeProperties);
    properties = [...propertiesToShow];
    // properties = await _propertyService.getPaginatedProperties(
    //   cleanPaginate: true,
    // );
    setBusy(false);
  }

  Future<void> handleRadioValueActiveChange(bool value) async {
    this.activeProperties = value;
    setBusy(true);
    propertiesToShow =
        await _propertyService.getPropertiesAll(!activeProperties);
    properties = [...propertiesToShow];
    setBusy(false);
    notifyListeners();
  }

  navigateAddProperty() {
    _navigationService.navigateTo(AddPropertyViewRoute);
  }

  // Future<void> paginatedProperties(bool next, {int itemsPerPage = 4}) async {
  //   setBusy(true);
  //   properties = await _propertyService.getPaginatedProperties(
  //       next: next,
  //       itemsPerPage: itemsPerPage,
  //       showInactiveProp: activeProperties);
  //   if (properties.length == 0 || properties.length < itemsPerPage)
  //     nextExist = false;
  //   else
  //     nextExist = true;
  //   if (_propertyService.prevDocumentSnapshotList.length == 0)
  //     prevExist = false;
  //   else
  //     prevExist = true;
  //   setBusy(false);
  // }

  Future<List<PropertyModel>> getProperties(String search) async {
    if (propertiesToShow == null) {
      return List<PropertyModel>.empty();
    }
    properties = this
        .propertiesToShow
        .where((PropertyModel element) =>
            element.propertyName.toLowerCase().indexOf(search.toLowerCase()) >=
            0)
        .toList();
    return properties;
  }

  Future<void> propertyFlag(
      String propertyId, bool flagged, String text) async {
    setBusy(true);
    await _propertyService.updatePropertyFlag(propertyId, !flagged, text);
    setBusy(false);
  }

  void navigateToEditProperty(String propertyID) {
    _navigationService.navigateTo(EditPropertyViewRoute,
        arguments: {'propertyId': propertyID});
  }

  void updateProperites(String s) {
    if (properties.length <= 0) {
      return;
    }

    if (this.selectedPropertyModel != null &&
        this.selectedPropertyModel.propertyName == s) {
      return;
    } else if (this.selectedPropertyModel != null &&
        this.selectedPropertyModel.propertyName != s) {
      this.propertiesFiltered = [];
    }
    this.notifyListeners();
  }

  void changeArrowPositionStreet(bool value, {String opneBox}) {
    this.openBoxProperty = value;
    if (opneBox == 'open') {
      this.propertyBoxController.open();
    } else if (opneBox == 'close') {
      this.propertyBoxController.close();
    }
    notifyListeners();
  }

  void chooseProperty(PropertyModel property) {
    propertiesFiltered = [];
    propertiesFiltered = [...propertiesFiltered, property];
    this.selectedPropertyModel = property;
    notifyListeners();
  }

  void dispose() {
    _propertyService.prevDocumentSnapshotList.clear();
    _propertyService.nextDocumentSnapshot = null;
    _propertyService.prevDocumentSnapshot = null;
  }
}
