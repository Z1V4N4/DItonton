import 'package:ditonton/presentation/bloc/movie_popular/movie_popular_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_popular/movie_popular_event.dart';
import 'package:ditonton/presentation/bloc/movie_popular/movie_popular_state.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<MoviesPopularBloc>(context, listen: false)
            .add(GetMoviesPopularEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MoviesPopularBloc, MoviesPopularState>(
          builder: (context, state) {
            if (state is PopularListEmpty) {
              context.read<MoviesPopularBloc>().add(GetMoviesPopularEvent());
            }
            if (state is PopularListLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularListHasData) {
              final result = state.result;
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final movie = result[index];
                  return MovieCard(movie);
                },
                itemCount: result.length,
              );
            } else if (state is PopularListError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}