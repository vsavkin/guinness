part of guinness_html;

class Expect extends gns.Expect {
  Expect(actual) : super(actual);

  NotExpect get not => new NotExpect(actual);

  void toHaveHtml(expected) => _m.toHaveHtml(actual, expected);
  void toHaveText(expected) => _m.toHaveText(actual, expected);
  void toContainText(expected) => _m.toContainText(actual, expected);
  void toHaveClass(cls) => _m.toHaveClass(actual, cls);
  void toHaveAttribute(name, [value = null]) => _m.toHaveAttribute(actual, name, value);
  void toEqualSelect(options) => _m.toEqualSelect(actual, options);

  HtmlMatchers get _m => gns.guinness.matchers;
}


class NotExpect extends gns.NotExpect {
  NotExpect(actual) : super(actual);

  void toHaveHtml(expected) => _m.notToHaveHtml(actual, expected);
  void toHaveText(expected) => _m.notToHaveText(actual, expected);
  void toContainText(expected) => _m.notToContainText(actual, expected);
  void toHaveClass(cls) => _m.notToHaveClass(actual, cls);
  void toHaveAttribute(name) => _m.notToHaveAttribute(actual, name);

  HtmlMatchers get _m => gns.guinness.matchers;
}