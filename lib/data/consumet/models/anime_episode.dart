part of 'models.dart';

class AnimeEpisode extends Equatable {
  const AnimeEpisode({
    required this.id,
    this.number,
    this.url,
    this.title,
    this.mediaId,
  });

  final int? number;
  final String id;
  final String? url;
  final String? title;
  final String? mediaId;

  @override
  List<Object?> get props => [
        number,
        id,
        url,
        title,
        mediaId,
      ];

  @override
  bool get stringify => true;
}
