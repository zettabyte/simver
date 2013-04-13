# Simple Version Library

The `simver` gem provides a version number type, `Simver` that follows
[semantic versioning](http://semver.org/) rules:

```ruby
require 'simver'
Simver(1.2) == Simver('1.2.0') # => true
```

The name simver is derived from `sim`ple `ver`sion, because this is a
simple version library. Unlike many other gems in this arena, it doesn't
try to actually _do_ anything, like create rake tasks, version an API,
integrate with your `git` repository, or other shenanigans. What you do
with your `Simver` version objects is up to you.

## Installation

Add this line to your application's Gemfile:

    gem 'simver'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simver

## Usage

To use, simply `require 'simver'` and then you can create and use
`Simver` instances:

```ruby
require 'simver'
x = Simver.new("1.2.3-rc.2+build.1.c92e715d")
y = Simver.new("1.2.3-rc.1+build.3.a8c190f1")
puts "Simver library broken!" if x < y
```

### Creating

You can create a `Simver` using the traditional `.new` method or the
'global' `Simver()` factory method (private `Kernel` module method).
These are the only two ways, by default, to get a `Simver` instance:

```ruby
require 'simver'
x = Simver.new(1.2) # standard Klass::new factory method
y = Simver(1.2)     # 'global' factory method (like Float())
x == y # => true
```

You can additionally opt to 'patch' the core types, giving you a 3rd
option. Namely, it adds a `#to_simver` method on compatible types. See
the 'Patching' section below for more details.

```ruby
require 'simver/patch'
x = 1.2.to_simver
y = Simver(1.2)
x == y # => true
```

Finally, the whole point of a version is to compare it with other
versions or otherwise see if it meets some constraint (which is just a
special case of comparison). `Simver` instances are `Comparable`
according to semantic versioning rules. They can be compared with each
other:

```ruby
require 'simver'
Simver('1.2.0-alpha.0') < Simver(1.2) # => true
```

They can be compared with other, compatible types (strings and simple
numeric types) as long as the `Simver` is the left-hand value:

```ruby
require 'simver'
Simver('1.2.0-alpha.0') < 1.2 # => true
```

And they can be compared with other types, regardless of order if you
'patch' the core types (described in 'Patching' section below):

```ruby
require 'simver/patch'
1.2 > Simver('1.2.0-alpha.0') # => true
```

### Modification?

No! `Simver` instances are immutable objects, much like integers! There
are no mutating methods.

However, there are useful methods for getting new, related values:

```ruby
require 'simver'

# Incrementing versions
v = Simver.new(1.0) # => <Simver: "1.0.0">
v.succ              # => <Simver: "1.0.1">
v.next              # => <Simver: "1.0.1">
v.next(:patch)      # => <Simver: "1.0.1">
v.next(:minor)      # => <Simver: "1.1.0">
v.next(:major)      # => <Simver: "2.0.0">
v.next_patch        # => <Simver: "1.0.1">
v.next_minor        # => <Simver: "1.1.0">
v.next_major        # => <Simver: "2.0.0">

# Incrementing with pre-release and/or build versions
v.next(:patch, pre: 'beta.1')   # => <Simver: "1.0.1-beta.1">
v.next_patch(build: 'build.12') # => <Simver: "1.0.1


v.prev                  # => Simver::IllegalTransformation: 'patch' version already zero (cannot be negative)
v.prev(:minor)          # => Simver::IllegalTransformation: 'minor' version already zero (cannot be negative)
v.prev(:major)          # => <Simver: "0.0.0">

v = Simver.new('2.3.4') # => <Simver: "2.3.4">
v.prev                  # => <Simver: "2.3.3">
v.prev(:minor)          # => <Simver: "2.2.0">
v.prev(:major)          # => <Simver: "1.0.0">


```

### Patching

By default, simver only provides the `Simver` class and the `Simver()`
'global' factory method (adding it to the `Kernel` module as a private
instance method, much like `Integer()` and `Float()`). It doesn't
otherwise do any further monkey-patching or modification of core types.

However, you can opt to `require 'simver/patch'` instead of or in
addition to the default `require 'simver'`. Doing so makes simver do
more monkey-patching to provide the following:

1. Makes comparisons with compatible types transitive, meaning the core,
   compatible type can be on the left side of the comparison operator.
2. Adds the `#to_simver` conversion method to the compatible types.
3. By allowing order-indpendent comparison with compatible types, allows
   collections containing `Simver` instances and such compatible types,
   including `nil`, to be sorted (regardless or collection's current
   order).

Examples:

```ruby
require 'simver'
2.0 > Simver('2.0.1') # => ArgumentError: comparison of Float with Simver failed
"1.2.3".to_simver     # => NoMethodError: undefined method `to_simver' for "1.2.3":String
require 'simver/patch'
2.0 > Simver('2.0.1') # => false
"1.2.3".to_simver     # => <Simver: "1.2.3">
```

### Use in Ranges

`Simver` also supports a naive implementation of the `#succ` method so
that instances can be used to define a `Range`. The `#succ` method
simply increments the 'patch' version (removing any and all
'pre-release' or 'build' parts if present). Because of this, any attempt
to use `Enumerable` methods on a `Range` comprised of `Simver` objects
will interate infinitely (well, until memory is exhausted) unless, of
course, you use ruby 2.0's lazy evaluation features and at some point
limit the scope of your iteration.

That said, the point of allowing `Simver`s to be used in `Range`s isn't
for enumation features, but range membership and coverage features.

**WARN:** just consider yourself warned with respect to trying to use
 `Range`s based on `Simver`s for any kind of iteration!

### Compatible Types

`Simver` versions can be contructed from and compared with the following
core types:

1. `Integer` instances (`Fixnum` and `Bignum` instances): the integer is
   taken to be the 'major' version number with the 'minor' and 'patch'
   numbers defaulted to zero (and with no 'pre-release' or 'build'
   part).
2. `Float` (and `BigDecimal` if it's loaded): the whole (integral) part
   of the number is taken to be the 'major' version number and the
   fractional part as the 'minor' version number. The 'patch' number
   defaults to zero and there's no 'pre-release' or 'build' part.
3. `String`: the string is parsed according to the format requirements
   of a semantic version number. The actual parsing logic is described
   below. In order to create a `Simver` with a non-zero 'patch' version
   number or any 'pre-release' and/or 'build' part, you'll need to
   provide a string representation of the version.
4. `Symbol`: the symbol is simply converted to and parsed like a string.
5. `nil`: you cannot create a `Simver` from `nil` but you can compare
   them with `nil`. In comparisons, `nil` is always less-than any
   `Simver` value, even `Simver(0)` (`0.0.0`).

Note that there are issues and contraints for each of these types, when
using them to create a `Simver` or to compare them with one.
Specifically:

- Negative integers or floating-point numbers will raise an exception.
- Some 'minor' version number are impossible to represent using a
  floating-point literal. For example, there's no way to represent
  version `1.10` using anything but a string or symbol. Don't try to use
  floating-point types for any version number where the 'minor' part
  ends in a sequence of one or more zero digits. The only exception, of
  course, is if the fractional part is numerically equal to zero (such
  as `2.0` for example). However, in these cases, you could just use an
  integer anyway.
- Floating-point values where the fractional part, when written alone in
  decimal format, has leading zeros make no sense (`1.01` for example)
  and will raise an exception when used as or compared with a `Simver`.
- Any floating point value that cannot be exactly represented by the
  underlying type (`Float` or possibly `BigDecimal`) may cause the
  'minor' version number to be rounded to an incorrect value. By
  default, the conversion code rounds the fractional part to a maximum
  precision and strips of all tailing zeros (see the point above using
  floating point values for versions whos 'minor' part ends in a zero).
  The maximum precision, in number of decimal digits, is available in
  the `Simver::PRECISION` constant. So, if `Simver::PRECISION` is `10`
  that means the eleventh digit after the decimal point will be used to
  round and set the tenth digit's value.
- Strings (and symbols) being compared with or converted to `Simver`s
  must follow legal semantic versioning format almost exactly. The only
  exceptions are that you may omit the 'patch' part with its separating
  dot it it's zero, and you may omit both the 'patch' _and_ 'minor'
  parts with both of their separaring dots if they're both zero.

### Parsing and Displaying

The semantic versioning specification describes the parts of a version
and the rules regarding their legal values very well. However, version
numbers are often written with some parts omitted for brevity. For
instance, people may refer to version `1` or even `1.0` of a product or
library.

The complete representation for these versions is, of course, `1.0.0`.
However, the parser, as described in the 'Compatible Types' section
above, allows string and symbol representations of version numbers to be
written in the briefer forms `1.0` and even `1`. Integers and floating
point version numbers are, by definition, in this briefer form.

When it comes to displaying a version, the `#inspect` method uses the
following format:

    <Simver: "1.2.0">

The point is that `#inspect` always indicates the type of object, and
displays the values, whether set explicitely or by default, of all the
parts, 'major', 'minor', and 'patch' of the version number. If a
'pre-release' and/or 'build' part is set, it'll be displayed too.

The `#to_s` and `#to_str` methods return the full, canonical string
representation of the `Semver` instance. This basically returns the
same content as that which is between quotes from the string returned by
`#inspect`. So, printing the results of `#to_s` on the same version as
above returns:

    1.2.0

There's another method that returns a string representation of the
`Simver` instance: `#display`. The difference between this and `#to_s`
is that it may omit the 'minor' and/or 'patch' parts. The rule with
`#display` is that you'll get an accurate string representation <em>with
the same level of brevity</em> as was used to instantiate the instance.
So, if you didn't explicitely specify a 'patch' part, then `#display`
will omit it. If you didn't include the 'minor' or 'patch' parts, both
will be omitted from the 'display' as well. In short, it tries to
reflect the version number informally with the same degree of precision
you provided.

Examples:

```ruby
require 'simver'
Simver(1).inspect       # => "<Simver: \"1.0.0\">"
Simver(1).to_s          # => "1.0.0"
Simver(1).display       # => "1"
Simver(1.1).inspect     # => "<Simver: \"1.1.0\">"
Simver(1.1).to_s        # => "1.1.0"
Simver(1.1).display     # => "1.1"
Simver('1.0').inspect   # => "<Simver: \"1.0.0\">"
Simver('1.0').to_s      # => "1.0.0"
Simver('1.0').display   # => "1.0"
Simver('1.0.0').inspect # => "<Simver: \"1.0.0\">"
Simver('1.0.0').to_s    # => "1.0.0"
Simver('1.0.0').display # => "1.0.0"
```

### Ordering

The semantic versioning specification describes how versions compare to
each other. When comparing a `Simver` against a compatible core type,
the core type is first converted to a `Simver` as if passed to the
`Simver()` factory method and the result is then compared. This means
that the same exceptions that may be raised by providing invalid objects
to `Simver()` (or `Simver.new`) can be raised when doing comparisons
with core types.

The only unique thing that you need to know about ordering is that `nil`
can be compared with `Simver` instances. When you do so, `nil` is always
less-than any `Simver` instance. This way, code such as the following
which may want to sort a bunch of versions, some potentially being
illegal, would work:

```ruby
require 'simver'
versions = [1_000_000, -2.3, :'5.6', "0", 0.0, :apple, '1.2.3.4.5', '0.0.1']
puts versions.map { |v| Simver(v) rescue nil }.sort.map(&:inspect)
# outputs: (nils from -2.3, :apple, and '1.2.3.4.5')
nil
nil
nil
<Simver: "0.0.0">
<Simver: "0.0.0">
<Simver: "0.0.1">
<Simver: "5.6.0">
<Simver: "1000000.0.0">
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

