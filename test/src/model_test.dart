part of guinness_test;

class DummyContext implements guinness.Context {
  withDescribe(guinness.Describe describe,Function definition){
  }
}

testModel(){
  final context = new DummyContext();
  final noop = (){};

  group("[model]", (){
    group("[It]", (){
      test("returns all before each functions", (){
        final outer = new guinness.Describe("outer", null, context, noop);
        final outerBeforeEach = new guinness.BeforeEach(noop, priority: 0);
        outer.addBeforeEach(outerBeforeEach);

        final inner = new guinness.Describe("inner", outer, context, noop);
        final innerBeforeEach = new guinness.BeforeEach(noop, priority: 0);
        inner.addBeforeEach(innerBeforeEach);

        final it = new guinness.It("", inner, (){});

        expect(it.beforeEachFns, equals([outerBeforeEach, innerBeforeEach]));
      });

      test("returns all after each functions", (){
        final outer = new guinness.Describe("outer", null, context, noop);
        final outerAfterEach = new guinness.AfterEach(noop, priority: 0);
        outer.addAfterEach(outerAfterEach);

        final inner = new guinness.Describe("inner", outer, context, noop);
        final innerAfterEach = new guinness.AfterEach(noop, priority: 0);
        inner.addAfterEach(innerAfterEach);

        final it = new guinness.It("", inner, (){});

        expect(it.afterEachFns, equals([innerAfterEach, outerAfterEach]));
      });

      test("sorts all beforeEach fns by priority", (){
        final describe = new guinness.Describe("describe", null, context, noop);
        final beforeEach1 = new guinness.BeforeEach(noop, priority: 0);
        final beforeEach2 = new guinness.BeforeEach(noop, priority: 1);
        describe.addBeforeEach(beforeEach1);
        describe.addBeforeEach(beforeEach2);

        final it = new guinness.It("", describe, (){});

        expect(it.beforeEachFns, equals([beforeEach2, beforeEach1]));
      });

      test("sorts all afterEach fns by priority", (){
        final describe = new guinness.Describe("describe", null, context, noop);
        final afterEach1 = new guinness.AfterEach(noop, priority: 0);
        final afterEach2 = new guinness.AfterEach(noop, priority: 1);
        describe.addAfterEach(afterEach1);
        describe.addAfterEach(afterEach2);

        final it = new guinness.It("", describe, (){});

        expect(it.afterEachFns, equals([afterEach2, afterEach1]));
      });
    });
  });
}