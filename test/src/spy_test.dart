part of guinness_test;

class _SpyObject extends guinness.SpyObject {}

testSpy(){
  group("[SpyObject]", (){
    test("records all the calls", () {
      final obj = new _SpyObject();
      obj.someFunc(3, named: "named");

      expect(obj.spy("someFunc").count, equals(1));
      expect(obj.spy("someFunc").mostRecentCall.positionalArguments, equals([3]));
      expect(obj.spy("someFunc").mostRecentCall.namedArguments, equals({"named": "named"}));
    });

    test("returns a new spy function when no calls", () {
      final obj = new _SpyObject();
      expect(obj.spy("someFunc").count, equals(0));
    });

    test("handles getters", () {
      final obj = new _SpyObject();
      obj.someFunc;
      expect(obj.spy("get:someFunc").count, equals(1));
    });

    test("handles setters", () {
      final obj = new _SpyObject();
      obj.someFunc = 10;
      expect(obj.spy("set:someFunc").count, equals(1));
      expect(obj.spy("set:someFunc").mostRecentCall.positionalArguments, equals([10]));
    });

    test("stubs function calls", () {
      final obj = new _SpyObject();
      obj.spy("someFunc").andCallFake((a,b) => a + b);

      expect(obj.someFunc(1,2), equals(3));
      expect(obj.spy("someFunc").count, equals(1));
    });
  });

  group("[SpyFunction]", (){
    guinness.SpyFunction s;

    setUp((){
      s = new guinness.SpyFunction("spy");
    });

    test("records the number of calls", (){
      s();
      s(1,2,3);
      s(1,2,3,4,5);

      expect(s.count, equals(3));
    });

    test("records positional arguments", (){
      s(1,2);

      expect(s.mostRecentCall.positionalArguments, equals([1,2]));
    });

    test("records named arguments", (){
      s(named1: 1, named2: 2);

      expect(s.mostRecentCall.namedArguments, equals({"named1": 1, "named2": 2}));
    });

    test("resets invocations", (){
      s(1,2,3);
      s.reset();

      expect(s.count, equals(0));
    });

    group("[mostRecentCall]", (){
      test("returns the most recent call", (){
        s(1,2,3);

        expect(s.mostRecentCall.positionalArguments, equals([1,2,3]));
      });

      test("throws when no recent calls", (){
        expect(() => s.mostRecentCall, throws);
      });
    });

    group("[calls]", (){
      test("returns the list of all calls", (){
        s(1,2,3);

        expect(s.calls.first.positionalArguments, equals([1,2,3]));
      });

      test("returns an empty list when no calls", (){
        expect(s.calls, equals([]));
      });
    });

    group("[andCallFake]", (){
      test("calls the provided function", (){
        s.andCallFake((a,b) => a + b);

        expect(s(100,2), equals(102));
      });
    });

    group("[firstArgsMatch]", (){
      test("retuns false when not calls were made", (){
        expect(s.firstArgsMatch(1,2), isFalse);
      });

      test("retuns false when the args do not match", (){
        s(3,4);
        expect(s.firstArgsMatch(1,2), isFalse);
      });

      test("retuns true when the args match", (){
        s(1,2);
        expect(s.firstArgsMatch(1,2), isTrue);
      });
    });
  });
}