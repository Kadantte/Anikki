import 'package:flutter/material.dart';
import 'package:nyaa/nyaa.dart';
import 'package:open_app_file/open_app_file.dart';

import 'package:anikki/helpers/desktop_hooks.dart';
import 'package:anikki/user_list/user_list_actions.dart';

class DownloadResultsDialogListView extends StatelessWidget {
  const DownloadResultsDialogListView(
      {super.key, required this.entries, required this.outlineColor});

  final List<Torrent> entries;
  final Color outlineColor;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final entry = entries[index];

        return ListTile(
          dense: true,
          onTap: () async {
            if (isDesktop()) {
              await OpenAppFile.open(entry.magnet);
            } else {
              openMediaInBrowser(entry.magnet);
            }
          },
          leading: CircleAvatar(
            radius: 8.0,
            backgroundColor: entry.status == 'success'
                ? Colors.green
                : entry.status == 'danger'
                    ? Colors.red
                    : Colors.yellow,
          ),
          title: Text(entry.name),
          subtitle: Text(entry.filesize),
          trailing: SizedBox(
            width: 120,
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const WidgetSpan(
                            child: Icon(
                          Icons.arrow_upward,
                          color: Colors.green,
                        )),
                        TextSpan(
                            text: entry.seeders,
                            style: const TextStyle(color: Colors.green))
                      ],
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                          child: Icon(
                        Icons.arrow_downward,
                        color: Colors.redAccent,
                      )),
                      TextSpan(
                          text: entry.leechers,
                          style: const TextStyle(color: Colors.redAccent))
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: outlineColor,
        height: 3,
      ),
      itemCount: entries.length,
    );
  }
}
