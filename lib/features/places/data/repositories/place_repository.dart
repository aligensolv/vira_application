import 'package:vira/features/places/data/datasource/place_remote_data_source.dart';
import '../models/place.dart';

class PlaceRepository {
  final PlaceRemoteDataSource _remoteDataSource;

  PlaceRepository(this._remoteDataSource);

  Future<List<Place>> getPlaces({int? regionId}) async {
    final rawData = await _remoteDataSource.getPlaces(regionId: regionId);
    return rawData.map((json) => Place.fromJson(json)).toList();
  }
}