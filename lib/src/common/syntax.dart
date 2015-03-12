part of guinness;

void beforeEach(Function fn, {int priority:0}) =>
    guinness._context.addBeforeEach(fn, priority: priority);

void afterEach(Function fn, {int priority:0}) =>
    guinness._context.addAfterEach(fn, priority: priority);

void it(name, [Function fn]) =>
    guinness._context.addIt(name.toString(), fn, excluded: false, exclusive: false);

void xit(name, [Function fn]) =>
    guinness._context.addIt(name.toString(), fn, excluded: true, exclusive: false);

void iit(name, [Function fn]) =>
    guinness._context.addIt(name.toString(), fn, excluded: false, exclusive: true);

void fit(name, [Function fn]) => iit(name, fn);

void describe(name, [Function fn]) =>
    guinness._context.addDescribe(name.toString(), fn, excluded: false, exclusive: false);

void xdescribe(name, [Function fn]) =>
    guinness._context.addDescribe(name.toString(), fn, excluded: true, exclusive: false);

void ddescribe(name, [Function fn]) =>
    guinness._context.addDescribe(name.toString(), fn, excluded: false, exclusive: true);

void fdescribe(name, [Function fn]) => ddescribe(name, fn);

Expect expect(actual, [matcher]) {
  final expect = new Expect(actual);
  if (matcher != null) expect.to(matcher);
  return expect;
}
