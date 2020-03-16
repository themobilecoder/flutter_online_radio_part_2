abstract class RadioPlayer {
  Future<void> setUrl(String url);
  Future<void> play();
  Future<void> pause();
}
