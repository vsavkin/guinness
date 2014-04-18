# JasmineDart Spike

This is a spike demonstrating a way to port the Jasmine library to Dart.

## Key Ideas

* The semantic model is separated from the syntax.
* The library supports pluggable 'backends', and the unittest library is only one of them.
* The parsing of a test file is separated from its execution.


### Semantic Model is Separated from the Syntax

It allows the creation of Spec/Describe/Suite objects, and their analysis without using the context-dependent
nested Jasmine syntax.

### Pluggable Backends

It is mostly useful for testing the Jasmine Dart library itself. It also separates the Jasmine syntax from
how Spec/Describe/Suite objects actually work.

### Parsing != Execution

The library first builds a tree of Describe/Spec objects, and only after that executes it. It enables all sorts of
preprocessing (like filtering, reordering, etc.).

## Example

The library can be used as follows:


    import 'package:jasmine_dart/jasmine.dart';

    main(){
      it("aaa", (){
        expect(5).toEqual(3);
      });

      describe("bbb", (){
        it("ddd", (){
          expect(5).toEqual(3);
        });
      });

      it("ccc", (){
        expect(5).toEqual(4);
      });
    }