class BaseUrl {
  static String login = "http://beranekaragam.com/eventku/login.php";
  static String register = "http://beranekaragam.com/eventku/register.php";
  static String tambahProduk = "http://beranekaragam.com/eventku/addEvent.php";
  static String lihatProduk = "http://beranekaragam.com/eventku/lihatEvent.php";
  static String editProduk = "http://beranekaragam.com/eventku/editEvent.php";
  static String deleteProduk = "http://beranekaragam.com/eventku/deleteEvent.php";
  static String addFavoriteWithoutLogin = "http://beranekaragam.com/eventku/addFavoriteWithoutLogin.php";
  static String getFavorite = "http://beranekaragam.com/eventku/getFavoriteWithoutLogin.php?deviceInfo=QP1A.190711.020";
  static String tambahKeranjang = "http://beranekaragam.com/eventku/tambahKeranjang.php";
  static String jumlahKeranjang = "http://beranekaragam.com/eventku/lihatKeranjang.php?idUsers=";

  static String url = "http://beranekaragam.com/eventku";

  static String getEventFavoriteWithoutLogin(String deviceInfo){
    return "$url/getFavoriteWithoutLogin.php?deviceInfo=$deviceInfo";

  }
}
