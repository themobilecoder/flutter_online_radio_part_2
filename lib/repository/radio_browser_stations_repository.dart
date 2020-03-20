import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:online_radio/repository/stations_repository.dart';
import 'package:online_radio/station.dart';

class RadioBrowserRepository extends StationRepository {
  final Dio _dio;
  static final String _baseUrl = 'http://45.77.62.161';
  static final String _stationsByCountryCodeUrl = '$_baseUrl/json/stations/bycountrycodeexact/';

  RadioBrowserRepository(this._dio) {
    _dio.interceptors.add(DioCacheManager(CacheConfig(baseUrl: _baseUrl)).interceptor);
  }

  @override
  Future<List<Station>> getStationsByCountryPaginated(
    String countryCode,
    int offset,
    int limit,
  ) async {
    final stationsFromCountryCodeUrl = _stationsByCountryCodeUrl + countryCode;
    final Response rawStationsJson = await _dio.get(
      _buildUrlToSortByPopularityWithPagination(stationsFromCountryCodeUrl, offset, limit),
      options: buildCacheOptions(
        Duration(days: 7),
      ),
    );
    final List<Station> stations = (rawStationsJson.data as List)
        .map((it) => Station(
              it['url_resolved'],
              it['favicon'],
              it['name'],
            ))
        .toList();
    return Future.value(stations);
  }

  String _buildUrlToSortByPopularityWithPagination(String url, int offset, int limit) {
    return '$url?hidebroken=true&order=clickcount&reverse=true&offset=$offset&limit=$limit';
  }
}
