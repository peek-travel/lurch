# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased][]

## [0.3.0][] - 2018-05-31
### Fixed
-   Query parameters like `"foo[0][bar]=one&foo[1][bar]=two"` being turned into `"foo[][bar]=one&foo[][bar]=two"`

## [0.2.0][] - 2017-11-04
### Fixed
-   Better error handling; server response status code is now always included in the exception message.
-   Calling `fetch` on an already loaded collection will just return itself now instead of raising a `NoMethodError`

## 0.1.0 - 2017-10-30
### Initial public release

[Unreleased]: https://github.com/peek-travel/lurch/compare/0.3.0...HEAD
[0.3.0]: https://github.com/peek-travel/lurch/compare/0.2.0...0.3.0
[0.2.0]: https://github.com/peek-travel/lurch/compare/0.1.0...0.2.0
