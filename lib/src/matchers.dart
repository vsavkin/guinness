part of jasmine;

class Expect {
  final Matchers matchers;
  final actual;
  Expect(this.actual, this.matchers);

  toEqual(expected) => matchers.expectToEqual(actual, expected);
}