import 'package:online_radio/station.dart';

abstract class StationRepository {
  Future<List<Station>> getStationsByCountryPaginated(String country, int offset, int limit);
}
