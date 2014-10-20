part of guinness_test;

assertTrue(Function fn) => expect(fn, returnsNormally);
assertFalse(Function fn) => expect(fn, throws);

class TestClass {
}

testUnitTestBackend(){
  group("[UnitTestVisitor]", () {
    var visitor, unit;

    setUp(() {
      unit = mock();
      visitor = new guinness.UnitTestVisitor(new Set(), unit: unit);
    });

    tearDown(currentTestRun.verify);

    test('handles an empty suite', () {
      visitor.visitSuite(createSuite());
    });

    test('uses group for describe', () {
      final suite = createSuite()
        ..add(createDescribe());

      unit.shouldReceive("group");

      visitor.visitSuite(suite);
    });

    test('uses solo_group for exclusive describe', () {
      final suite = createSuite()
        ..add(createDescribe(exclusive: true));

      unit.shouldReceive("solo_group");

      visitor.visitSuite(suite);
    });

    test('skips excluded describes', () {
      final suite = createSuite()
        ..add(createDescribe(excluded: true));

      visitor.visitSuite(suite);
    });

    test('uses test for it', () {
      final suite = createSuite()
        ..add(createIt());

      unit.shouldReceive("test");

      visitor.visitSuite(suite);
    });

    test('uses solo_test for exclusive it', () {
      final suite = createSuite()
        ..add(createIt(exclusive: true));

      unit.shouldReceive("solo_test");

      visitor.visitSuite(suite);
    });

    test('skips excluded its', () {
      final suite = createSuite()
        ..add(createIt(excluded: true));

      visitor.visitSuite(suite);
    });

    test('runs only exlusive its', () {
      final suite = createSuite()
        ..add(createIt(exclusive: true))
        ..add(createDescribe(exclusive: true));

      unit.shouldReceive("group");
      unit.shouldReceive("solo_test");

      visitor.visitSuite(suite);
    });

    test("initializes specs only once", () {
      final suite = createSuite()
        ..add(createIt())
        ..add(createDescribe());

      unit.shouldReceive("test").times(1);
      unit.shouldReceive("group").times(1);

      visitor.visitSuite(suite);

      visitor.visitSuite(suite);
    });
  });

  group("[UnitTestMatchers]", () {
    final matchers = new guinness.UnitTestMatchersWithHtml();

    test("toBe", (){
      var x = [1,2];
      var y = [1,2];
      assertFalse(() => matchers.toBe(x, y));
      assertTrue(() => matchers.toBe(x, x));
    });

    test("toBeLessThan", () {
      assertFalse(() => matchers.toBeLessThan(9, 9));
      assertTrue(() => matchers.toBeLessThan(-4, 9));
      assertFalse(() => matchers.toBeLessThan(9, -4));
    });

    test("toBeGreaterThan", () {
      assertFalse(() => matchers.toBeGreaterThan(9, 9));
      assertFalse(() => matchers.toBeGreaterThan(-4, 9));
      assertTrue(() => matchers.toBeGreaterThan(9, -4));
    });

    test("toBeCloseTo", () {
      assertTrue(() => matchers.toBeCloseTo(9, 9, 0));
      assertTrue(() => matchers.toBeCloseTo(9.123, 9.12, 2));
      assertFalse(() => matchers.toBeCloseTo(9.123, 9.12, 3));;
    });

    test("toBeA", skipDart2Js((){
      assertFalse(() => matchers.toBeA(2, String));
      assertTrue(() => matchers.toBeA(2, num));
    }));

    test("toBeAnInstanceOf", (){
      assertFalse(() => matchers.toBeAnInstanceOf("blah", TestClass));
      assertTrue(() => matchers.toBeAnInstanceOf(new TestClass(), TestClass));
    });

    test("toThrow", (){
      assertTrue(() => matchers.toThrow(() => throw "Wow!"));
      assertFalse(() => matchers.toThrow((){}));
      assertTrue(() => matchers.toThrow(() => throw "Wow!", "Wow!"));
      assertFalse(() => matchers.toThrow(() => throw "Wow!", "Boom!"));
    });

    test("toThrowWith", (){
      assertTrue(() => matchers.toThrowWith(() => throw "Wow!"));
      assertFalse(() => matchers.toThrowWith((){}));
      assertTrue(() => matchers.toThrowWith(() => throw "Wow!", message: "Wow!"));
      assertFalse(() => matchers.toThrowWith(() => throw "Wow!", message: "Boom!"));
      assertTrue(() => matchers.toThrowWith(
              () => throw new ArgumentError("123"),
          message: new RegExp(r"^.*[1-9]{3}$")));
      assertFalse(() => matchers.toThrowWith(
              () => throw new ArgumentError("123"),
          message: new RegExp(r"^.*[a-zA-Z]{3}$")));
      assertFalse(() => matchers.toThrowWith(
              () => throw new ArgumentError("123"),
          anInstanceOf: UnsupportedError));
      assertTrue(() => matchers.toThrowWith(
              () => throw new ArgumentError("123"),
          anInstanceOf: ArgumentError));
      assertTrue(() {
        matchers.toThrowWith(() => throw new ArgumentError("123"), where: (e) {
          expect(e.message, equals("123"));
        });
      });
      assertFalse(() {
        matchers.toThrowWith(() => throw new ArgumentError("123"), where: (e) {
          expect(e.message, equals("456"));
        });
      });
      assertTrue(() {
        matchers.toThrowWith(
            () => throw new ArgumentError("123"),
            where: (e) => e.message == "123");
      });
      assertFalse(() {
        matchers.toThrowWith(
            () => throw new ArgumentError("123"),
            where: (e) => e.message == "456");
      });

      skipDart2Js(() {
        assertTrue(() => matchers.toThrowWith(
            () => throw new ArgumentError(),
            type: ArgumentError));
        assertFalse(() => matchers.toThrowWith(
            () => throw new ArgumentError(),
            type: UnsupportedError));
      });
    });

    test("toBeFalsy", (){
      assertTrue(() => matchers.toBeFalsy(null));
      assertTrue(() => matchers.toBeFalsy(false));
      assertFalse(() => matchers.toBeFalsy("any object"));
      assertFalse(() => matchers.toBeFalsy(true));
    });

    test("toBeTruthy", (){
      assertFalse(() => matchers.toBeTruthy(null));
      assertFalse(() => matchers.toBeTruthy(false));
      assertTrue(() => matchers.toBeTruthy("any object"));
      assertTrue(() => matchers.toBeTruthy(true));
    });

    test("toBeFalse", (){
      assertTrue(() => matchers.toBeFalse(false));
      assertFalse(() => matchers.toBeFalse(true));
      assertFalse(() => matchers.toBeFalse(null));
      assertFalse(() => matchers.toBeFalse("any object"));
    });

    test("toBeTrue", (){
      assertTrue(() => matchers.toBeTrue(true));
      assertFalse(() => matchers.toBeTrue(null));
      assertFalse(() => matchers.toBeTrue(false));
      assertFalse(() => matchers.toBeTrue("any object"));
    });

    test("toHaveHtml", (){
      final div = new html.DivElement()..innerHtml = "<div>inner</div>";
      assertTrue(() => matchers.toHaveHtml(div, "<div>inner</div>"));
      assertFalse(() => matchers.toHaveHtml(div, "invalid"));
    });

    test("toHaveText", (){
      final div = new html.DivElement()..innerHtml = "expected";
      assertTrue(() => matchers.toHaveText(div, "expected"));
      assertFalse(() => matchers.toHaveText(div, "invalid"));
    });

    test("toContainText", (){
      final div = new html.DivElement()..innerHtml = "some expected text";
      assertTrue(() => matchers.toContainText(div, "expected"));
      assertFalse(() => matchers.toContainText(div, "invalid"));
    });

    test("toHaveClass", (){
      final div = new html.DivElement();
      div.classes.add("one");

      assertTrue(() => matchers.toHaveClass(div, "one"));
      assertFalse(() => matchers.toHaveClass(div, "two"));
    });

    test("toHaveAttribute", (){
      final div = new html.DivElement();
      div.attributes["one"] = "value";

      assertTrue(() => matchers.toHaveAttribute(div, "one"));
      assertTrue(() => matchers.toHaveAttribute(div, "one", "value"));
      assertFalse(() => matchers.toHaveAttribute(div, "two"));
      assertFalse(() => matchers.toHaveAttribute(div, "one", "invalid value"));
    });

    test("toEqualSelect", (){
      final select = new html.SelectElement();
      select.children.add(new html.OptionElement(value: "1"));
      select.children.add(new html.OptionElement(value: "2", selected: true));
      select.children.add(new html.OptionElement(value: "3"));

      assertTrue(() => matchers.toEqualSelect(select, ["1", ["2"], "3"]));
      assertFalse(() => matchers.toEqualSelect(select, ["1", "2", "3"]));
    });

    test("toHaveBeenCalled", (){
      final spy = new guinness.SpyFunction("");

      assertFalse(() => matchers.toHaveBeenCalled(spy));

      spy();

      assertTrue(() => matchers.toHaveBeenCalled(spy));
    });

    test("toHaveBeenCalledOnce", (){
      final spy = new guinness.SpyFunction("");

      assertFalse(() => matchers.toHaveBeenCalledOnce(spy));

      spy();

      assertTrue(() => matchers.toHaveBeenCalledOnce(spy));

      spy();

      assertFalse(() => matchers.toHaveBeenCalledOnce(spy));
    });

    test("toHaveBeenCalledWith", (){
      final spy = new guinness.SpyFunction("");

      assertFalse(() => matchers.toHaveBeenCalledWith(spy, 1, 2));

      spy(1,2);

      assertTrue(() => matchers.toHaveBeenCalledWith(spy, 1, 2));
      assertFalse(() => matchers.toHaveBeenCalledWith(spy, 3, 4));
    });

    test("toHaveBeenCalledOnceWith", (){
      final spy = new guinness.SpyFunction("");

      assertFalse(() => matchers.toHaveBeenCalledOnceWith(spy, 1, 2));

      spy(1,2);

      assertTrue(() => matchers.toHaveBeenCalledOnceWith(spy, 1, 2));

      spy(1,2);

      assertFalse(() => matchers.toHaveBeenCalledOnceWith(spy, 1, 2));
    });

    test("notToEqual", (){
      assertTrue(() => matchers.notToEqual("one", "two"));
      assertFalse(() => matchers.notToEqual("one", "one"));
    });

    test("notToContain", (){
      assertTrue(() => matchers.notToContain("one", "z"));
      assertFalse(() => matchers.notToContain("one", "o"));
    });

    test("notToBe", (){
      var x = [1,2];
      var y = [1,2];
      assertTrue(() => matchers.notToBe(x, y));
      assertFalse(() => matchers.notToBe(x, x));
    });

    test("notToBeLessThan", () {
      assertTrue(() => matchers.notToBeLessThan(9, 9));
      assertFalse(() => matchers.notToBeLessThan(-4, 9));
      assertTrue(() => matchers.notToBeLessThan(9, -4));
    });

    test("notToBeGreaterThan", () {
      assertTrue(() => matchers.notToBeGreaterThan(9, 9));
      assertTrue(() => matchers.notToBeGreaterThan(-4, 9));
      assertFalse(() => matchers.notToBeGreaterThan(9, -4));
    });

    test("notToBeCloseTo", () {
      assertFalse(() => matchers.notToBeCloseTo(9, 9, 0));
      assertFalse(() => matchers.notToBeCloseTo(9.123, 9.12, 2));
      assertTrue(() => matchers.notToBeCloseTo(9.123, 9.12, 3));;
    });

    test("notToBeA", skipDart2Js((){
      assertTrue(() => matchers.notToBeA(2, String));
      assertFalse(() => matchers.notToBeA(2, num));
    }));

    test("notToBeAnInstanceOf", (){
      assertTrue(() => matchers.notToBeAnInstanceOf(2, TestClass));
      assertFalse(() => matchers.notToBeAnInstanceOf(new TestClass(), TestClass));
    });

    test("toReturnNormally", (){
      assertFalse(() => matchers.toReturnNormally(() => throw "Wow!"));
      assertTrue(() => matchers.toReturnNormally((){}));
    });

    test("notToHaveHtml", (){
      final div = new html.DivElement()..innerHtml = "<div>inner</div>";
      assertFalse(() => matchers.notToHaveHtml(div, "<div>inner</div>"));
      assertTrue(() => matchers.notToHaveHtml(div, "invalid"));
    });

    test("notToHaveText", (){
      final div = new html.DivElement()..innerHtml = "expected";
      assertFalse(() => matchers.notToHaveText(div, "expected"));
      assertTrue(() => matchers.notToHaveText(div, "invalid"));
    });

    test("notToContainText", (){
      final div = new html.DivElement()..innerHtml = "some expected test";
      assertFalse(() => matchers.notToContainText(div, "expected"));
      assertTrue(() => matchers.notToContainText(div, "invalid"));
    });

    test("notToHaveClass", (){
      final div = new html.DivElement();
      div.classes.add("one");

      assertFalse(() => matchers.notToHaveClass(div, "one"));
      assertTrue(() => matchers.notToHaveClass(div, "two"));
    });

    test("notToHaveAttribute", (){
      final div = new html.DivElement();
      div.attributes["one"] = "value";

      assertFalse(() => matchers.notToHaveAttribute(div, "one"));
      assertTrue(() => matchers.notToHaveAttribute(div, "two"));
    });

    test("notToHaveBeenCalled", (){
      final spy = new guinness.SpyFunction("");

      assertTrue(() => matchers.notToHaveBeenCalled(spy));

      spy();

      assertFalse(() => matchers.notToHaveBeenCalled(spy));
    });

    test("notToHaveBeenCalledWith", (){
      final spy = new guinness.SpyFunction("");

      assertTrue(() => matchers.notToHaveBeenCalledWith(spy, 1, 2));

      spy(1,2);

      assertFalse(() => matchers.notToHaveBeenCalledWith(spy, 1, 2));
      assertTrue(() => matchers.notToHaveBeenCalledWith(spy, 3, 4));
    });
  });
}

Function skipDart2Js(Function fn) => !identical(1, 1.0) ?  fn : (){};