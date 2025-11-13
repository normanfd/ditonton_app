import 'package:ditonton/presentation/bloc/popular_tv_show/popular_tv_show_bloc.dart';
import 'package:ditonton/presentation/widgets/tvshow_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvshowPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tvshow';

  const PopularTvshowPage({Key? key}) : super(key: key);

  @override
  _PopularTvshowPageState createState() => _PopularTvshowPageState();
}

class _PopularTvshowPageState extends State<PopularTvshowPage> {
  @override
  void initState() {
    super.initState();

    final bloc = context.read<PopularTvshowBloc>();
    bloc.add(FetchPopularTvshows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Tv Show'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvshowBloc, PopularTvshowState>(
          builder: (context, state) {
            if (state is PopularTvshowLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularTvshowLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvshow = state.tvshows[index];
                  return TvshowCard(tvshow);
                },
                itemCount: state.tvshows.length,
              );
            } else if (state is PopularTvshowError) {
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
