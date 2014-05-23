part of guinness;

class Expect {
  final actual;
  Expect(this.actual);

  NotExpect get not => new NotExpect(actual);

  to(matcher) => _m.expect(actual, matcher);
  toEqual(expected) => _m.toEqual(actual, expected);
  toContain(expected) => _m.toContain(actual, expected);
  toBe(expected) => _m.toBe(actual, expected);
  toBeA(expected) => _m.toBeA(actual, expected);
  toThrow([exception]) => _m.toThrow(actual, exception);
  toBeFalsy() => _m.toBeFalsy(actual);
  toBeTruthy() => _m.toBeTruthy(actual);
  toBeDefined() => _m.toBeDefined(actual);
  toBeNull() => _m.toBeNull(actual);
  toBeNotNull() => _m.toBeNotNull(actual);
  toHaveBeenCalled() => _m.toHaveBeenCalled(actual);
  toHaveBeenCalledOnce() => _m.toHaveBeenCalledOnce(actual);
  toHaveBeenCalledWith([a=_u,b=_u,c=_u,d=_u,e=_u,f=_u]) => _m.toHaveBeenCalledWith(actual, a, b, c, d, e, f);
  toHaveBeenCalledOnceWith([a=_u,b=_u,c=_u,d=_u,e=_u,f=_u]) => _m.toHaveBeenCalledOnceWith(actual, a, b, c, d, e, f);

  Matchers get _m => guinness.matchers;
}


class NotExpect {
  final actual;
  NotExpect(this.actual);

  toEqual(expected) => _m.notToEqual(actual, expected);
  toContain(expected) => _m.notToContain(actual, expected);
  toBe(expected) => _m.notToBe(actual, expected);
  toBeA(expected) => _m.notToBeA(actual, expected);
  toThrow() => _m.toReturnNormally(actual);
  toBeDefined() => _m.toBeUndefined(actual);
  toHaveBeenCalled() => _m.notToHaveBeenCalled(actual);
  toHaveBeenCalledWith([a=_u,b=_u,c=_u,d=_u,e=_u,f=_u]) => _m.notToHaveBeenCalledWith(actual, a, b, c, d, e, f);

  Matchers get _m => guinness.matchers;
}