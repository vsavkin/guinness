# Guinness

This is a port of the Jasmine library to Dart. It is inspired by the AngularDart implementation of Jasmine.

## Installation

Add the Guinness dependency to your project’s pubspec.yaml.

    dependencies:
      guinness: ">=0.0.1 <0.1.0"

Then, run `pub install`.

Finally, import the guinness library.

    import 'package:guinness/guinness.dart';

## Example

The library can be used as follows:

    import 'package:guinness/guinness.dart';

    main(){
      describe("guinness", (){
        it("has various built-in matchers", (){
          expect(2).toEqual(2);
          expect([1,2]).toContain(2);
          expect(2).toBe(2);
          expect(()=> throw "BOOM").toThrow();
          expect(()=> throw "BOOM").toThrow("BOOM");
          expect(false).toBeFalsy();
          expect(null).toBeFalsy();
          expect(true).toBeTruthy();
          expect("any object").toBeTruthy();
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
            }).toThrow();

            expect((){
              expect(s).toHaveBeenCalledOnceWith(1);
            }).toThrow();
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

## Status

There are a few things that are still not supported (e.g., handling named parameters in expectations).

## Implementation Details

### Key Ideas

The main idea is to treat the Jasmine syntax as a domain specific language. Therefore, the implementation clearly separates such things as: syntax, semantic model, and execution model. Let's quickly look at the benefits this approach provices:

#### The semantic model is separate from the syntax.

The semantic model consists of It, Describe, Suite, BeforeEach, and AfterEach objects. You can create and analyse them without using the context-dependent nested Jasmine syntax.

#### The parsing of specs is separate from the execution of specs.

The library builds a tree of the It, Describe, Suite, BeforeEach, and AfterEach objects first. And after that, as a separate step, executes them. It enables all sorts of preprocessing (e.g., filtering, reordering).

#### Pluggable backends.

Since the library is a DSL, there can be multiple backend libraries actually executing the specs. By default, the library comes with the unittest backend.