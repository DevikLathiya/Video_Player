import 'package:hellomegha/Leadership/Leadership_List_View_Model.dart';
import 'package:hellomegha/MusicArtist/music_artist_list_view_model.dart';
import 'package:hellomegha/Schemes/schemes_list_view_model.dart';
import 'package:hellomegha/Shortfilms/shortfilm_list_view_model.dart';
import 'package:hellomegha/Stories/stories_list_view_model.dart';
import 'package:hellomegha/TodaysPicup/suggested_movies_list_view_model.dart';
import 'package:hellomegha/TodaysPicup/top_picked_list_view_model.dart';
import 'package:hellomegha/core/notifier/base_view_model.dart';
import 'package:hellomegha/music/favourite/favourite_list_view_model.dart';
import 'package:hellomegha/music/hot_videos_list_view_model.dart';
import 'package:hellomegha/music/music_album_list_view_model.dart';
import 'package:hellomegha/music/music_play_list_view_model.dart';
import 'package:hellomegha/view_models/authentication_view_model.dart';
import 'package:hellomegha/view_models/home_all_view_model.dart';
import 'package:hellomegha/view_models/home_movies_view_model.dart';
import 'package:hellomegha/view_models/home_music_view_model.dart';
import 'package:hellomegha/view_models/home_video_view_model.dart';
import 'package:hellomegha/view_models/influncer_detail_view_model.dart';
import 'package:hellomegha/view_models/latest_music_list_view.dart';
import 'package:hellomegha/view_models/leadership_detail_view_model.dart';
import 'package:hellomegha/view_models/live_stream_view_model.dart';
import 'package:hellomegha/view_models/movie_detail_view_model.dart';
import 'package:hellomegha/view_models/movie_list_view_model.dart';
import 'package:hellomegha/view_models/music_video_detail_view_model.dart';
import 'package:hellomegha/view_models/my_list_view_model.dart';
import 'package:hellomegha/view_models/notification_view_model.dart';
import 'package:hellomegha/view_models/quiz_view_model.dart';
import 'package:hellomegha/view_models/scheme_detail_view_model.dart';
import 'package:hellomegha/view_models/search_music_model.dart';
import 'package:hellomegha/view_models/story_list_view_model.dart';
import 'package:hellomegha/view_models/storys_detail_view_model.dart';
import 'package:hellomegha/view_models/transactions_view_model.dart';
import 'package:hellomegha/view_models/winner_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../music/music_video_list.dart';
// import '../../view_models/leadership_detail_view_model.dart';
import '../../view_models/recommended_movie_list_view_model.dart';
import '../../view_models/search_model.dart';
import 'package:hellomegha/view_models/comming_soon_view_model.dart';
final baseViewModel = ChangeNotifierProvider(
      (_) => BaseViewModel(),
);

final authenticationProvider = ChangeNotifierProvider(
      (_) => AuthenticationViewModel(),
);
// final checkmobileProvider = ChangeNotifierProvider(
//       (_) => CHeckMobileViewModel(),
// );
final movieListProvider = ChangeNotifierProvider(
      (_) => MovieListViewModel(),
);
final recommendedmovieListProvider = ChangeNotifierProvider(
      (_) => RecommendedMovieListViewModel(),
);
final LatestMusicListProvider = ChangeNotifierProvider(
      (_) => LatestMusicListViewModel(),
);

final storyListProvider = ChangeNotifierProvider(
      (_) => StoryListViewModel(),
);

final movieDetailProvider = ChangeNotifierProvider(
      (_) => MovieDetailViewModel(),
);

final storyDetailProvider = ChangeNotifierProvider(
      (_) => StoryDetailViewModel(),
);

final homeAllProvider = ChangeNotifierProvider(
      (_) => HomeAllViewModel(),
);

final homeMoviesProvider = ChangeNotifierProvider(
      (_) => HomeMoviesViewModel(),
);

final homeMusicProvider = ChangeNotifierProvider(
      (_) => HomeMusicViewModel(),
);

final homeVideoProvider = ChangeNotifierProvider(
      (_) => HomeVideoViewModel(),
);

final liveStreamProvider = ChangeNotifierProvider(
      (_) => LiveStreamViewModel(),
);

final quizProvider = ChangeNotifierProvider(
      (_) => QuizViewModel(),
);
final winnerProvider = ChangeNotifierProvider(
      (_) => WinnerViewModel(),
);
final transactionProvider = ChangeNotifierProvider(
      (_) => TransactionsViewModel(),
);

final musicAlbumListProvider = ChangeNotifierProvider(
      (_) => MusicAlbumListViewModel(),
);

final musicVideoListProvider = ChangeNotifierProvider(
      (_) => MusicVideoListViewModel(),
);

final hotVideosListProvider = ChangeNotifierProvider(
      (_) => HotVideosListViewModel(),
);

final topPickedListProvider = ChangeNotifierProvider(
      (_) => TopPickedListViewModel(),
);

final shortfilmListProvider = ChangeNotifierProvider(
      (_) => ShortFilmListViewModel(),
);

final storiesListProvider = ChangeNotifierProvider(
      (_) => StoriesListViewModel(),
);

final schemesListProvider = ChangeNotifierProvider(
      (_) => SchemesListViewModel(),

);
final leadershipListProvider = ChangeNotifierProvider(
        (_) => LeadershipListViewModel());

final musicArtistListProvider = ChangeNotifierProvider(
      (_) => MusicArtistListViewModel(),
);

final musicPlayListArtistListProvider = ChangeNotifierProvider(
      (_) => MusicPlayListViewModel(),
);

final suggestedMoviesListProvider = ChangeNotifierProvider(
      (_) => SuggestedMoviesListViewModel(),
);

final schemeDetailProvider = ChangeNotifierProvider(
      (_) => SchemeDetailViewModel(),
);
final leadershipDetailProvider = ChangeNotifierProvider(
      (_) => LeadershipDetailViewModel(),
);
final influncerDetailProvider = ChangeNotifierProvider(
      (_) => InfluncerDetailViewModel(),
);

final musicVideoDetailProvider = ChangeNotifierProvider(
      (_) => MusicVideoDetailViewModel(),
);

final notificationViewModel = ChangeNotifierProvider(
      (_) => NotificationViewModel(),
);

final myListViewModel = ChangeNotifierProvider(
      (_) => MyListViewModel(),
);

final searchViewModel = ChangeNotifierProvider(
      (_) => SearchModel(),
);
final searchMusicViewModel = ChangeNotifierProvider(
      (_) => SearchMusicModel(),
);
final commingSoonProvider = ChangeNotifierProvider(
      (_) => CommingSoonViewModel(),
);
final favouriteListProvider = ChangeNotifierProvider(
      (_) => FavouriteListViewModel(),
);