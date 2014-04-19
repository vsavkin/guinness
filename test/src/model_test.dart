part of jasmine_syntax_test;

class DummyContext implements jasmine.Context {
  withDescribe(jasmine.Describe describe,Function definition){
  }
}

testModel(){
  final context = new DummyContext();
  final noop = (){};

  group("[model]", (){
    group("[It]", (){
      test("returns all before each functions", (){
        final outer = new jasmine.Describe("outer", null, context, noop);
        final outerBeforeEach = new jasmine.BeforeEach(noop, priority: 0);
        outer.addBeforeEach(outerBeforeEach);

        final inner = new jasmine.Describe("inner", outer, context, noop);
        final innerBeforeEach = new jasmine.BeforeEach(noop, priority: 0);
        inner.addBeforeEach(innerBeforeEach);

        final it = new jasmine.It("", inner, (){});

        expect(it.beforeEachFns, equals([outerBeforeEach, innerBeforeEach]));
      });

      test("returns all after each functions", (){
        final outer = new jasmine.Describe("outer", null, context, noop);
        final outerAfterEach = new jasmine.AfterEach(noop, priority: 0);
        outer.addAfterEach(outerAfterEach);

        final inner = new jasmine.Describe("inner", outer, context, noop);
        final innerAfterEach = new jasmine.AfterEach(noop, priority: 0);
        inner.addAfterEach(innerAfterEach);

        final it = new jasmine.It("", inner, (){});

        expect(it.afterEachFns, equals([innerAfterEach, outerAfterEach]));
      });

      test("sorts all beforeEach fns by priority", (){
        final describe = new jasmine.Describe("describe", null, context, noop);
        final beforeEach1 = new jasmine.BeforeEach(noop, priority: 0);
        final beforeEach2 = new jasmine.BeforeEach(noop, priority: 1);
        describe.addBeforeEach(beforeEach1);
        describe.addBeforeEach(beforeEach2);

        final it = new jasmine.It("", describe, (){});

        expect(it.beforeEachFns, equals([beforeEach2, beforeEach1]));
      });

      test("sorts all afterEach fns by priority", (){
        final describe = new jasmine.Describe("describe", null, context, noop);
        final afterEach1 = new jasmine.AfterEach(noop, priority: 0);
        final afterEach2 = new jasmine.AfterEach(noop, priority: 1);
        describe.addAfterEach(afterEach1);
        describe.addAfterEach(afterEach2);

        final it = new jasmine.It("", describe, (){});

        expect(it.afterEachFns, equals([afterEach2, afterEach1]));
      });
    });
  });
}