import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:equatable/equatable.dart';

class TvseriesDetailResponse extends Equatable {
  TvseriesDetailResponse({
    required this.backdropPath,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.status,
    required this.tagline,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
    required this.firstAirDate,
    required this.lastAirDate,
  });

  final String? backdropPath;
  final List<GenreModel> genres;
  final String homepage;
  final int id;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String posterPath;
  final String status;
  final String tagline;
  final String name;
  final double voteAverage;
  final int voteCount;
  final String firstAirDate;
  final String? lastAirDate;

  factory TvseriesDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvseriesDetailResponse(
        backdropPath: json["backdrop_path"],
        genres: List<GenreModel>.from(
            json["genres"].map((x) => GenreModel.fromJson(x))),
        homepage: json["homepage"],
        id: json["id"],
        originalLanguage: json["original_language"],
        originalName: json["original_name"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        firstAirDate: json["first_air_date"],
        lastAirDate: json["last_air_date"],
        status: json["status"],
        tagline: json["tagline"],
        name: json["name"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
    "backdrop_path": backdropPath,
    "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
    "homepage": homepage,
    "id": id,
    "original_language": originalLanguage,
    "original_name": originalName,
    "first_air_date": firstAirDate,
    "last_air_date": lastAirDate,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "status": status,
    "tagline": tagline,
    "name": name,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };

  TvseriesDetail toEntity() {
    return TvseriesDetail(
      backdropPath: this.backdropPath,
      genres: this.genres.map((genre) => genre.toEntity()).toList(),
      homepage: this.homepage,
      originalLanguage: this.originalLanguage,
      originalName: this.originalName,
      name: this.name,
      firstAirDate: this.firstAirDate,
      lastAirDate: this.lastAirDate,
      id: this.id,
      overview: this.overview,
      posterPath: this.posterPath,
      voteAverage: this.voteAverage,
      voteCount: this.voteCount,
      popularity: this.popularity,
      status: this.status,
      tagline: this.tagline,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    backdropPath,
    genres,
    homepage,
    id,
    originalLanguage,
    overview,
    popularity,
    posterPath,
    status,
    tagline,
    originalName,
    name,
    firstAirDate,
    lastAirDate,
    voteAverage,
    voteCount,
  ];
}
