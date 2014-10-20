part of guinness_html;

abstract class HtmlMatchers {
  void toHaveHtml(actual, expected);
  void toHaveText(actual, expected);
  void toContainText(actual, expected);
  void toHaveClass(actual, cls);
  void toHaveAttribute(actual, name, [value]);
  void toEqualSelect(actual, options);

  void notToHaveHtml(actual, expected);
  void notToHaveText(actual, expected);
  void notToContainText(actual, expected);
  void notToHaveClass(actual, cls);
  void notToHaveAttribute(actual, name);
}