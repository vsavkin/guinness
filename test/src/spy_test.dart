part of guinness_test;


testSpy(){
  group("[spy]", (){
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