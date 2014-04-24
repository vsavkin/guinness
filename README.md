# Guinness

This is a port of the Jasmine library to Dart. It is inspired by the AngularDart implementation of Jasmine.

## Example

The library can be used as follows:

    import 'package:guinness/guinness.dart';

    main(){
      beforeEach((){
        print("before");
      });

      afterEach((){
        print("after");
      });

      it("aaa", (){
        expect(5).toEqual(5);
      });

      describe("bbb", (){
        beforeEach((){
          print("inner before");
        });

        afterEach((){
          print("inner after");
        });

        it("ddd", (){
          expect(3).toBe(3);
        });
      });

      it("ccc", (){
        expect("hello").toContain("lo");
      });
    }

It supporst `iit`, `xit`, `ddescribe`, `xdescribe`:

    iit("solo", (){});
    xit("exclude", (){});

    ddescribe("solo", (){});
    xdescribe("exclude", (){});

Spy functions work as well:

    final s = jasmine.createSpy();
    s(1,2,3);
    expect(s).toHaveBeenCalledWith(1,2,3);
    ...

Expectations work too:

    expect(3).toBe(5);
    expect(5).not.toEqual(4);
    expect(()=> throw "Boom!").toThrow("Boom!");
    expect((){}).not.toThrow();
    expect(div).toHaveHtml("<div>hello</div>");
    ...

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