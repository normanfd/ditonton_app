import 'package:ditonton/data/models/watchlist_table.dart';
import 'package:ditonton/domain/entities/Tvshow.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/season_detail.dart';
import 'package:ditonton/domain/entities/tvshow_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testTvshow = Tvshow(
  backdropPath: "/mAJ84W6I8I272Da87qplS2Dp9ST.jpg",
  firstAirDate: "2023-01-23",
  genreIds: [9648, 18],
  id: 202250,
  name: "Dirty Linen",
  originCountry: ["PH"],
  originalLanguage: "tl",
  originalName: "Dirty Linen",
  overview:
      "To exact vengeance, a young woman infiltrates the household of an influential family as a housemaid to expose their dirty secrets. However, love will get in the way of her revenge plot.",
  popularity: 2684.061,
  posterPath: "/ujlkQtHAVShWyWTloGU2Vh5Jbo9.jpg",
  voteAverage: 5,
  voteCount: 13,
);

final testTvshowList = [testTvshow];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testTvshowDetail = TvshowDetail(
  adult: false,
  backdropPath: "/2746UvsbkZINd873Yd3o3TxOwCP.jpg",
  createdBy: [
    CreatedBy(
      id: 1113116,
      creditId: "682cac47989cf65c7edb32d8",
      name: "Andy Muschietti",
      gender: 2,
      profilePath: "/4ndnP2NNavhfGtJqihD4FVDsYMY.jpg",
    ),
  ],
  episodeRunTime: [],
  firstAirDate: "2025-10-26",
  genres: [
    GenreTv(id: 9648, name: "Mystery"),
    GenreTv(id: 18, name: "Drama"),
  ],
  homepage: "https://www.hbo.com/content/it-welcome-to-derry",
  id: 200875,
  inProduction: true,
  languages: ["en"],
  lastAirDate: "2025-11-02",
  lastEpisodeToAir: LastEpisodeToAir(
    id: 6548351,
    name: "The Thing in the Dark",
    overview:
        "While Charlotte and Will navigate their new life in Derry, Ronnie worries about her father's fate.",
    voteAverage: 5.328,
    voteCount: 32,
    airDate: "2025-11-02",
    episodeNumber: 2,
    productionCode: "",
    runtime: 66,
    seasonNumber: 1,
    showId: 200875,
    stillPath: "/xjlBmaPoYZkoJl7kiB6G1xenOFH.jpg",
  ),
  name: "IT: Welcome to Derry",
  nextEpisodeToAir: LastEpisodeToAir(
    id: 6548352,
    name: "Now You See It",
    overview:
        "When a major find yields few clues, General Shaw pushes ahead with his top-secret mission, ordering Leroy and Pauly to escort Dick Hallorann on an aerial search for a new dig site. Meanwhile, Rose attends a tribal meeting about the military presence in Derry, and Ronnie, Lilly, Will, and Rich attempt to get visual proof by conjuring an Orixá.",
    voteAverage: 0.0,
    voteCount: 0,
    airDate: "2025-11-09",
    episodeNumber: 3,
    productionCode: "",
    runtime: 60,
    seasonNumber: 1,
    showId: 200875,
    stillPath: "/nO6UoLrCHSBwmKFixzkYv5FCTZ6.jpg",
  ),
  networks: [
    Network(
      id: 49,
      logoPath: "/tuomPhY2UtuPTqqFnKMVHvSb724.png",
      name: "HBO",
      originCountry: "US",
    ),
  ],
  numberOfEpisodes: 8,
  numberOfSeasons: 1,
  originCountry: ["US"],
  originalLanguage: "en",
  originalName: "IT: Welcome to Derry",
  overview:
      "In 1962, a couple with their son move to Derry, Maine just as a young boy disappears. With their arrival, very bad things begin to happen in the town.",
  popularity: 324.6438,
  posterPath: "/nyy3BITeIjviv6PFIXtqvc8i6xi.jpg",
  productionCompanies: [
    ProductionCompany(
      id: 1957,
      logoPath: "/pJJw98MtNFC9cHn3o15G7vaUnnX.png",
      name: "Warner Bros. Television",
      originCountry: "US",
    )
  ],
  productionCountries: [
    ProductionCountry(
      iso31661: "US",
      name: "United States of America",
    ),
  ],
  seasons: [
    Season(
      airDate: "2025-10-26",
      episodeCount: 8,
      id: 291792,
      name: "Season 1",
      overview: "",
      posterPath: "/IFi0kbnVAoEVReaBuhOSj6GBMH.jpg",
      seasonNumber: 1,
      voteAverage: 5.7,
    ),
  ],
  spokenLanguages: [
    SpokenLanguage(
      englishName: "English",
      iso6391: "en",
      name: "English",
    ),
  ],
  status: "Returning Series",
  tagline: "Go back to where IT all began.",
  type: "Scripted",
  voteAverage: 7.893,
  voteCount: 280,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = WatchlistTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
    tipe: 'm');

final testTvshowTable = WatchlistTable(
    id: 200875,
    title: 'IT: Welcome to Derry',
    posterPath: '/nyy3BITeIjviv6PFIXtqvc8i6xi.jpg',
    overview:
        'In 1962, a couple with their son move to Derry, Maine just as a young boy disappears. With their arrival, very bad things begin to happen in the town.',
    tipe: 't');

final testWatchlistTvshow = Tvshow.watchlist(
  id: 200875,
  name: 'IT: Welcome to Derry',
  posterPath: '/nyy3BITeIjviv6PFIXtqvc8i6xi.jpg',
  overview:
      'In 1962, a couple with their son move to Derry, Maine just as a young boy disappears. With their arrival, very bad things begin to happen in the town.',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testSeasonEpisode = SeasonEpisode(
    episodeNumber: 1,
    id: 1,
    seasonNumber: 1,
    voteAverage: 1,
    voteCount: 1,
    name: "name",
    overview: "overview");
final testSeasonEpisodeList = [testSeasonEpisode];

final testSeasonNetwork =
    SeasonNetwork(id: 1, logoPath: "", name: "", originCountry: "");
final testSeasonDetail = SeasonDetail(
    idMongo: "",
    airDate: "",
    episodes: testSeasonEpisodeList,
    name: "",
    networks: [testSeasonNetwork],
    overview: "",
    id: 1,
    posterPath: "",
    seasonNumber: 1,
    voteAverage: 1);
final testSeasonDetailList = [testSeasonDetail];
