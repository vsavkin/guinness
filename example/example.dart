library example;

import 'package:guinness/guinness_html.dart';
import 'dart:html';

class TestClass {
}

main(){
  guinnessEnableHtmlMatchers();

  describe("guinness", (){
    it("has various built-in matchers", (){
      expect(2).toEqual(2);
      expect([1,2]).toContain(2);
      expect(2).toBe(2);
      expect(2).toBeA(num);
      expect(new TestClass()).toBeAnInstanceOf(TestClass);
      expect("sfs").not.toBeAnInstanceOf(TestClass);
      expect(()=> throw "BOOM").toThrowWith();
      expect(()=> throw "BOOM").toThrowWith(message: "BOOM");
      expect(()=> throw "BOOM").toThrowWith(message: new RegExp("B[O]{2}M"));
      expect(()=> throw new TestClass()).toThrowWith(anInstanceOf: TestClass);
      expect(()=> throw new TestClass()).toThrowWith(type: TestClass);
      expect(false).toBeFalsy();
      expect(null).toBeFalsy();
      expect(true).toBeTruthy();
      expect("any object").toBeTruthy();
      expect(false).toBeFalse();
      expect(true).toBeTrue();
      expect("any object").toBeDefined();
      expect(null).toBeNull();
      expect("not null").toBeNotNull();

      expect(2).not.toEqual(1);
      expect([1,2]).not.toContain(3);
      expect([1,2]).not.toBe([1,2]);
      expect((){}).not.toThrow();
      expect(null).not.toBeDefined();


      expect(new DocumentFragment.html("<div>some html</div>"))
          .toHaveHtml("<div>some html</div>");

      expect(new DocumentFragment.html("<div>some text</div>"))
          .toHaveText("some text");

      expect(new DivElement()..classes.add('abc'))
          .toHaveClass("abc");

      expect(new DivElement()..attributes['attr'] = 'value')
          .toHaveAttribute("attr");

      expect(new DocumentFragment.html("<div>some html</div>"))
          .not.toHaveHtml("<div>some other html</div>");

      expect(new DocumentFragment.html("<div>some text</div>"))
          .not.toHaveText("some other text");

      expect(new DivElement()..classes.add('abc'))
          .not.toHaveClass("def");

      expect(new DivElement()..attributes['attr'] = 'value')
          .not.toHaveAttribute("other-attr");

      final select = new SelectElement();
      select.children
        ..add(new OptionElement(value: "1"))
        ..add(new OptionElement(value: "2", selected: true))
        ..add(new OptionElement(value: "3"));

      expect(select).toEqualSelect(["1", ["2"], "3"]);
    });

    describe("spy", (){
      it("supports spy functions", (){
        final s = guinness.createSpy("my spy");
        expect(s).not.toHaveBeenCalled();

        s(1);
        expect(s).toHaveBeenCalled();
        expect(s).toHaveBeenCalledOnce();
        expect(s).toHaveBeenCalledWith(1);
        expect(s).toHaveBeenCalledOnceWith(1);
        expect(s).not.toHaveBeenCalledWith(2);

        s(2);
        expect((){
          expect(s).toHaveBeenCalledOnce();
        }).toThrowWith();

        expect((){
          expect(s).toHaveBeenCalledOnceWith(1);
        }).toThrowWith();
      });
    });

    describe("beforeEach", (){
      var res = [];
      beforeEach((){ res.add("outer"); });

      describe("nested describe", (){
        beforeEach((){ res.add("inner"); });

        it("run callbacks in order", (){
          expect(res).toEqual(["outer", "inner"]);
        });
      });
    });

    describe("afterEach", (){
      var res = [];

      afterEach((){ res.add("outer"); });

      describe("nested describe", (){
        afterEach((){ res.add("inner"); });

        it("will run afterEach after this test", (){});

        it("runs callbacks in reverse order", (){
          expect(res).toEqual(["inner", "outer"]);
        });
      });
    });

    xdescribe("won't run", (){
      it("won't run", (){
        throw "Won't Run!";
      });
    });

    xit("won't run", (){
      throw "Won't Run!";
    });

    //also supports ddescribe, and iit
  });
}