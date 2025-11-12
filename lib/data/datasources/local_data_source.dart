import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/watchlist_table.dart';

abstract class LocalDataSource {
  Future<String> insertWatchlist(WatchlistTable data);
  Future<String> removeWatchlist(WatchlistTable data);
  Future<WatchlistTable?> getDataById(int id);
  Future<List<WatchlistTable>> getWatchlistData(String tipe);
}

class LocalDataSourceImpl implements LocalDataSource {
  final DatabaseHelper databaseHelper;

  LocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(WatchlistTable data) async {
    try {
      await databaseHelper.insertWatchlist(data);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(WatchlistTable data) async {
    try {
      await databaseHelper.removeWatchlist(data);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<WatchlistTable?> getDataById(int id) async {
    final result = await databaseHelper.getMovieById(id);
    if (result != null) {
      return WatchlistTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<WatchlistTable>> getWatchlistData(String tipe) async {
    final result = await databaseHelper.getWatchlistMovies(tipe);
    return result.map((data) => WatchlistTable.fromMap(data)).toList();
  }
}
