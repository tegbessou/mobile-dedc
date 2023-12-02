import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class UserCacheManager {
  static const key = 'user';
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