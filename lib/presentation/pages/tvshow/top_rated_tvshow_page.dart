import 'package:ditonton/presentation/bloc/top_rated_tv_show/top_rated_tv_show_bloc.dart';
import 'package:ditonton/presentation/widgets/tvshow_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    final bloc = context.read<TopRatedTvshowBloc>();
    bloc.add(FetchTopRatedTvshows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Tv Show'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvshowBloc, TopRatedTvshowState>(
          builder: (context, state) {
            if (state is TopRatedTvshowLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedTvshowLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvshow = state.tvshows[index];
                  return TvshowCard(tvshow);
                },
                itemCount: state.tvshows.length,
              );
            } else if (state is TopRatedTvshowError) {
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
