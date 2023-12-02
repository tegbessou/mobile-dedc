import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class TastingCacheManager {
  static const key = 'tasting';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 20,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}