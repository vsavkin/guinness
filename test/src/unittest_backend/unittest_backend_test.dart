part of jasmine_test;

assertTrue(Function fn) => expect(fn, returnsNormally);
assertFalse(Function fn) => expect(fn, throws);

testUnitTestBackend(){
  group("[UnitTestMatchers]", (){
    final jasmine.Matchers matchers = new jasmine.UnitTestMatchers();

    test("toBe", (){
      var x = [1,2];
      var y = [1,2];
      assertFalse(() => matchers.toBe(x, y));
      assertTrue(() => matchers.toBe(x, x));
    });

    test("toThrow", (){
      assertTrue(() => matchers.toThrow(() => throw "Wow!"));
      assertFalse(() => matchers.toThrow((){}));
      assertTrue(() => matchers.toThrow(() => throw "Wow!", "Wow!"));
      assertFalse(() => matchers.toThrow(() => throw "Wow!", "Boom!"));
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

    test("toHaveBeenCalled", (){
      final spy = new jasmine.SpyFunction("");

      assertFalse(() => matchers.toHaveBeenCalled(spy));

      spy();

      assertTrue(() => matchers.toHaveBeenCalled(spy));
    });

    test("toHaveBeenCalledOnce", (){
      final spy = new jasmine.SpyFunction("");

      assertFalse(() => matchers.toHaveBeenCalledOnce(spy));

      spy();

      assertTrue(() => matchers.toHaveBeenCalledOnce(spy));

      spy();

      assertFalse(() => matchers.toHaveBeenCalledOnce(spy));
    });

    test("toHaveBeenCalledWith", (){
      final spy = new jasmine.SpyFunction("");

      assertFalse(() => matchers.toHaveBeenCalledWith(spy, 1, 2));

      spy(1,2);

      assertTrue(() => matchers.toHaveBeenCalledWith(spy, 1, 2));
      assertFalse(() => matchers.toHaveBeenCalledWith(spy, 3, 4));
    });

    test("toHaveBeenCalledOnceWith", (){
      final spy = new jasmine.SpyFunction("");

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
      final spy = new jasmine.SpyFunction("");

      assertTrue(() => matchers.notToHaveBeenCalled(spy));

      spy();

      assertFalse(() => matchers.notToHaveBeenCalled(spy));
    });

    test("notToHaveBeenCalledWith", (){
      final spy = new jasmine.SpyFunction("");

      assertTrue(() => matchers.notToHaveBeenCalledWith(spy, 1, 2));

      spy(1,2);

      assertFalse(() => matchers.notToHaveBeenCalledWith(spy, 1, 2));
      assertTrue(() => matchers.notToHaveBeenCalledWith(spy, 3, 4));
    });
  });
}