import 'package:ditonton/data/models/tvseries_model.dart';
import 'package:equatable/equatable.dart';

class TvseriesResponse extends Equatable {
  final List<TvseriesModel> tvseriesList;

  TvseriesResponse({required this.tvseriesList});

  factory TvseriesResponse.fromJson(Map<String, dynamic> json) => TvseriesResponse(
    tvseriesList: List<TvseriesModel>.from((json["results"] as List)
        .map((x) => TvseriesModel.fromJson(x))
        .where((element) => element.posterPath != null)),
  );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(tvseriesList.map((x) => x.toJson())),
  };

  @override
  List<Object> get props => [tvseriesList];
}
