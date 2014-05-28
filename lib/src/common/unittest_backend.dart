part of guinness;

class ExclusiveItVisitor implements SpecVisitor {
  bool _containsExclusiveIt = false;

  void visitSuite(Suite suite) {
    _visitChildren(suite.children);
  }

  void visitDescribe(Describe describe) {
    if (describe.excluded) return;
    _visitChildren(describe.children);
  }

  void visitIt(It it) {
    if (it.excluded) return;
    if (it.exclusive)
      _containsExclusiveIt = true;
  }

  _visitChildren(children) {
    children.forEach((c) => c.visit(this));
  }

  static bool containsExclusiveIt(Suite suite) {
    final v = new ExclusiveItVisitor();
    v.visitSuite(suite);
    return v._containsExclusiveIt;
  }
}

class UnitTestAdapter {
  const UnitTestAdapter();
  void group(String name, Function fn) => unit.group(name, fn);
  void solo_group(String name, Function fn) => unit.solo_group(name, fn);
  void test(String name, Function fn) => unit.test(name, fn);
  void solo_test(String name, Function fn) => unit.solo_test(name, fn);
}

class UnitTestVisitor implements SpecVisitor {
  bool containsExclusiveIt = false;
  Set initializedSpecs;
  dynamic unit;

  UnitTestVisitor(this.initializedSpecs, {this.unit: const UnitTestAdapter()});

  void visitSuite(Suite suite) {
    containsExclusiveIt = ExclusiveItVisitor.containsExclusiveIt(suite);
    _visitChildren(suite.children);
  }

  void visitDescribe(Describe describe) {
    _once(describe, () {
      if (describe.excluded) return;

      if (describe.exclusive && !containsExclusiveIt) {
        unit.solo_group(describe.name, () {
          _visitChildren(describe.children);
        });
      } else {
        unit.group(describe.name, () {
          _visitChildren(describe.children);
        });
      }
    });
  }

  void visitIt(It it) {
    _once(it, () {
      if (it.excluded) return;

      if (it.exclusive){
        unit.solo_test(it.name, it.withSetupAndTeardown);
      } else {
        unit.test(it.name, it.withSetupAndTeardown);
      }
    });
  }

  _visitChildren(children) {
    children.forEach((c) => c.visit(this));
  }

  _once(spec, Function func) {
    if (initializedSpecs.contains(spec)) return;
    func();
    initializedSpecs.add(spec);
  }
}

class UnitTestMatchers implements Matchers {
  get config => {};

  expect(actual, matcher, {String reason}) => unit.expect(actual, matcher, reason: reason);

  toEqual(actual, expected) => unit.expect(actual, unit.equals(expected));

  toContain(actual, expected) => unit.expect(actual, unit.contains(expected));

  toBe(actual, expected) =>
      unit.expect(actual, unit.predicate((actual) => identical(expected, actual), '$expected'));

  toBeA(actual, expected) => unit.expect(actual, new IsInstanceOf(expected));

  toThrow(actual, [Pattern pattern]) => unit.expect(actual, pattern == null ?
          unit.throws : unit.throwsA(new ExceptionMatcher(message: pattern)));

  toThrowWith(actual, {Type type, Pattern message}) =>
      unit.expect(actual, unit.throwsA(
          new ExceptionMatcher(type: type, message: message)));

  toBeFalsy(actual) => unit.expect(actual, _isFalsy, reason: '"$actual" is not Falsy');

  toBeTruthy(actual) => unit.expect(actual, (v) => !_isFalsy(v), reason: '"$actual" is not Truthy');

  toBeDefined(actual) => unit.expect(actual, unit.isNotNull);

  toBeNull(actual) => unit.expect(actual, unit.isNull);

  toBeNotNull(actual) => unit.expect(actual, unit.isNotNull);

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

  notToBeA(actual, expected) => unit.expect(actual, unit.isNot(new IsInstanceOf(expected)));

  toReturnNormally(actual) => unit.expect(actual, unit.returnsNormally);

  toBeUndefined(actual) => unit.expect(actual, unit.isNull);

  notToHaveBeenCalled(actual) => unit.expect(actual.called, false, reason: 'method called');

  notToHaveBeenCalledWith(actual, [a=_u,b=_u,c=_u,d=_u,e=_u,f=_u]) =>
      unit.expect(actual.firstArgsMatch(a,b,c,d,e,f),
        false,
        reason: 'method invoked with correct arguments');
}

_isFalsy(v) => v == null ? true: v is bool ? v == false : false;

/// Matches exceptions against a [Type] and a message
class ExceptionMatcher extends unit.Matcher {
  final Pattern message;
  final unit.Matcher _typeMatcher;

  ExceptionMatcher({Type type, Pattern message})
      : _typeMatcher = type == null ? null : new IsInstanceOf(type),
      message = message;

  bool matches(item, Map matchState) {
    if (message != null) {
      var strItem = item is String ? item : item.toString();
      return message.allMatches(strItem).isNotEmpty;
    }

    if (_typeMatcher != null) if (!_typeMatcher.matches(item, matchState)) return false;

    return true;
  }

  unit.Description describe(unit.Description description) {
    var join = '';
    if (_typeMatcher != null) {
      description.add('exception is ').addDescriptionOf(_typeMatcher);
      join = ' and';
    }
    if (message != null) description.add('$join message contains "$message"');
  }
}

/// Matches when the object is an instance of [_type]
class IsInstanceOf extends unit.Matcher {
  final Type _type;

  const IsInstanceOf(this._type);

  bool matches(obj, Map matchState) =>
      mirrors.reflect(obj).type.isSubtypeOf(mirrors.reflectClass(_type));

  unit.Description describe(unit.Description description) =>
      description.add('an instance of $_type');
}

Set _initializedSpecs = new Set();

void unitTestInitSpecs(Suite suite) {
  var r = new UnitTestVisitor(_initializedSpecs);
  suite.visit(r);
}

void unitTestRunner(Suite suite) {
  unitTestInitSpecs(suite);
  unit.runTests();
}