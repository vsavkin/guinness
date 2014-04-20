part of jasmine_test;

testSyntax(){
  group("[syntax]", (){
    var context;

    setUp((){
      context = new jasmine.Context();
      jasmine.jasmine.resetContext(context);
    });

    group("[describe]", (){
      test("adds a describe to the current describe block", (){
        jasmine.describe("new describe", (){});

        final actualDescribe = context.suite.children.first;

        expect(actualDescribe.name, equals("new describe"));
      });
    });

    group("[xdescribe]", (){
      test("adds a describe to the current describe block with excluded set to true", (){
        jasmine.xdescribe("new xdescribe", (){});

        final actualDescribe = context.suite.children.first;

        expect(actualDescribe.name, equals("new xdescribe"));
        expect(actualDescribe.excluded, isTrue);
      });
    });

    group("[ddescribe]", (){
      test("adds a describe to the current describe block with exclusive set to true", (){
        jasmine.ddescribe("new ddescribe", (){});

        final actualDescribe = context.suite.children.first;

        expect(actualDescribe.name, equals("DDESCRIBE: new ddescribe"));
        expect(actualDescribe.exclusive, isTrue);
      });
    });

    group("[it]", (){
      test("adds an `it` to the current describe block", (){
        jasmine.it("new it", (){});

        final actualIt = context.suite.children.first;

        expect(actualIt.name, equals("new it"));
        expect(actualIt.excluded, isFalse);
        expect(actualIt.exclusive, isFalse);
      });
    });

    group("[xit]", (){
      test("adds an `it` to the current describe block with excluded set to true", (){
        jasmine.xit("new xit", (){});

        final actualIt = context.suite.children.first;

        expect(actualIt.name, equals("new xit"));
        expect(actualIt.excluded, isTrue);
      });
    });

    group("[iit]", (){
      test("adds an `it` to the current describe block with exclusive set to true", (){
        jasmine.iit("new iit", (){});

        final actualIt = context.suite.children.first;

        expect(actualIt.name, equals("new iit"));
        expect(actualIt.exclusive, isTrue);
      });
    });

    group("[beforeEach]", (){
      test("adds a before each fn to the current describe block", (){
        jasmine.beforeEach((){});

        expect(context.suite.beforeEachFns.length, equals(1));
        expect(context.suite.beforeEachFns[0].priority, equals(0));
      });

      test("supports different priorities", (){
        jasmine.beforeEach((){}, priority: 2);

        expect(context.suite.beforeEachFns[0].priority, equals(2));
      });
    });

    group("[afterEach]", (){
      test("adds a after each fn to the current describe block", (){
        jasmine.afterEach((){});

        expect(context.suite.afterEachFns.length, equals(1));
        expect(context.suite.afterEachFns[0].priority, equals(0));
      });

      test("supports different priorities", (){
        jasmine.afterEach((){}, priority: 2);

        expect(context.suite.afterEachFns[0].priority, equals(2));
      });
    });

    test("handles nested describes and its", (){
      jasmine.describe("outer describe", (){
        jasmine.it("outer it", (){});
        jasmine.describe("inner describe", (){
          jasmine.it("inner it", (){});
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
  });
}