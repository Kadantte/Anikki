final toRemoveCharacters = [
  r'\(TV\)',
  r'\[',
  r'\]',
  r':',
];

String sanitizeName(String name) => name
    .replaceAll(
      RegExp('(${toRemoveCharacters.join('|')})'),
      '',
    )
    .trim();
