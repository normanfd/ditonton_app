import 'package:ditonton/presentation/widgets/tvshow_card_list.dart';
import 'package:flutter/material.dart';
import '../../bloc/now_playing_tv_show/now_playing_tvshow_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NowPlayingTvshowPage extends StatefulWidget {
  static const ROUTE_NAME = '/now-playing-tvshow';

  const NowPlayingTvshowPage({Key? key}) : super(key: key);

  @override
  _NowPlayingTvshowPageState createState() => _NowPlayingTvshowPageState();
}

class _NowPlayingTvshowPageState extends State<NowPlayingTvshowPage> {
  @override
  void initState() {
    super.initState();

    final bloc = context.read<NowPlayingTvshowBloc>();
    bloc.add(FetchNowPlayingTvshows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing Tv Show'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingTvshowBloc, NowPlayingTvshowState>(
          builder: (context, state) {
            if (state is NowPlayingTvshowLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NowPlayingTvshowLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvshow = state.tvshows[index];
                  return TvshowCard(tvshow);
                },
                itemCount: state.tvshows.length,
              );
            } else if (state is NowPlayingTvshowError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(
                child: Text('Belum ada data.'),
              );
            }
          },
        ),
      ),
    );
  }
}
