part of guinness;

class Expect {
  final actual;
  Expect(this.actual);

  NotExpect get not => new NotExpect(actual);

  void to(matcher) => _m.expect(actual, matcher);
  void toEqual(expected) => _m.toEqual(actual, expected);
  void toContain(expected) => _m.toContain(actual, expected);
  void toBe(expected) => _m.toBe(actual, expected);
  void toBeA(expected) => _m.toBeA(actual, expected);
  @Deprecated("toThrow() API is going to change to conform with toThrowWith()")
  void toThrow([message]) => _m.toThrow(actual, message);
  void toThrowWith({Type type, Pattern message}) => _m.toThrowWith(actual, type: type, message: message);
  void toBeFalsy() => _m.toBeFalsy(actual);
  void toBeTruthy() => _m.toBeTruthy(actual);
  void toBeDefined() => _m.toBeDefined(actual);
  void toBeNull() => _m.toBeNull(actual);
  void toBeNotNull() => _m.toBeNotNull(actual);
  void toHaveBeenCalled() => _m.toHaveBeenCalled(actual);
  void toHaveBeenCalledOnce() => _m.toHaveBeenCalledOnce(actual);
  void toHaveBeenCalledWith([a=_u,b=_u,c=_u,d=_u,e=_u,f=_u]) =>
      _m.toHaveBeenCalledWith(actual, a, b, c, d, e, f);
  void toHaveBeenCalledOnceWith([a=_u,b=_u,c=_u,d=_u,e=_u,f=_u]) =>
      _m.toHaveBeenCalledOnceWith(actual, a, b, c, d, e, f);

  Matchers get _m => guinness.matchers;
}


class NotExpect {
  final actual;
  NotExpect(this.actual);

  void toEqual(expected) => _m.notToEqual(actual, expected);
  void toContain(expected) => _m.notToContain(actual, expected);
  void toBe(expected) => _m.notToBe(actual, expected);
  void toBeA(expected) => _m.notToBeA(actual, expected);
  void toThrow() => _m.toReturnNormally(actual);
  void toBeDefined() => _m.toBeUndefined(actual);
  void toHaveBeenCalled() => _m.notToHaveBeenCalled(actual);
  void toHaveBeenCalledWith([a=_u,b=_u,c=_u,d=_u,e=_u,f=_u]) =>
      _m.notToHaveBeenCalledWith(actual, a, b, c, d, e, f);

  Matchers get _m => guinness.matchers;
}