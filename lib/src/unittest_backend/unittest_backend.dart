part of jasmine;

class UnitTestVisitor implements SpecVisitor {
  void visitSuite(Suite suite){
    _visitChildren(suite.children);
  }

  void visitDescribe(Describe describe){
    if(describe.excluded) return;

    if(describe.exclusive) {
      unit.solo_group(describe.name, () {
        _visitChildren(describe.children);
      });
    } else {
      unit.group(describe.name, () {
        _visitChildren(describe.children);
      });
    }
  }

  void visitIt(It it){
    if(it.excluded) return;

    if(it.exclusive){
      unit.solo_test(it.name, it.withSetupAndTeardown);
    } else {
      unit.test(it.name, it.withSetupAndTeardown);
    }
  }

  _visitChildren(children){
    children.forEach((c) => c.visit(this));
  }
}

class UnitTestMatchers implements Matchers {
  expect(actual, matcher) => unit.expect(actual, matcher);

  toEqual(actual, expected) => unit.expect(actual, unit.equals(expected));

  toContain(actual, expected) => unit.expect(actual, unit.contains(expected));

  toBe(actual, expected) =>
      unit.expect(actual, unit.predicate((actual) => identical(expected, actual), '$expected'));

  toThrow(actual, [exception]) =>
      unit.expect(actual, exception == null ? unit.throws: unit.throwsA(new ExceptionContains(exception)));

  toBeFalsy(actual) => unit.expect(actual, _isFalsy, reason: '"$actual" is not Falsy');

  toBeTruthy(actual) => unit.expect(actual, (v) => !_isFalsy(v), reason: '"$actual" is not Truthy');

  toBeDefined(actual) => unit.expect(actual, unit.isNotNull);

  toBeNull(actual) => unit.expect(actual, unit.isNull);

  toBeNotNull(actual) => unit.expect(actual, unit.isNotNull);

  toHaveHtml(actual, expected) => unit.expect(htmlUtils.toHtml(actual), unit.equals(expected));

  toHaveText(actual, expected) => unit.expect(htmlUtils.elementText(actual), unit.equals(expected));

  toHaveClass(actual, cls) =>
      unit.expect(actual.classes.contains(cls), true,
        reason: ' Expected ${actual} to have css class ${cls}');

  toHaveAttribute(actual, name, [value = null]) {
    unit.expect(actual.attributes.containsKey(name), true, reason: 'Epxected $actual to have attribute $name');
    if (value != null)
      unit.expect(actual.attributes[name], value, reason: 'Epxected $actual attribute "$name" to be "$value"');
  }

  toHaveBeenCalled(actual) => unit.expect(actual.called, true, reason: 'method not called');

  toHaveBeenCalledOnce(actual) =>
      unit.expect(actual.count, 1, reason: 'method invoked ${actual.count} expected once');

  toHaveBeenCalledWith(actual, [a=_u,b=_u,c=_u,d=_u,e=_u,f=_u]) =>
      unit.expect(actual.firstArgsMatch(a,b,c,d,e,f),
        true,
        reason: 'method invoked with correct arguments');

  toHaveBeenCalledOnceWith(actual, [a=_u,b=_u,c=_u,d=_u,e=_u,f=_u]) =>
      unit.expect(actual.count == 1 && actual.firstArgsMatch(a,b,c,d,e,f),
        true,
        reason: 'method invoked once with correct arguments.'
        '(Called ${actual.count} times)');

  notToEqual(actual, expected) => unit.expect(actual, unit.isNot(unit.equals(expected)));

  notToContain(actual, expected) => unit.expect(actual, unit.isNot(unit.contains(expected)));

  notToBe(actual, expected) =>
      unit.expect(actual, unit.predicate((actual) => !identical(expected, actual), 'not $expected'));

  toReturnNormally(actual) => unit.expect(actual, unit.returnsNormally);

  toBeUndefined(actual) => unit.expect(actual, unit.isNull);

  notToHaveHtml(actual, expected) => unit.expect(htmlUtils.toHtml(actual), unit.isNot(unit.equals(expected)));

  notToHaveText(actual, expected) => unit.expect(htmlUtils.elementText(actual), unit.isNot(unit.equals(expected)));

  notToHaveClass(actual, cls) =>
      unit.expect(actual.classes.contains(cls), false,
        reason: ' Expected ${actual} not to have css class ${cls}');

  notToHaveAttribute(actual, name) =>
      unit.expect(actual.attributes.containsKey(name),
        false,
        reason: 'Epxected $actual not to have attribute $name');

  notToHaveBeenCalled(actual) => unit.expect(actual.called, false, reason: 'method called');

  notToHaveBeenCalledWith(actual, [a=_u,b=_u,c=_u,d=_u,e=_u,f=_u]) =>
      unit.expect(actual.firstArgsMatch(a,b,c,d,e,f),
        false,
        reason: 'method invoked with correct arguments');
}

_isFalsy(v) => v == null ? true: v is bool ? v == false : false;

class ExceptionContains extends unit.Matcher {
  final _expected;
  const ExceptionContains(this._expected);

  bool matches(item, Map matchState) {
    if (item is String) {
      return item.indexOf(_expected) >= 0;
    }
    return matches('$item', matchState);
  }

  unit.Description describe(unit.Description description) =>
      description.add('exception contains ').addDescriptionOf(_expected);

  unit.Description describeMismatch(item, unit.Description mismatchDescription,
                                    Map matchState, bool verbose) =>
      super.describeMismatch('$item', mismatchDescription, matchState, verbose);
}

void unitTestRunner(Suite suite){
  var r = new UnitTestVisitor();
  async.scheduleMicrotask((){
    suite.visit(r);
  });
}