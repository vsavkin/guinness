part of guinness;

abstract class SpecVisitor {
  void visitSuite(Suite suite);
  void visitDescribe(Describe describe);
  void visitIt(It it);
}

abstract class Matchers {
  void expect(actual, matcher, {String reason});
  void toEqual(actual, expected);
  void toContain(actual, expected);
  void toBe(actual, expected);
  void toThrow(actual, [exception]);
  void toBeFalsy(actual);
  void toBeTruthy(actual);
  void toBeDefined(actual);
  void toBeNull(actual);
  void toBeNotNull(actual);
  void toHaveHtml(actual, expected);
  void toHaveText(actual, expected);
  void toHaveClass(actual, cls);
  void toHaveAttribute(actual, name, [value]);
  void toHaveBeenCalled(actual);
  void toHaveBeenCalledOnce(actual);
  void toHaveBeenCalledWith(actual, [a,b,c,d,e,f]);
  void toHaveBeenCalledOnceWith(actual, [a,b,c,d,e,f]);
  void notToEqual(actual, expected);
  void notToContain(actual, expected);
  void notToBe(actual, expected);
  void toReturnNormally(actual);
  void toBeUndefined(actual);
  void notToHaveHtml(actual, expected);
  void notToHaveText(actual, expected);
  void notToHaveBeenCalled(actual);
  void notToHaveBeenCalledWith(actual, [a,b,c,d,e,f]);
  void notToHaveClass(actual, cls);
  void notToHaveAttribute(actual, name);
}