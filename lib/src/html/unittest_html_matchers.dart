part of guinness_html;

class UnitTestMatchersConfig {
  Function preprocessHtml = (node) => node;
}

class UnitTestMatchersWithHtml extends gns.UnitTestMatchers implements HtmlMatchers {
  final UnitTestMatchersConfig config  = new UnitTestMatchersConfig();

  toHaveHtml(actual, expected) => unit.expect(htmlUtils.toHtml(actual, preprocess: config.preprocessHtml), unit.equals(expected));

  toHaveText(actual, expected) => unit.expect(htmlUtils.elementText(actual), unit.equals(expected));

  toHaveClass(actual, cls) =>
      unit.expect(actual.classes.contains(cls), true,
        reason: ' Expected ${actual} to have css class ${cls}');

  toHaveAttribute(actual, name, [value = null]) {
    unit.expect(actual.attributes.containsKey(name), true, reason: 'Epxected $actual to have attribute $name');
    if (value != null)
      unit.expect(actual.attributes[name], value, reason: 'Epxected $actual attribute "$name" to be "$value"');
  }

  notToHaveHtml(actual, expected) => unit.expect(htmlUtils.toHtml(actual, preprocess: config.preprocessHtml), unit.isNot(unit.equals(expected)));

  notToHaveText(actual, expected) => unit.expect(htmlUtils.elementText(actual), unit.isNot(unit.equals(expected)));

  notToHaveClass(actual, cls) =>
      unit.expect(actual.classes.contains(cls), false,
        reason: ' Expected ${actual} not to have css class ${cls}');

  notToHaveAttribute(actual, name) =>
      unit.expect(actual.attributes.containsKey(name),
        false,
        reason: 'Epxected $actual not to have attribute $name');
}