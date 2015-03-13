part of guinness_test;

testSyntax(){
  group("[syntax]", (){
    var context;

    setUp((){
      context = new guinness.Context();
      guinness.guinness.resetContext(context);
    });

    group("[describe]", (){
      test("adds a describe to the current describe block", (){
        guinness.describe("new describe", (){});

        final actualDescribe = context.suite.children.first;

        expect(actualDescribe.name, equals("new describe"));
      });
    });

    group("[xdescribe]", (){
      test("adds a describe to the current describe block with excluded set to true", (){
        guinness.xdescribe("new xdescribe", (){});

        final actualDescribe = context.suite.children.first;

        expect(actualDescribe.name, equals("new xdescribe"));
        expect(actualDescribe.excluded, isTrue);
      });
    });

    group("[ddescribe]", (){
      test("adds a describe to the current describe block with exclusive set to true", (){
        guinness.ddescribe("new ddescribe", (){});

        final actualDescribe = context.suite.children.first;

        expect(actualDescribe.name, equals("DDESCRIBE: new ddescribe"));
        expect(actualDescribe.exclusive, isTrue);
      });
    });

    group("[fdescribe]", (){
      test("adds a describe to the current describe block with exclusive set to true", (){
        guinness.fdescribe("new fdescribe", (){});

        final actualDescribe = context.suite.children.first;

        expect(actualDescribe.name, equals("DDESCRIBE: new fdescribe"));
        expect(actualDescribe.exclusive, isTrue);
      });
    });

    group("[it]", (){
      test("adds an `it` to the current describe block", (){
        guinness.it("new it", (){});

        final actualIt = context.suite.children.first;

        expect(actualIt.name, equals("new it"));
        expect(actualIt.excluded, isFalse);
        expect(actualIt.exclusive, isFalse);
      });
    });

    group("[xit]", (){
      test("adds an `it` to the current describe block with excluded set to true", (){
        guinness.xit("new xit", (){});

        final actualIt = context.suite.children.first;

        expect(actualIt.name, equals("new xit"));
        expect(actualIt.excluded, isTrue);
      });
    });

    group("[iit]", (){
      test("adds an `it` to the current describe block with exclusive set to true", (){
        guinness.iit("new iit", (){});

        final actualIt = context.suite.children.first;

        expect(actualIt.name, equals("new iit"));
        expect(actualIt.exclusive, isTrue);
      });
    });

    group("[fit]", (){
      test("adds an `it` to the current describe block with exclusive set to true", (){
        guinness.fit("new fit", (){});

        final actualIt = context.suite.children.first;

        expect(actualIt.name, equals("new fit"));
        expect(actualIt.exclusive, isTrue);
      });
    });

    group("[beforeEach]", (){
      test("adds a before each fn to the current describe block", (){
        guinness.beforeEach((){});

        expect(context.suite.beforeEachFns.length, equals(1));
        expect(context.suite.beforeEachFns[0].priority, equals(0));
      });

      test("supports different priorities", (){
        guinness.beforeEach((){}, priority: 2);

        expect(context.suite.beforeEachFns[0].priority, equals(2));
      });
    });

    group("[afterEach]", (){
      test("adds a after each fn to the current describe block", (){
        guinness.afterEach((){});

        expect(context.suite.afterEachFns.length, equals(1));
        expect(context.suite.afterEachFns[0].priority, equals(0));
      });

      test("supports different priorities", (){
        guinness.afterEach((){}, priority: 2);

        expect(context.suite.afterEachFns[0].priority, equals(2));
      });
    });

    test("handles nested describes and its", (){
      guinness.describe("outer describe", (){
        guinness.it("outer it", (){});
        guinness.describe("inner describe", (){
          guinness.it("inner it", (){});
        });
      });

      expect(context.suite.children.length, equals(1));

      final outerDescribe = context.suite.children[0];
      expect(outerDescribe.name, equals("outer describe"));
      expect(outerDescribe.children[0].name, equals("outer it"));
      expect(outerDescribe.children[1].name, equals("inner describe"));

      final innerDescribe = outerDescribe.children[1];
      expect(innerDescribe.children.length, equals(1));
      expect(innerDescribe.children[0].name, equals("inner it"));
    });

    group("[expect]", (){
      test("creates an Expect object", (){
        final e = guinness.expect("actual");

        expect(e.actual, equals("actual"));
      });

      test("executes the given matcher", (){
        expect((){
          guinness.expect(true, isFalse);
        }, throws);
      });
    });
  });
}
