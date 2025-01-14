part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState([this.term = '']);

  final String term;

  @override
  List<Object> get props => [
        term,
      ];
}

final class SearchEmptyTerm extends SearchState {
  const SearchEmptyTerm();
}

final class SearchLoading extends SearchState {
  const SearchLoading(super.term);
}

final class SearchSuccess extends SearchState {
  const SearchSuccess(super.term, this.result);

  final SearchResult result;

  List<LibraryEntry>? get libraryEntries => result.libraryEntries;

  List<NyaaTorrent>? get torrents => result.torrents;

  List<Query$Search$staff$results>? get staffs => result.staffs;
  List<Query$Search$characters$results>? get characters => result.characters;
  List<Fragment$media>? get medias => result.medias;

  bool get isEmpty => result.isEmpty;

  @override
  List<Object> get props => [
        term,
        result,
      ];
}

final class SearchError extends SearchState {
  const SearchError(super.term, this.message);

  final String message;

  @override
  List<Object> get props => [
        term,
        message,
      ];
}
