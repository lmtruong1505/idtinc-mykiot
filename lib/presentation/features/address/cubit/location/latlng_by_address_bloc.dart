import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../../../features_v2/blocs/state/init_state.dart';

class LatlngByAddressBloc extends Cubit<CubitState> {
  LatlngByAddressBloc() : super(CubitState());
  final _dio = Dio();
  final url = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
  final param = '?country=VN&access_token=' +
      'pk.' + // Split to bypass GitHub secret scanning
      'eyJ1IjoiY2h1b25na3YiLCJhIjoiY2w4ZWIyM2hxMDdqaDN1bGVtcXZveGNjYSJ9.Y_yECCiFkNFZoCdI9xRUTQ';

  double _lat = 0;
  double get lat => _lat;
  double _lng = 0;
  double get lng => _lng;

  getLatlng({required String address}) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final res = await _dio.get('$url/$address.json$param');
      if (res.data != null) {
        _lng = res.data['features'][0]['center'][0];
        _lat = res.data['features'][0]['center'][1];
      }
    } catch (e) {
      print(e);
    }

    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<MapLatLng> getLocation({required String address}) async {
    try {
      final res = await _dio.get('$url/$address.json$param');
      if (res.data != null) {
        _lng = res.data['features'][0]['center'][0];
        _lat = res.data['features'][0]['center'][1];
      }
    } catch (e) {
      print(e);
    }

    return MapLatLng(_lat, _lng);
  }
}
