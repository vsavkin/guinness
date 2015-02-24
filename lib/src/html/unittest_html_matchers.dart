part of guinness_html;

class UnitTestMatchersConfig {
  Function preprocessHtml = (node) => node;
}

class UnitTestMatchersWithHtml extends gns.UnitTestMatchers
    implements HtmlMatchers {
  final UnitTestMatchersConfig config = new UnitTestMatchersConfig();

  void toHaveHtml(actual, expected) => unit.expect(
      htmlUtils.toHtml(actual, preprocess: config.preprocessHtml),
      unit.equals(expected));

  void toHaveText(actual, expected) =>
      unit.expect(htmlUtils.elementText(actual), unit.equals(expected));

  void toContainText(actual, expected) =>
      unit.expect(htmlUtils.elementText(actual), unit.contains(expected));

  void toHaveClass(actual, cls) => unit.expect(
      actual.classes.contains(cls), true,
      reason: ' Expected $actual to have css class "$cls"');

  void toHaveAttribute(actual, name, [value = null]) {
    unit.expect(actual.attributes.containsKey(name), true,
        reason: 'Epxected $actual to have attribute "$name"');

    if (value != null) {
      unit.expect(actual.attributes[name], value,
          reason: 'Epxected $actual attribute "$name" to be "$value"');
    }
  }

  void toEqualSelect(actual, options) {
    var actualOptions = [];
    for (var option in actual.querySelectorAll('option')) {
      actualOptions.add(option.selected ? [option.value] : option.value);
    }
    return unit.expect(actualOptions, options);
  }

  void notToHaveHtml(actual, expected) => unit.expect(
      htmlUtils.toHtml(actual, preprocess: config.preprocessHtml),
      unit.isNot(unit.equals(expected)));

  void notToHaveText(actual, expected) => unit.expect(
      htmlUtils.elementText(actual), unit.isNot(unit.equals(expected)));

  void notToContainText(actual, expected) => unit.expect(
      htmlUtils.elementText(actual), unit.isNot(unit.contains(expected)));

  void notToHaveClass(actual, cls) => unit.expect(
      actual.classes.contains(cls), false,
      reason: ' Expected $actual not to have css class "$cls"');

  void notToHaveAttribute(actual, name) => unit.expect(
      actual.attributes.containsKey(name), false,
      reason: 'Epxected $actual not to have attribute "$name"');
}
