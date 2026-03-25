class StringUtils {
  /// HTMLタグを除去してプレーンテキストにする
  static String stripHtml(String htmlString) {
    // 正規表現で <...> に囲まれた部分を空文字に置換
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }
}
