# The Alethe Calculus in AletheLF

Proofs using the Alethe calculus can be expressed in the AletheLF
framework.  This repository contains an AletheLF signature for the Alethe
proof rules, and illustrative examples.

Currently, most Alethe users are able to parse Alethe proofs expressed
in the standalone Alethe syntax.  A design goal of this signature is to
help those consumers to transition to parsing AletheLF proofs that use
the Alethe calculus.  Ideally, only some simple changes to the parser
should be necessary.

## Changes

* Every rule has at least one argument.  This argument is the conclusion
  of the rule.  This argument is always the first argument. If a rule has
  further arguments, these come afterwards.
* `cl` is now `@cl` to avoid name clashes.
* `@cl` cannot be used without arguments.  To write `(cl)`, AletheLF
  uses the term `false`.  Hence, a the simple `false` term should be parsed
  as the empty clause, and `@cl false` is the clause containing the literal
  `false`.
* The `assume` commands must already use the `@cl`.  That is,
  `(assume t1 F)`, becomes `(assume t1 (@cl F))`.  However, a clause in an
  `assume` always contains exactly one literal.
* Sharing doesn't use `! .. :named`, but instead uses `define` commands.
* Since AletheLF doesn't support `let` properly, `let` must be printed
  using a special binder.  The a term `(let ((x t1) (y t2)) t3)`
  becomes `(_ (_ (@let ((x S1) (y S2)) t3) t1) t2)`.
  Furthermore, the rule `let` is renamed to `let_elim`.
* The arguments of rules with a flexible number of arguments (e.g.,
  `la_generics`) must be wrapped in an n-ary function.  For example the
  coefficients of `la_generic` can be printed as `(+ c1 c2 ..)`.
* Context handling introduces slightly more complex terms.  See below.

See also `NOTE` comments in the files in the `./signature/` folder.

## Contexts

The Alethe calculus has a notion of contexts used to reason about
binders.  Contexts are lists of variable assignments and shadowings
(self assignments).  An Alethe context corresponds to a substitution
(e.g., `σ`).  Conclusions of steps that work under contexts always have
the form `(@cl (= L R))`. The intended meaning is that `Lσ` is equal to
`R` in the theory.

Free variables in AletheLF are limited.  It is not possible to have
two free variables with the same name, but different sorts.  However,
context-extending rules such as `bind` can introduce such free variables
into the proof.  To solve this, the AletheLF embedding adds additional
`@var`-binders to the left and right side that binds the free variable.
That is, the conclusion `(@cl (L R))` is printed
`(@cl (= (@var ((x1 S1) .. (xn Sn) L) (@var ((y1 S1) .. (yn Sn)) R))))`
where `x1 .. xn` are the free variables of `L` and `y .. yn` are the free
variables of `R`.  An Alethe consumer that is not AletheLF aware should
ignore these `@var` bindings and instead treat `L` and `R` like for the
standalone Alethe syntax. For AletheLF `@var` is similar to lambda,
but while the type of `(lambda ((x S)) x)` is `(-> S S)`, the type of
`(@var ((x S)) x)`.  Obviously, this is only sensible if the `@var`
is used only when an Alethe Classic context is present.

Since context are scoped, we use AletheLF's scope push/pop mechanism.
The extended contexts become assumptions of the scope and premises
of steps that use contexts.  Hence, the equivalent to an `anchor`
is an `assume-push`.  The context-manipulating rules are rules with
an `:assumption` attribute that check that the assumption is the
appropriately extended context.

In AletheLF a context is represented as a conjunction of equalities `= x
T` where `x` is a variable and `T` is a term.  To build a context, we use
the custom binder `@ctx` in AletheLF.  A context extension has the form
`(@ctx ((x1 S1) .. (xn Sn)) (and (= x1 T1) .. (xn Tn) old_ctx))`.
Some `Tn` might be `xn`.  To avoid repeating the old context, the new
context is first defined as a new constant, and then assumed by the
`assume-push`.  To simplify parsing, the `define` must come right before
the `assume-push`.  Furthermore, the constants must be named `ctxN` where
`N` is an increasing counter.  The context assumption must be named
`context`.  Each proof using the Alethe calculus starts with:
```clojure
(define ctx0 () true)
(assume context ctx0)
```

To check that a context was only extended in the
intended way, each rule context-extending rule has an additional premise:
the old context (i.e., the assumption with the name `context`).

To see an example for Alethe contexts have a look at the `space_ex4`
example.  This is Example 4 from the Alethe specifications.  The `examples`
folder contains both the original Alethe proof, and the proof embedded in
AletheLF.
