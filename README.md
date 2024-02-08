# Alethe Classic in AletheLF

Alethe proofs can be expressed as AletheLF proofs.  The signature collects
the Alethe proof rules.  To avoid confusion, this README refers to Alethe
as "Alethe Classic".

An Alethe Classic consumer should be able to use the AltheLF proofs, by only
changing its parser.

## Changes

* Every rule has at least one argument.  This argument is the conclusion
  of the rule.  This argument is always the first argument. If a rule has
  further arguments, these come afterwards.
* `cl` is now `@cl` to avoid name clashes.
* `@cl` cannot be used without arguments.  To write `(cl)`, AletheLF
  uses the term `false`.  Hence, a the simple `false` term should be parsed
  as the empty clause, and `@cl false` is the clause containing the literal
  `false`.
* Sharing doesn't use `! .. :named`, but instead uses `define` statements.
* Since AletheLF doesn't support overloading, arithmetic negation uses
  the operator `u-`.
* Since AletheLF doesn't support `let` properly, `let` must be printed
  using a special lambda.  The a term `(let ((x t1) (y t2)) t3)`
  becomes `(_ (_ (@let ((x S1) (y S2)) t3) t1) t2)`.
  Furthermore, the rule `let` is renamed to `let_elim`.

## Contexts

Alethe Classic has a notion of contexts used to reason about binders.
Contexts are lists of variable assignments and shadowings (self
assignments). In AletheLF a context is represented as a conjunction of
equalities `= x t` where `x` is a variable and `t` a term.

Free variables in AletheLF are limited.  It is not possible to have two
free variables with the same name, but different sorts.  However, `bind`
steps on different terms can introduce such free variables into the proof.
To handle this, we introduce `lambda` binders to avoid free variables
entirely.

Since context are scoped, we use AletheLF's scope push/pop mechanism.
The extended contexts become assumptions of the scope and premises
of steps that use contexts.  Hence, the equivalent to an `anchor`
is an `assume-push`.  The context-manipulating rules are rules with
an `:assumption` attribute that check that the assumption is the
appropriately extended context.

To see an example for Alethe contexts have a look at the `space_ex4`
example.  This is Example 4 from the Alethe specifications.  The `examples`
folder contains both the original Alethe proof, and the proof embedded in
AletheLF.
