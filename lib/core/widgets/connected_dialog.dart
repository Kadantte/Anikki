import 'package:flutter/material.dart';

import 'package:anikki/core/core.dart';
import 'package:anikki/core/widgets/layout_card.dart';

class ProviderConnectedDialog extends StatelessWidget {
  const ProviderConnectedDialog({
    super.key,
    required this.provider,
  });

  final WatchListProvider provider;

  @override
  Widget build(BuildContext context) {
    final connected = LayoutCard(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Connected to ${provider.title}!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

    return Dialog(
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: connected,
    );
  }
}
