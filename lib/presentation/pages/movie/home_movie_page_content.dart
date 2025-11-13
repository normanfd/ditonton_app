import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie/movie_list/movie_list_bloc.dart';
import 'package:ditonton/presentation/pages/movie/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/movie/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeMoviePageContent extends StatefulWidget {
  const HomeMoviePageContent({Key? key}) : super(key: key);

  @override
  _HomeMoviePageContentState createState() => _HomeMoviePageContentState();
}

class _HomeMoviePageContentState extends State<HomeMoviePageContent> {
  @override
  void initState() {
    super.initState();
    context.read<MovieListBloc>().add(FetchAllMovieLists());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Now Playing',
              style: kHeading6,
            ),
            BlocBuilder<MovieListBloc, MovieListState>(
                buildWhen: (prev, current) => prev.nowPlayingState != current.nowPlayingState,
                builder: (context, state) {
                  if (state.nowPlayingState == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.nowPlayingState == RequestState.Loaded) {
                    return MovieList(state.nowPlayingMovies);
                  } else {
                    return Text(state.nowPlayingMessage.isNotEmpty ? state.nowPlayingMessage : 'Failed');
                  }
                }),
            _buildSubHeading(
              title: 'Popular',
              onTap: () => Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
            ),
            BlocBuilder<MovieListBloc, MovieListState>(
                buildWhen: (prev, current) => prev.popularMoviesState != current.popularMoviesState,
                builder: (context, state) {
                  if (state.popularMoviesState == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.popularMoviesState == RequestState.Loaded) {
                    return MovieList(state.popularMovies);
                  } else {
                    return Text(state.nowPlayingMessage.isNotEmpty ? state.nowPlayingMessage : 'Failed');
                  }
                }),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () => Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
            ),
            BlocBuilder<MovieListBloc, MovieListState>(
                buildWhen: (prev, current) => prev.topRatedMoviesState != current.topRatedMoviesState,
                builder: (context, state) {
                  if (state.topRatedMoviesState == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.topRatedMoviesState == RequestState.Loaded) {
                    return MovieList(state.topRatedMovies);
                  } else {
                    return Text(state.nowPlayingMessage.isNotEmpty ? state.nowPlayingMessage : 'Failed');
                  }
                }),
          ],
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList(this.movies, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
