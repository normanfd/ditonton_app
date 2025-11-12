import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tvshow/season_detail_notifier.dart';
import 'package:ditonton/presentation/widgets/season_episode_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeasonDetailTvshowPage extends StatefulWidget {
  static const ROUTE_NAME = '/season_detail-tvshow';

  final int seriesId;
  final int seasonId;

  const SeasonDetailTvshowPage({
    Key? key,
    required this.seriesId,
    required this.seasonId,
  }) : super(key: key);

  @override
  _SeasonDetailTvshowPageState createState() => _SeasonDetailTvshowPageState();
}

class _SeasonDetailTvshowPageState extends State<SeasonDetailTvshowPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<SeasonDetailNotifier>(context, listen: false)
            .fetchSeasonDetailTvshow(widget.seriesId, widget.seasonId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Season Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<SeasonDetailNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final dt = data.seasonDetail[index];
                  return SeasonEpisodeCardList(dt);
                },
                itemCount: data.seasonDetail.length,
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
