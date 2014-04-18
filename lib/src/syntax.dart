part of jasmine;

void it(String name, Function callback) =>
    context.currentDescribe.addSpec(name, callback);

void describe(String name, Function callback) =>
    context.currentDescribe.addDescribe(name, callback);

Expect expect(actual) => new Expect(actual, context.matchers);
