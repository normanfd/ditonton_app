import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/pages/tvshow/now_playing_tvshow_page.dart';
import 'package:ditonton/presentation/pages/tvshow/popular_tvshow_page.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/tvshow/top_rated_tvshow_page.dart';
import 'package:ditonton/presentation/pages/tvshow/tvshow_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/Tvshow.dart';
import '../../provider/tvshow/tvshow_list_notifier.dart';

class HomeTvshowPageContent extends StatefulWidget {
  const HomeTvshowPageContent({Key? key}) : super(key: key);

  @override
  _HomeTvshowPageContentState createState() => _HomeTvshowPageContentState();
}

class _HomeTvshowPageContentState extends State<HomeTvshowPageContent> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<TvshowListNotifier>(context, listen: false)
          ..fetchNowPlayingTvshows()
          ..fetchPopularTvshows()
          ..fetchTopRatedTvshows());
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
            Consumer<TvshowListNotifier>(builder: (context, data, child) {
              final state = data.nowPlayingState;
              if (state == RequestState.Loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state == RequestState.Loaded) {
                return TvshowList(data.nowPlayingTvshows);
              } else {
                return Text('Failed');
              }
            }),
            _buildSubHeading(
              title: 'Popular',
              onTap: () =>
                  Navigator.pushNamed(context, PopularTvshowPage.ROUTE_NAME),
            ),
            Consumer<TvshowListNotifier>(builder: (context, data, child) {
              final state = data.popularTvshowsState;
              if (state == RequestState.Loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state == RequestState.Loaded) {
                return TvshowList(data.popularTvshows);
              } else {
                return Text('Failed');
              }
            }),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () =>
                  Navigator.pushNamed(context, TopRatedTvshowPage.ROUTE_NAME),
            ),
            Consumer<TvshowListNotifier>(builder: (context, data, child) {
              final state = data.topRatedTvshowsState;
              if (state == RequestState.Loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state == RequestState.Loaded) {
                return TvshowList(data.topRatedTvshows);
              } else {
                return Text('Failed');
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
