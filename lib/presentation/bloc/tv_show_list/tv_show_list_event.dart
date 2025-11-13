part of 'tv_show_list_bloc.dart';

abstract class TvshowListEvent extends Equatable {
  const TvshowListEvent();

  @override
  List<Object> get props => [];
}

class FetchAllTvshowLists extends TvshowListEvent {}