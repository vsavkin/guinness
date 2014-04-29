part of guinness_html;

abstract class HtmlMatchers {
  void toHaveHtml(actual, expected);
  void toHaveText(actual, expected);
  void toHaveClass(actual, cls);
  void toHaveAttribute(actual, name, [value]);

  void notToHaveHtml(actual, expected);
  void notToHaveText(actual, expected);
  void notToHaveClass(actual, cls);
  void notToHaveAttribute(actual, name);
}