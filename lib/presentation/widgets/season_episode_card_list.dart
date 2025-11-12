import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/season_detail.dart';
import 'package:flutter/material.dart';

class SeasonEpisodeCardList extends StatelessWidget {
  final SeasonEpisode episode;

  const SeasonEpisodeCardList(this.episode, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16 + 80 + 16,
                  bottom: 8,
                  right: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Tooltip(
                      message:
                          '${episode.episodeNumber}. ${episode.name ?? ""}',
                      child: Text(
                        '${episode.episodeNumber}. ${episode.name ?? ""}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kHeading6,
                      ),
                    ),
                    SizedBox(height: 16),
                    Tooltip(
                      message: episode.overview ?? "",
                      child: Text(
                        episode.overview ?? "",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: kBodyText,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 16,
                bottom: 16,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${episode.stillPath}',
                  width: 80,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
