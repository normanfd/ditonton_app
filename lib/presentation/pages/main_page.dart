import 'package:ditonton/presentation/bloc/main/main_bloc.dart';
import 'package:ditonton/presentation/pages/movie/search_page.dart';
import 'package:ditonton/presentation/pages/tvshow/search_page_tvshow.dart';
import 'package:ditonton/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/tvshow/watchlist_tv_shows_page.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'movie/home_movie_page_content.dart';
import 'tvshow/home_tvshow_page_content.dart';

class MainPage extends StatelessWidget {
  static const ROUTE_NAME = '/home';

  MainPage({Key? key}) : super(key: key);

  final List<Widget> _pages = [
    HomeMoviePageContent(),
    HomeTvshowPageContent(),
  ];

  final List<String> _pageTitles = ['Movies', 'TV Shows'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(),
      child: BlocBuilder<MainBloc, MainState>(
        builder: (BuildContext context, MainState state) {
          return Scaffold(
            drawer: Drawer(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage('assets/circle-g.png'),
                      backgroundColor: Colors.grey.shade900,
                    ),
                    accountName: Text('Ditonton'),
                    accountEmail: Text('ditonton@dicoding.com'),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.movie_filter),
                    title: Text('Movie Watchlist'),
                    onTap: () {
                      Navigator.pushNamed(
                          context, WatchlistMoviesPage.ROUTE_NAME);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.tv_sharp),
                    title: Text('TV Show Watchlist'),
                    onTap: () {
                      Navigator.pushNamed(
                          context, WatchlistTvShowPage.ROUTE_NAME);
                    },
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
                    },
                    leading: Icon(Icons.info_outline),
                    title: Text('About'),
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              title: Text('Ditonton - ${_pageTitles[state.tabIndex]}'),
              actions: [
                IconButton(
                  onPressed: () {
                    if (state.tabIndex == 0) {
                      Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
                    } else {
                      Navigator.pushNamed(context, SearchPageTvshow.ROUTE_NAME);
                    }
                  },
                  icon: Icon(Icons.search),
                )
              ],
            ),
            body: _pages[state.tabIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.movie),
                  label: 'Movies',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.tv),
                  label: 'TV Shows',
                ),
              ],
              currentIndex: state.tabIndex,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              onTap: (index) {
                context.read<MainBloc>().add(MainTabChanged(index));
              },
              backgroundColor: Colors.grey.shade900,
            ),
          );
        },
      ),
    );
  }
}
