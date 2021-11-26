class Music_data {
  int id;
  String title;
  String artist;
  String root;

  Music_data(String title, String artist, String root, {int id}) {
    this.id = id;
    this.title = title;
    this.artist = artist;
    this.root = root;
  }

  static const String columnId = "id";
  static const String columnTitle = "title";
  static const String columnArtist = "artist";
  static const String columnRoot = "root";
  static const String tableName = "musicData";
  static int DEFALUT_MUSIC_ID = 1;
  static const String DEFAULT_MUSIC_ROOT = "default.mp3";
}
