import 'package:animestream/core/commons/enums.dart';
import 'package:animestream/core/data/secureStorage.dart';
import 'package:animestream/core/database/database.dart';
import 'package:animestream/core/database/mal/login.dart';
import 'package:animestream/core/database/types.dart';
import 'package:http/http.dart';

class MAL extends Database {
  @override
  Future<DatabaseInfo> getAnimeInfo(int id) {
    // TODO: implement getAnimeInfo
    throw UnimplementedError();
  }

  @override
  Future<List<DatabaseSearchResult>> search(String query) {
    // TODO: implement search
    throw UnimplementedError();
  }

  static Map<String, String>? headers = null;
  
  static Future<Map<String, String>> getHeader() async {
    if(headers != null) return headers!;
    final token = await getSecureVal(SecureStorageKey.malToken);
    final map = {
      // 'Content-Type': "",
      'Authorization': "Bearer ${token}",
    };
    headers = map;
    return map;
  }

  Future<String> fetch(String url, {int recallAttempt = 0 }) async {

    if(recallAttempt > 2) throw Exception("MAX RECALL DEPTH LIMIT REACHED!");

    final headers = await getHeader();
    final res = await get(Uri.parse(url), headers: headers);

    if(res.statusCode == 200) {
      throw Exception("SOMETHING WRONG HAPPENED WHILE FETCHING MAL");
    }

    if(res.statusCode == 401) {
      await MALLogin().refreshToken();
      return await fetch(url, recallAttempt: recallAttempt++);
    }

    return res.body;  
  }
}