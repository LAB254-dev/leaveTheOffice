class MusicData {
  int id;
  String title;
  String artist;
  String root;

  MusicData(String title, String artist, String root, {int id}) {
    this.id = id;
    this.title = title;
    this.artist = artist;
    this.root = root;
  }

  static const String musicDataId = "id";
  static const String musicDataTitle = "title";
  static const String musicDataArtist = "artist";
  static const String musicDataRoot = "root";
  static const String musicDataTableName = "musicData";
  static const String DEFAULT_MUSIC_ROOT = "default.mp3";
}
