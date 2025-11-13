import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/tvshow_detail.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/tvshow/season_detail_tvshow_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../bloc/tv_show_detail/tv_show_detail_bloc.dart';

class TvshowDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tvshow';

  final int id;

  const TvshowDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _TvshowDetailPageState createState() => _TvshowDetailPageState();
}

class _TvshowDetailPageState extends State<TvshowDetailPage> {
  @override
  void initState() {
    super.initState();

    context.read<TvshowDetailBloc>().add(FetchTvshowDetail(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TvshowDetailBloc, TvshowDetailState>(
        listenWhen: (prev, current) =>
            prev.watchlistMessage != current.watchlistMessage && current.watchlistMessage.isNotEmpty,
        listener: (BuildContext context, TvshowDetailState state) {
          final message = state.watchlistMessage;
          const watchlistAddSuccessMessage = 'Added to Watchlist';
          const watchlistRemoveSuccessMessage = 'Removed from Watchlist';
          if (message == watchlistAddSuccessMessage || message == watchlistRemoveSuccessMessage) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(content: Text(message));
                });
          }
        },
        builder: (BuildContext context, TvshowDetailState state) {
          if (state.tvshowState == RequestState.Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.tvshowState == RequestState.Loaded) {
            return SafeArea(child: DetailTvshowContent(state));
          } else {
            return Text(state.message);
          }
        },
      ),
    );
  }
}

class DetailTvshowContent extends StatelessWidget {
  final TvshowDetailState state;

  const DetailTvshowContent(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${state.tvshow!.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.tvshow!.name,
                              style: kHeading5,
                            ),
                            FilledButton(
                              onPressed: () {
                                if (!state.isAddedToWatchlist) {
                                  context.read<TvshowDetailBloc>().add(AddToWatchlist(state.tvshow!));
                                } else {
                                  context.read<TvshowDetailBloc>().add(RemoveFromWatchlist(state.tvshow!));
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  state.isAddedToWatchlist ? Icon(Icons.check) : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(state.tvshow!.genres),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: state.tvshow!.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${state.tvshow!.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              state.tvshow!.overview,
                            ),
                            SizedBox(height: 16),
                            if (state.tvshow!.seasons.isNotEmpty) ...[
                              Text(
                                'Seasons',
                                style: kHeading6,
                              ),
                              SeasonWidget(tvshow: state.tvshow!),
                              SizedBox(height: 16),
                            ],
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            if (state.recommendationState == RequestState.Loading) ...[
                              Center(child: CircularProgressIndicator())
                            ] else if (state.recommendationState == RequestState.Error) ...[
                              Text(state.message)
                            ] else if (state.recommendationState == RequestState.Loaded) ...[
                              SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final tvshow = state.tvshowRecommendations[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            TvshowDetailPage.ROUTE_NAME,
                                            arguments: tvshow.id,
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: 'https://image.tmdb.org/t/p/w500${tvshow.posterPath}',
                                            placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  // Gunakan panjang list dari state
                                  itemCount: state.tvshowRecommendations.length,
                                ),
                              )
                            ] else ...[
                              Container()
                            ]
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },

            // initialChildSize: 0.5,
            minChildSize: 0.25,

            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<GenreTv> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}

class SeasonWidget extends StatelessWidget {
  const SeasonWidget({
    Key? key,
    required this.tvshow,
  }) : super(key: key);

  final TvshowDetail tvshow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tvshow.seasons.length,
        itemBuilder: (context, index) {
          final season = tvshow.seasons[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
                width: 110, // Beri lebar agar konsisten
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      SeasonDetailTvshowPage.ROUTE_NAME,
                      arguments: [tvshow.id, tvshow.seasons[index].seasonNumber],
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: season.posterPath != null
                              ? 'https://image.tmdb.org/t/p/w500${season.posterPath}'
                              : 'https://via.placeholder.com/500x750?text=No+Image',
                          height: 150,
                          width: 110,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 150,
                            width: 110,
                            color: Colors.grey[800],
                            child: Center(child: Icon(Icons.error)),
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        season.name,
                        style: kBodyText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${season.episodeCount} Episodes',
                        style: kBodyText.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }
}
