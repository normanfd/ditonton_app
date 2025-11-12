import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/local_data_source.dart';
import 'package:ditonton/data/datasources/movie/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tvshow/tvshow_remote_data_source.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tvshow_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  LocalDataSource,
  DatabaseHelper,
  TvshowRemoteDataSource,
  TvshowRepository
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
