# Next Version

- Update the list of contributors
- Add a `toBeA(type)` matcher
- Add a `toThrowWith({type, message})` matcher
- Deprecate the `toThrow()` matcher (The API will change to conform with `toThrowWith()`)

# v0.1.4 (2014-05-20)

- License change

# v0.1.3 (2014-05-11)

- Add support for async `beforeEach`, `afterEach`, and `it` blocks.
- Add stats module. To enable: `guinness.showStats = true;`.
- Fix: `ddescribe` does not work when using the unittest backend.

# v0.1.2 (2014-05-03)

- Refactor the unittest backend.
- Add more tests for the unittest backend.

# v0.1.1 (2014-05-02)

- Fix type warnings.

# v0.1.0 (2014-05-02)

- Add an optional second argument to `expect` to make the unitest-to-guinness transition easier.
- Add `Expect#to` to run custom matchers.
- Change `spy` to match the Dart conventions, and enable handling named parameters in the future.
- Change the unittest backend to mimic Jasmine semantics (an exclusive `it` takes precedence).
- Rename `runTests` into `runSpecs`.
- Implement auto initialization, so there is no need to call `initSpec`.
- Split the library into the vm and browser versions.
- Implement new matchers.

#v0.0.1 (2014-04-24)

Initial release.

- Initial implementation of the Jasmine syntax (describe, it, beforeEach, afterEach).
- Initial implementation of matchers.
- Initial implementation of the main configuration object.

