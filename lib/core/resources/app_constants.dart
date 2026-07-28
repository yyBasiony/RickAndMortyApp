class AppConstants {
  static const String baseUrl = 'https://rickandmortyapi.com/api';
    static const List<String> statuses = ['alive', 'dead', 'unknown'];
  static const List<String> genders = ['male', 'female', 'genderless', 'unknown'];
  static const List<String> speciesList = [
    'Human',
    'Alien',
    'Humanoid',
    'Poopybutthole',
    'Mythological Creature',
    'Animal',
    'Robot',
    'Cronenberg',
    'Disease',
    'Unknown'
  ];
  static const String appTitle = 'Rick and Morty';
  static const String searchHint = 'Search characters...';
  static const String noCharactersFound = 'No characters found';
  static const String exportSuccess = 'Excel file generated successfully!';
  static const String exportFailed = 'Export failed: ';
  static const String retry = 'Retry';
  static const String shareSubject = 'Characters List Excel';
  static const String shareText = 'Rick and Morty Characters Export';
}
