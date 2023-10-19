import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:compound/core/services/connectivity/connectivity_service.dart';
import 'package:compound/locator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ViewUtils{

    static const String sourceStorage = "firestore_storage";
    static const String sourceAssets = "assets";
    static const String sourceNetwork = "network";
    static const String LoadingIndicatorTitle = '^';

    static int nowStart(){
        var time = DateTime.now();
        time = new DateTime(time.year, time.month, time.day, 0, 0, 0, 0, 0);
        return time.millisecondsSinceEpoch;
    }

    static int nowEnd(){
        var time = DateTime.now();
        time = new DateTime(time.year, time.month, time.day, 23, 59, 59, 999);
        return time.millisecondsSinceEpoch;
    }


    static String getUIDate(DateTime date){
       return  DateFormat('MM/dd/yy').format(date); 
    }

    static String getUITime(DateTime date){
       return  DateFormat('HH:mma').format(date); 
    }

    static ConnectivityService connectivityService = locator<ConnectivityService>();

    static Future<bool> isConnected() {
      return connectivityService.checkConnectivity();
    }

    static Future<ImageViewHelper> getImageViewHelper(String source, {String sourceType = ViewUtils.sourceNetwork}){
        switch(sourceType){
           case ViewUtils.sourceAssets: return getImageViewHelperAsset(source); break;
           case ViewUtils.sourceStorage: return getImageViewHelperStorage(source); break;
           default: return getImageViewHelperNetwork(source); break;
        }
    }

   static Future<ImageViewHelper> getImageViewHelperStorage(String imageUrl){

      Completer<ImageViewHelper> completer = Completer<ImageViewHelper>();

      var downloadUrl = () async{
          final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(imageUrl);
          var url = await firebaseStorageRef.getDownloadURL();
          var imageProvider =  CachedNetworkImageProvider(url);
          imageProvider.resolve(ImageConfiguration())
              .addListener(ImageStreamListener((ImageInfo imageInfo, bool _) {
                completer.complete(ImageViewHelper(imageInfo, imageProvider));
          }));
      };

      downloadUrl();
      return completer.future;
    }

    static Future<ImageViewHelper> getImageViewHelperNetwork(String imageUrl){

      Completer<ImageViewHelper> completer = Completer<ImageViewHelper>();
      var imageProvider =  CachedNetworkImageProvider(imageUrl);
      imageProvider.resolve(ImageConfiguration())
          .addListener(ImageStreamListener((ImageInfo imageInfo, bool _) {
            if(!completer.isCompleted)
              completer.complete(ImageViewHelper(imageInfo, imageProvider));
      }));

      return completer.future;
    }

    static Future<ImageViewHelper> getImageViewHelperAsset(String path){

      Completer<ImageViewHelper> completer = Completer<ImageViewHelper>();
      var imageProvider =  AssetImage(path);
      imageProvider.resolve(ImageConfiguration())
          .addListener(ImageStreamListener((ImageInfo imageInfo, bool _) {
            completer.complete(ImageViewHelper(imageInfo, imageProvider));
      }));

      return completer.future;
    }

    static String convertUrlToYoutubeId(String url, {bool trimWhitespaces = true}) {
      assert(url?.isNotEmpty ?? false, 'Url cannot be empty');
      if (!url.contains("http") && (url.length == 11)) return url;
      if (trimWhitespaces) url = url.trim();

      for (var exp in [
        RegExp(
            r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
        RegExp(
            r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
        RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
      ]) {
        Match match = exp.firstMatch(url);
        if (match != null && match.groupCount >= 1) return match.group(1);
      }

      return null;
    }

    static String getNicknameIdentifierMap(Map<String, dynamic> data){

      if(data['firstName'] != null && data['firstName'] != "" &&
          data['lastName'] != null && data['lastName'] != ""){
        return data['firstName']  + " " + data['lastName'];
      }     

      if(data['firstName'] != null && data['firstName'] != ""){
        return data['firstName'];
      }                      

      return  data['email'] != null? data['email'].trim() : "Unknown";
    }

}

class ImageViewHelper{

  ImageInfo imageInfo;
  ImageProvider imageProvider;

  ImageViewHelper(this.imageInfo, this.imageProvider);

  double getViewHeight(BuildContext context){
    return  MediaQuery.of(context).size.width / imageInfo.image.width * imageInfo.image.height;
  }

}