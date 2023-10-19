import 'package:compound/shared_components/app-bar/app_bar_view_model.dart';
import 'package:compound/shared_components/maps/maps_custom_view_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

class MapCustom extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  final bool showBanner;
  final double startLatitude;
  final double startLongitude;
  final double endLatitude;
  final double endLongitude;
  MapCustom(
      {Key key,
      this.height,
      this.showBanner = false,
      this.startLatitude,
      this.startLongitude,
      this.endLatitude = 33.7546,
      this.endLongitude = -84.4065})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _MapCustomState createState() => _MapCustomState();
}

class _MapCustomState extends State<MapCustom> {
  Set<Circle> circles;

  @override
  void initState() {
    circles = Set.from([
      Circle(
          circleId: CircleId('distance'),
          center: LatLng(widget.startLatitude, widget.startLongitude),
          radius: 1600,
          strokeColor: Colors.transparent,
          fillColor: Colors.blue[300].withOpacity(0.4))
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MapCustomViewModel>.reactive(
        viewModelBuilder: () => MapCustomViewModel(),
        onModelReady: (model) {
          model.load(widget.startLatitude, widget.startLongitude,
              widget.endLatitude, widget.endLongitude);
        },
        builder: (context, model, child) => Column(
              children: [
                widget.height != null
                    ? Container(height: widget.height.h, child: _showMap(model))
                    : Expanded(child: _showMap(model)),
                if (this.widget.showBanner)
                  Container(
                    height: 50.h,
                    decoration: BoxDecoration(color: Color(0XFFF2F2F2)),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('You have selected a property.',
                              style: AppTheme.instance.textStyleSmall()),
                          Text('Choose one of the following options.',
                              style: AppTheme.instance
                                  .textStyleSmall(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                  )
              ],
            ));
  }

  Widget _showMap(MapCustomViewModel model) {
    try {
      return widget.startLatitude != null
          ? GoogleMap(
              mapType: MapType.normal,
              zoomControlsEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                new Factory<OneSequenceGestureRecognizer>(
                  () => new EagerGestureRecognizer(),
                ),
              ].toSet(),
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.startLatitude, widget.startLongitude),
                zoom: 13.6,
              ),
              markers: model.markers,
              circles: circles,
              onMapCreated: (GoogleMapController controller) {
                model.controller.complete(controller);
              },
            )
          : Container();
    } catch (e) {
      return Container();
    }
  }
}
