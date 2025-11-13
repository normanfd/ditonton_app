import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/pages/tvshow/now_playing_tvshow_page.dart';
import 'package:ditonton/presentation/pages/tvshow/popular_tvshow_page.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/tvshow/top_rated_tvshow_page.dart';
import 'package:ditonton/presentation/pages/tvshow/tvshow_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/Tvshow.dart';
import '../../bloc/tv_show_list/tv_show_list_bloc.dart';

class HomeTvshowPageContent extends StatefulWidget {
  const HomeTvshowPageContent({Key? key}) : super(key: key);

  @override
  _HomeTvshowPageContentState createState() => _HomeTvshowPageContentState();
}

class _HomeTvshowPageContentState extends State<HomeTvshowPageContent> {
  @override
  void initState() {
    super.initState();
    context.read<TvshowListBloc>().add(FetchAllTvshowLists());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubHeading(
              title: 'Now Playing',
              onTap: () =>
                  Navigator.pushNamed(context, NowPlayingTvshowPage.ROUTE_NAME),
            ),
            BlocBuilder<TvshowListBloc, TvshowListState>(
              buildWhen: (prev, current) =>
                  prev.nowPlayingState != current.nowPlayingState,
              builder: (context, state) {
                if (state.nowPlayingState == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.nowPlayingState == RequestState.Loaded) {
                  return TvshowList(state.nowPlayingTvshows);
                } else {
                  return Text(state.nowPlayingMessage.isNotEmpty
                      ? state.nowPlayingMessage
                      : 'Failed');
                }
              },
            ),
            _buildSubHeading(
              title: 'Popular',
              onTap: () =>
                  Navigator.pushNamed(context, PopularTvshowPage.ROUTE_NAME),
            ),
            BlocBuilder<TvshowListBloc, TvshowListState>(
              buildWhen: (prev, current) =>
                  prev.popularTvshowsState != current.popularTvshowsState,
              builder: (context, state) {
                if (state.popularTvshowsState == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.popularTvshowsState == RequestState.Loaded) {
                  return TvshowList(state.popularTvshows);
                } else {
                  return Text(state.popularMessage.isNotEmpty
                      ? state.popularMessage
                      : 'Failed');
                }
              },
            ),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () =>
                  Navigator.pushNamed(context, TopRatedTvshowPage.ROUTE_NAME),
            ),
            BlocBuilder<TvshowListBloc, TvshowListState>(
              buildWhen: (prev, current) =>
                  prev.topRatedTvshowsState != current.topRatedTvshowsState,
              builder: (context, state) {
                if (state.topRatedTvshowsState == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.topRatedTvshowsState == RequestState.Loaded) {
                  return TvshowList(state.topRatedTvshows);
                } else {
                  return Text(state.topRatedMessage.isNotEmpty
                      ? state.topRatedMessage
                      : 'Failed');
                }
              },
            ),
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

class TvshowList extends StatelessWidget {
  final List<Tvshow> tvshows;

  const TvshowList(this.tvshows, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvshow = tvshows[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvshowDetailPage.ROUTE_NAME,
                  arguments: tvshow.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvshow.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvshows.length,
      ),
    );
  }
}
