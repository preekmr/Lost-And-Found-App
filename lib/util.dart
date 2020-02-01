class Util {

  static String formatDM (int num) {

    if (num.toString().length == 1) {
      return "0" + num.toString();
    } else {
      return num.toString();
    }
  }

}