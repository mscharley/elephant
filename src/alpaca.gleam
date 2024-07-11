//// Alpaca is used to persist the results of a function call indefinitely.
////
//// ## Usage
////
//// Alpaca is a write-once, read-many cache designed to be used for caching deterministic values. Good examples
//// of things to use this for are things like regex compilation and lookup tables.
////
//// ## Limitations
////
//// * There is intentionally no way to flush the cache and any data stored in the cache is stored in memory in
////   a way that will never be garbage collected. Updating or removing cache elements would trigger a global
////   GC pass and hence would be a very expensive operation.
////
//// * If you are using alpaca in a library then it is recommended to stick to one big cache for your library
////   wherever possible. The [`persistent_term`](https://www.erlang.org/doc/apps/erts/persistent_term.html)
////   package used to facilitate the cache on the Erlang target gets slower the more individual terms are
////   stored. Hence, a single large object stored in a single term and destructured in Gleam is the preferred
////   approach as much as reasonable.
////
//// * Erlang has a 1GB limit on storage in this cache by default. This is [configurable when starting an application](https://www.erlang.org/doc/apps/erts/persistent_term.html#module-storing-huge-persistent-terms),
////   however beware of this limit when using this in a library. Caching large amounts of data in alpaca is
////   probably the wrong solution.

/// Persist the result of a callback.
///
/// The generator function is expected to be deterministic and pure. Your generator function will be called
/// at least once, but may be called more than once due to race conditions during the initial filling of
/// the cache. After the cache is filled, your generator function will never be called again. If your generator
/// produces side effects then those side effects will be extremely unreliable.
///
/// ## Examples
///
/// ```gleam
/// pub type RegexCache {
///   RegexCache(greeting: regex.Regex, name: regex.Regex)
/// }
///
/// fn regexes() -> RegexCache {
///   use <- alpaca.persist()
///   RegexCache(regex.from_string("^\\w+"), regex.from_string("\\w+$"))
/// }
/// ```
@external(erlang, "alpaca_ffi", "persist")
@external(javascript, "./alpaca_ffi.mjs", "persist")
pub fn persist(generator: fn() -> a) -> a
