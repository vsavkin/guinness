part of jasmine;

class Expect {
  final Matchers matchers;
  final actual;
  Expect(this.actual, this.matchers);

  toEqual(expected) => matchers.toEqual(actual, expected);
  toContain(expected) => matchers.toContain(actual, expected);
  toBe(expected) => matchers.toBe(actual, expected);
  toThrow([exception]) => matchers.toThrow(actual, exception);
  toBeFalsy() => matchers.toBeFalsy(actual);
  toBeTruthy() => matchers.toBeTruthy(actual);
  toBeDefined() => matchers.toBeDefined(actual);
  toBeNull() => matchers.toBeNull(actual);
  toBeNotNull() => matchers.toBeNotNull(actual);
  toHaveHtml(expected) => matchers.toHaveHtml(actual, expected);
  toHaveText(expected) => matchers.toHaveText(actual, expected);
  toHaveBeenCalled() => matchers.toHaveBeenCalled(actual);
  toHaveBeenCalledOnce() => matchers.toHaveBeenCalledOnce(actual);
  toHaveBeenCalledWith([a=_u,b=_u,c=_u,d=_u,e=_u,f=_u]) => matchers.toHaveBeenCalledWith(actual, a, b, c, d, e, f);
  toHaveBeenCalledOnceWith([a=_u,b=_u,c=_u,d=_u,e=_u,f=_u]) => matchers.toHaveBeenCalledOnceWith(actual, a, b, c, d, e, f);
  toHaveClass(cls) => matchers.toHaveClass(actual, cls);
  toHaveAttribute(name, [value = null]) => matchers.toHaveAttribute(actual, name, value);
}