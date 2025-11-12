import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/widgets/tvshow_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/tvshow/top_rated_tvshow_notifier.dart';

class TopRatedTvshowPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tvshow';

  const TopRatedTvshowPage({Key? key}) : super(key: key);

  @override
  _TopRatedTvshowPageState createState() => _TopRatedTvshowPageState();
}

class _TopRatedTvshowPageState extends State<TopRatedTvshowPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TopRatedTvshowNotifier>(context, listen: false)
            .fetchTopRatedTvshow());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Tv Show'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TopRatedTvshowNotifier>(
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
