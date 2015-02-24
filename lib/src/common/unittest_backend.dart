part of guinness;

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
    final v = new ExclusiveVisitor();
    v.visitSuite(suite);

    containsExclusiveIt = v.containsExclusiveIt;
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

      if (it.exclusive) {
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

  void expect(actual, matcher, {String reason}) =>
      unit.expect(actual, matcher, reason: reason);

  void toEqual(actual, expected) => unit.expect(actual, unit.equals(expected));

  void toContain(actual, expected) =>
      unit.expect(actual, unit.contains(expected));

  void toBe(actual, expected) => unit.expect(actual,
      unit.predicate((actual) => identical(expected, actual), '$expected'));

  void toBeLessThan(num actual, num expected) =>
      unit.expect(actual, unit.lessThan(expected));

  void toBeGreaterThan(num actual, num expected) =>
      unit.expect(actual, unit.greaterThan(expected));

  void toBeCloseTo(num actual, num expected, num precision) =>
      unit.expect(actual, unit.closeTo(expected, math.pow(10, -precision) / 2));

  void toBeA(actual, expected) =>
      unit.expect(actual, new IsSubtypeOf(expected));

  void toBeAnInstanceOf(actual, expected) =>
      unit.expect(actual, new IsInstanceOf(expected));

  void toThrow(actual, [Pattern pattern]) => unit.expect(actual, pattern == null
      ? unit.throws
      : unit.throwsA(new ExceptionMatcher(message: pattern)));

  void toThrowWith(actual,
      {Type anInstanceOf, Type type, Pattern message, Function where}) {
    final matcher = new ExceptionMatcher(
        anInstanceOf: anInstanceOf, type: type, message: message, where: where);
    unit.expect(actual, unit.throwsA(matcher),
        failureHandler: new NestedMatcherAwareFailureHandler());
  }

  void toBeFalsy(actual) =>
      unit.expect(actual, _isFalsy, reason: '"$actual" is not Falsy');

  void toBeTruthy(actual) => unit.expect(actual, (v) => !_isFalsy(v),
      reason: '"$actual" is not Truthy');

  void toBeFalse(actual) => unit.expect(actual, unit.isFalse);

  void toBeTrue(actual) => unit.expect(actual, unit.isTrue);

  void toBeDefined(actual) => unit.expect(actual, unit.isNotNull);

  void toBeNull(actual) => unit.expect(actual, unit.isNull);

  void toBeNotNull(actual) => unit.expect(actual, unit.isNotNull);

  void toHaveBeenCalled(actual) =>
      unit.expect(actual.called, true, reason: 'method not called');

  void toHaveBeenCalledOnce(actual) => unit.expect(actual.count, 1,
      reason: 'method invoked ${actual.count} expected once');

  void toHaveBeenCalledWith(actual,
      [a = _u, b = _u, c = _u, d = _u, e = _u, f = _u]) => unit.expect(
          actual.firstArgsMatch(a, b, c, d, e, f), true,
          reason: 'method invoked with correct arguments');

  void toHaveBeenCalledOnceWith(actual,
      [a = _u, b = _u, c = _u, d = _u, e = _u, f = _u]) => unit.expect(
          actual.count == 1 && actual.firstArgsMatch(a, b, c, d, e, f), true,
          reason: 'method invoked once with correct arguments.'
          '(Called ${actual.count} times)');

  void toHaveSameProps(actual, expected) =>
      unit.expect(actual, new SamePropsMatcher(expected));

  void notToEqual(actual, expected) =>
      unit.expect(actual, unit.isNot(unit.equals(expected)));

  void notToContain(actual, expected) =>
      unit.expect(actual, unit.isNot(unit.contains(expected)));

  void notToBe(actual, expected) => unit.expect(actual, unit.predicate(
      (actual) => !identical(expected, actual), 'not $expected'));

  void notToBeLessThan(num actual, num expected) =>
      unit.expect(actual, unit.isNot(unit.lessThan(expected)));

  void notToBeGreaterThan(num actual, num expected) =>
      unit.expect(actual, unit.isNot(unit.greaterThan(expected)));

  void notToBeCloseTo(num actual, num expected, num precision) =>
      unit.expect(actual,
          unit.isNot(unit.closeTo(expected, math.pow(10, -precision) / 2)));

  void notToBeA(actual, expected) =>
      unit.expect(actual, unit.isNot(new IsSubtypeOf(expected)));

  void notToBeAnInstanceOf(actual, expected) =>
      unit.expect(actual, unit.isNot(new IsInstanceOf(expected)));

  void toReturnNormally(actual) => unit.expect(actual, unit.returnsNormally);

  void toBeUndefined(actual) => unit.expect(actual, unit.isNull);

  void notToHaveBeenCalled(actual) =>
      unit.expect(actual.called, false, reason: 'method called');

  void notToHaveBeenCalledWith(actual,
      [a = _u, b = _u, c = _u, d = _u, e = _u, f = _u]) => unit.expect(
          actual.firstArgsMatch(a, b, c, d, e, f), false,
          reason: 'method invoked with correct arguments');

  void notToHaveSameProps(actual, expected) =>
      unit.expect(actual, unit.isNot(new SamePropsMatcher(expected)));
}

bool _isFalsy(v) => v == null ? true : v is bool ? v == false : false;

