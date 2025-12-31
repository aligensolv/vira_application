import 'package:vira/features/region/data/datasource/region_remote_data_source.dart';
import 'package:vira/features/region/data/models/region.dart';

class RegionRepository {
  final RegionRemoteDataSource _remoteDataSource;

  RegionRepository(this._remoteDataSource);

  Future<List<Region>> getRegions() async {
    final data = await _remoteDataSource.getRegions();
    return data.map((json) => Region.fromJson(json)).toList();
  }
}