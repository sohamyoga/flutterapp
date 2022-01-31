import 'dart:ui';

Color bgDarkWhite=Color(0xFFFAFAFA);
// Color bgDarkWhite=Color(0xFFF6F6F6);
Color primaryColor=Color(0xFFF6F6F6);
Color accentColor="#2C698D".toColor();
// Color accentColor=Color(0xFFEC2315);
Color greyWhite=Color(0xFFEBEAEF);
// Color greyWhite=Color(0xFFEBEAEF);
Color darkGrey=Color(0xFFEBEAEF);
Color greenButton=Color(0xFF37BD4D);
Color blueButton=Color(0xFF0078FF);
Color quickSvgColor=Color(0xFF283182);
// Color quickSvgColor=Color(0xFF54C9DC);
// Color bmiBgColor=Color(0xFF057B71);
Color bmiBgColor="#2C698D".toColor();
// Color bmiBgColor=Color(0xFF185493);
Color bmiDarkBgColor=Color(0xFF134B6D);
// Color bmiDarkBgColor=Color(0xFF17497E);
Color lightPink=Color(0xFFFBE8EA);
Color itemBgColor=Color(0xFFF2F1F4);
// Color accentColor=Color(0xFFFF0202);

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}