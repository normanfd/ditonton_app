import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tvshow/now_playing_tvshow_notifier.dart';
import 'package:ditonton/presentation/widgets/tvshow_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    Future.microtask(() =>
        Provider.of<NowPlayingTvshowNotifier>(context, listen: false)
            .fetchNowPlayingTvshows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing Tv Show'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<NowPlayingTvshowNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvshow = data.tvshow[index];
                  return TvshowCard(tvshow);
                },
                itemCount: data.tvshow.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
