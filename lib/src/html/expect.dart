part of guinness_html;

class Expect extends gns.Expect {
  Expect(actual) : super(actual);

  NotExpect get not => new NotExpect(actual);

  toHaveHtml(expected) => _m.toHaveHtml(actual, expected);
  toHaveText(expected) => _m.toHaveText(actual, expected);
  toHaveClass(cls) => _m.toHaveClass(actual, cls);
  toHaveAttribute(name, [value = null]) => _m.toHaveAttribute(actual, name, value);

  HtmlMatchers get _m => gns.guinness.matchers;
}


class NotExpect extends gns.NotExpect {
  NotExpect(actual) : super(actual);

  toHaveHtml(expected) => _m.notToHaveHtml(actual, expected);
  toHaveText(expected) => _m.notToHaveText(actual, expected);
  toHaveClass(cls) => _m.notToHaveClass(actual, cls);
  toHaveAttribute(name) => _m.notToHaveAttribute(actual, name);

  HtmlMatchers get _m => gns.guinness.matchers;
}