/// Matches an exception against its type, class, and message
class ExceptionMatcher extends unit.Matcher {
  final List<unit.Matcher> _matchers = [];

  ExceptionMatcher(
      {Type anInstanceOf, Type type, Pattern message, Function where}) {
    if (message != null) _matchers.add(new PatternMatcher(message));
    if (type != null) _matchers.add(new IsSubtypeOf(type));
    if (anInstanceOf != null) _matchers.add(new IsInstanceOf(anInstanceOf));
    if (where != null) _matchers.add(new WhereMatcher(where));
  }

  bool matches(item, Map matchState) =>
      _matchers.every((matcher) => matcher.matches(item, matchState));

  unit.Description describe(unit.Description description) {
    if (_matchers.isEmpty) return description;

    description.add('an exception, which ');

    _matchers.first.describe(description);
    _matchers.skip(1).forEach((matcher) {
      description.add(", and ");
      matcher.describe(description);
    });

    return description;
  }
}

/**
 * Checks if there is a nested matcher failure recorded in [matchState],
 * and includes it into an error message if it is the case.
 */
class NestedMatcherAwareFailureHandler implements unit.FailureHandler {
  void fail(String reason) => _handler.fail(reason);

  void failMatch(actual, unit.Matcher matcher, String reason, Map matchState,
      bool verbose) => _handler.failMatch(
          actual, matcher, _reason(matchState, reason), matchState, verbose);

  _reason(matchState, reason) => _hasNestedMatcherFailure(matchState)
      ? _formatNestedMatcherFailure(matchState)
      : reason;

  _hasNestedMatcherFailure(matchState) => matchState.containsKey("state") &&
      matchState["state"].containsKey("nestedMatcherFailure");

  _formatNestedMatcherFailure(matchState) =>
      "\nFailed Assertion:\n${matchState["state"]["nestedMatcherFailure"].message}";

  get _handler => unit.getOrCreateExpectFailureHandler();
}

/// Matches when the object is verified by [_where]
class WhereMatcher extends unit.Matcher {
  final Function _where;

  const WhereMatcher(this._where);

  bool matches(obj, Map matchState) {
    try {
      return _where(obj) != false;
    } on unit.TestFailure catch (e) {
      matchState["nestedMatcherFailure"] = e;
      return false;
    }
  }

  unit.Description describe(unit.Description description) =>
      description.add("is verified by `where`");
}

class PatternMatcher extends unit.Matcher {
  final Pattern _pattern;

  const PatternMatcher(this._pattern);

  bool matches(obj, Map matchState) =>
      _pattern.allMatches(obj.toString()).isNotEmpty;

  unit.Description describe(unit.Description description) =>
      description.add('matches $_pattern');
}

/// Matches when the object is a subtype of [_type]
class IsSubtypeOf extends unit.Matcher {
  final Type _type;

  const IsSubtypeOf(this._type);

  bool matches(obj, Map matchState) {
    //Delete the try-catch when Dart2JS supports `isSubtypeOf`.
    try {
      return mirrors.reflect(obj).type.isSubtypeOf(mirrors.reflectClass(_type));
    } on UnimplementedError catch (e) {
      if (_isDart2js) {
        throw "The IsSubtypeOf matcher is not supported in Dart2JS";
      } else {
        rethrow;
      }
    }
  }

  unit.Description describe(unit.Description description) =>
      description.add('a subtype of $_type');
}

/// Matches when objects have the same properties
class SamePropsMatcher extends unit.Matcher {
  final Object _expected;

  const SamePropsMatcher(this._expected);

  bool matches(actual, Map matchState) {
    return compare(toData(_expected), toData(actual));
  }

  unit.Description describeMismatch(item, unit.Description mismatchDescription,
      Map matchState, bool verbose) => mismatchDescription
      .add('is equal to ${toData(item)}. Expected: ${toData(_expected)}');

  unit.Description describe(unit.Description description) =>
      description.add('has different properties');

  toData(obj) => new _ObjToData().call(obj);
  compare(d1, d2) => new DeepCollectionEquality().equals(d1, d2);
}

class _ObjToData {
  final visitedObjects = new Set();

  call(obj) {
    if (visitedObjects.contains(obj)) return null;
    visitedObjects.add(obj);

    if (obj is num || obj is String || obj is bool) return obj;
    if (obj is Iterable) return obj.map(call).toList();
    if (obj is Map) return mapToData(obj);
    return toDataUsingReflection(obj);
  }

  mapToData(obj) {
    var res = {};
    obj.forEach((k, v) {
      res[call(k)] = call(v);
    });
    return res;
  }

  toDataUsingReflection(obj) {
    final clazz = mirrors.reflectClass(obj.runtimeType);
    final instance = mirrors.reflect(obj);

    return clazz.declarations.values.fold({}, (map, decl) {
      if (decl is mirrors.VariableMirror && !decl.isPrivate && !decl.isStatic) {
        final field = instance.getField(decl.simpleName);
        final name = mirrors.MirrorSystem.getName(decl.simpleName);
        map[name] = call(field.reflectee);
      }
      return map;
    });
  }
}

/// Matches when the object is an instance of [_type]
class IsInstanceOf extends unit.Matcher {
  final Type _type;

  const IsInstanceOf(this._type);

  bool matches(obj, Map matchState) =>
      mirrors.reflect(obj).type.reflectedType == _type;

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

bool get _isDart2js => identical(1, 1.0);
