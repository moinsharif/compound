import 'dart:io';
import 'package:compound/core/base/base_view_model.dart';

class ProfileVideoViewModel extends BaseViewModel {

    File _selectedImage;
    File get selectedImage => _selectedImage;

    Future selectImage(dynamic image) async {
      if (image != null) {
        _selectedImage = image;
        notifyListeners();
      }
    }

    String get multimediaMissingMessage => "There is no content uploaded here";


}