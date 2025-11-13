import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/widgets/tvshow_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/tv_show_search/tv_show_search_bloc.dart';

class SearchPageTvshow extends StatelessWidget {
  static const ROUTE_NAME = '/search-tvshow';

  const SearchPageTvshow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Tv Show'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<TvshowSearchBloc>().add(OnQueryChanged(query));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            Expanded(
              child: BlocBuilder<TvshowSearchBloc, TvshowSearchState>(
                builder: (context, state) {
                  if (state is TvshowSearchLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is TvshowSearchLoaded) {
                    return ListView.builder(
                      itemCount: state.result.length,
                      itemBuilder: (context, index) {
                        final tvshow = state.result[index];
                        return TvshowCard(tvshow);
                      },
                    );
                  } else if (state is TvshowSearchError) {
                    return Center(child: Text(state.message));
                  } else {
                    // State TvshowSearchEmpty
                    return Center(child: Text('Cari sesuatu...'));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
