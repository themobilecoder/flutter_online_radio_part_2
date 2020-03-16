import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:online_radio/repository/stations_repository.dart';
import 'package:online_radio/station.dart';

class RadioBrowserRepository extends StationRepository {
  final Dio _dio;
  static final String _radioBrowserIp = 'http://45.77.62.161';
  final String _url = '$_radioBrowserIp/json/stations/bycountrycodeexact/';

  RadioBrowserRepository(this._dio) {
    _dio.interceptors.add(DioCacheManager(CacheConfig(baseUrl: _radioBrowserIp)).interceptor);
  }

  @override
  Future<List<Station>> getStationsByCountryPaginated(
    String country,
    int offset,
    int limit,
  ) async {
    final Response rawStationsJson = await _dio.get(
        _url + country + '?hidebroken=true&order=clickcount&reverse=true&offset=' + offset.toString() + '&limit=$limit',
        options: buildCacheOptions(Duration(days: 7)));
    final List<Station> stations = (rawStationsJson.data as List)
        .map((it) => Station(
              it['url_resolved'],
              it['favicon'],
              it['name'],
            ))
        .toList();
    return Future.value(stations);
  }
}
