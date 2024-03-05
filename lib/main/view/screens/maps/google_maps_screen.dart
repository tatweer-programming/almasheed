import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/services/dep_injection.dart';
import '../../../../generated/l10n.dart';
import '../../../bloc/main_bloc.dart';

class GoogleMapsScreen extends StatelessWidget {
  const GoogleMapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const CameraPosition saudiArabia = CameraPosition(
      target: LatLng(24.774265, 46.738586),
      zoom: 14.4746,
    );
    MainBloc bloc = sl();
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                markers: bloc.markers,
                initialCameraPosition: saudiArabia,
                onTap: (tappedPoint) {
                  bloc.add(GetLocationEvent(tappedPoint: tappedPoint));
                },
                onMapCreated: (GoogleMapController controller) {
                  bloc.add(OnMapCreatedEvent(controller: controller));
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                child: SizedBox(
                  width: 25.w,
                  child: defaultButton(
                    onPressed: () async {
                      await placemarkFromCoordinates(
                          bloc.latLng!.latitude, bloc.latLng!.longitude)
                          .then((value) {
                        String locationName =
                        "${value.first.country} - ${value.first
                            .subAdministrativeArea} - ${value.first.street}";
                        bloc.add(GetNameOfLocationEvent(locationName));
                        context.pop();
                      });
                    },
                    text: S
                        .of(context)
                        .ok,
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              bloc.add(GetMyCurrentLocationEvent());
            },
            label: Text(S
                .of(context)
                .myCurrentLocation),
            icon: const Icon(Icons.directions_boat),
          ),
        );
      },
    );
  }
}
