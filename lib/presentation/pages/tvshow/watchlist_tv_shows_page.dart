import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/widgets/tvshow_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/watchlist_tv_show/watchlist_tv_show_bloc.dart';

class WatchlistTvShowPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tvshow';

  const WatchlistTvShowPage({Key? key}) : super(key: key);

  @override
  _WatchlistTvShowPageState createState() => _WatchlistTvShowPageState();
}

class _WatchlistTvShowPageState extends State<WatchlistTvShowPage> with RouteAware {
  @override
  void initState() {
    super.initState();

    context.read<WatchlistTvshowBloc>().add(FetchWatchlistTvshows());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistTvshowBloc>().add(FetchWatchlistTvshows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist Tv Show'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTvshowBloc, WatchlistTvshowState>(
          builder: (context, state) {
            if (state is WatchlistTvshowLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistTvshowLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvshow = state.tvshows[index];
                  return TvshowCard(tvshow);
                },
                itemCount: state.tvshows.length,
              );
            } else {
              return Center(child: Text('Watchlist Anda kosong.'));
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
