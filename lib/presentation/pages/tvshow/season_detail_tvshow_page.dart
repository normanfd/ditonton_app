import 'package:ditonton/presentation/widgets/season_episode_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/season_detail/season_detail_bloc.dart';

class SeasonDetailTvshowPage extends StatefulWidget {
  static const ROUTE_NAME = '/season_detail-tvshow';

  final int seriesId;
  final int seasonId;

  const SeasonDetailTvshowPage({Key? key, required this.seriesId, required this.seasonId}) : super(key: key);

  @override
  _SeasonDetailTvshowPageState createState() => _SeasonDetailTvshowPageState();
}

class _SeasonDetailTvshowPageState extends State<SeasonDetailTvshowPage> {
  @override
  void initState() {
    super.initState();
    context.read<SeasonDetailBloc>().add(FetchSeasonDetail(widget.seriesId, widget.seasonId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Season Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<SeasonDetailBloc, SeasonDetailState>(
          builder: (context, state) {
            if (state is SeasonDetailLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SeasonDetailLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final dt = state.episodes[index];
                  return SeasonEpisodeCardList(dt);
                },
                itemCount: state.episodes.length,
              );
            } else {
              return Center(child: Text('Data episode kosong.'));
            }
          },
        ),
      ),
    );
  }
}
