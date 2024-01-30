# Alethe Classic in AletheLF

Alethe proofs can be expressed as AletheLF proofs.  The signature collects the
Alethe proof rules.  To avoid confusion, this README refers to Alethe as
"Alethe Classic".

An Alethe Classic consumer should be able to use the AltheLF proofs, by only
changing its parser.

## Changes

* Every rule has at least one argument.  This argument is the conclusion of the
  rule.  This argument is always the first argument. If a rule has further
  arguments, these come afterwards.
* `cl` is now `@cl` to avoid name clashes.
* `@cl` cannot be used without arguments.  To write `(cl)`, AletheLF uses the
  term `false`.  Hence, a the simple `false` term should be parsed as the empty
  clause, and `@cl false` is the clause containing the literal `false`.
* Sharing doesn't use `! .. :named`, but instead uses `define` statements.
* Since AletheLF doesn't support overloading, arithmetic negation uses
  the operator `u-`.

## Contexts

Alethe Classic has a notion of contexts used to reason about binders.  Contexts
are lists of variable assignments and shadowings (self assignments). In AletheLF
a context is represented as a conjunction of equalities `= x t` where `x` is a
variable and `t` a term.

Since context are scoped, we use AletheLF's context mechanism.  The extended
context become assumptions of the scope and premises of steps that use contexts.
Hence, the equivalent to an `anchor` is an `assume-push`.  The
context-manipulating rules are rules with `:assumption` that check that the
assumption is the appropriately extended context.

