---
name: wording-standards
description: |
  Rules for comments, doc comments, file headers, Markdown documents, and
  translation catalogs. Forbids metaphor, simile, idiom, personification, long
  file headers, and balanced contrast. Use when writing or reviewing comments,
  documentation, interface text, or translations.
---

# Wording standards

Rules for comments, doc comments, file headers, the Markdown documents, and the
translation catalogs. They apply to every file in the repository.

## State the mechanism

A comment states what the code does and why. It does not compare the code to
something else, and it does not give a non-living thing human abilities.

Metaphor, simile, idiom, and personification are forbidden. So are the words
that carry them.

| Write this | Not this |
| --- | --- |
| every record goes into the column with the smallest height | the masonry is filled the way water finds its level |
| it uses the same shape as `enrich.command` | it is the same seam as `enrich.command` |
| each fetched page yields more links to fetch | the beginning of a scraping treadmill |
| the record is in the trash | the record sits in the trash |
| the name of the file it is defined in | the name of the file it lives in |
| the json gives the rule's name | the json says what to call it |
| the reader and the writer use the same table | the reader and the writer agree |
| the report counts how many were read | the report says how many were looked at |
| the panel displays the field's reading | the interface can say how the field was read |
| a capability implemented twice lets the surfaces contradict each other | the failure this module guards against |
| this returns an error instead of the whole query | this refuses one rather than answering with the whole query |
| both formats are in use | both are alive |
| a format that cannot express a tag rule | a promise that cannot be kept |
| the address it redirects to | the address it lands on |
| once MCP is built | once MCP lands |
| the tools that call a local server | the tools that speak to a local server |
| the pictures arrive | the pictures land |
| two programs should never contend for the same port | two programs should never argue over a port |
| the file carries a marker | the file says so |
| the list shows how many were drawn | the list says how many were drawn |
| the window records where the library is | a file somewhere says where the library is |

Words that must not appear in a comment: `load-bearing`, `seam`, `sits`,
`under the eye`, `treadmill`, `alive`, `promise`, `handshake`, `dance`,
`journey`, `story`, `narrative`, `speak`, `land`.

A word that names a real object is allowed. `surface` names the four ways a
program answers, and `digest` names a hash. Both are literal there.

## Keep the subject a thing that can act

Speech and thought verbs need a person or a program as the subject. A rule, a
json file, a report, a row, a list, and a table do not say, tell, know,
understand, agree, remember, forget, decide, refuse, want, expect, see, hear, or
feel. A value does not land, speak, argue, or wish.

- `the report counts how many were read`, not `the report says how many were
  looked at`
- `the row gives how many were drawn`, not `the row says how many were drawn`
- `the script reads facts.host and returns its value`, not `the script reads
  facts.host says what it means`
- `a planner that has nothing to do returns an empty answer`, not `a planner
  with nothing to do says so`
- `the plan treats it as already where it belongs`, not `plan sees it as
  already where it belongs`
- `the address it redirects to`, not `the address it lands on`
- `which language to use`, not `which language to speak`

`needs` and `requires` describe a requirement of the code, and are allowed
sparingly. Prefer naming the caller: `the caller must supply a body`, not `the
body is needed`.

Phrasal verbs that describe a person's movement or transfer are removed from an
inanimate subject: `picks up`, `hands over`, `hands back`, `falls back`, `ends
up`, `comes back`, `turns out`, `shows up`, `leads`, `meets`, `grows`, `dies`,
`survives`, `waits`, `walks`, `stands for`, `carries on`, `carries out`.

- `the watcher reads the files`, not `the watcher picks files up`
- `the rows imported`, not `the rows carried over`
- `the address it redirects to`, not `the address it leads to`
- `the default is used`, not `it falls back to the default`
- `the records that resolve to the same address`, not `the records that end up at
  the same address`
- `a shape the engine adds`, not `a shape the engine grows`
- `a process that ended`, not `a process that died`
- `the token persists`, not `the token survives`
- `the field delays before it runs the query`, not `the field waits`
- `the filter scans the tag names`, not `the filter walks the tag names`
- `the records are returned`, not `the records come back`
- `the format a name refers to`, not `the format a name stands for`
- `built, it is small`, not `built, it turns out to be small`
- `a typo appears as no results`, not `a typo shows up as no results`
- `the script receives the values`, not `the script is handed the values`
- `rules given to a test`, not `rules handed to a test`
- `the reader is given a path`, not `the reader is handed a path`

## No balanced contrast

A sentence does not pair a statement with its negation for emphasis. Chinese and
English both have the shape: `不是……而是`, `要……而不要`, `X, not Y`, `not X but
Y`.

The negation stays when the two sides are different things a reader could confuse.
It is removed when it restates the first side.

- Keep: `The file is HTML, not a line format`: the two formats are different and a
  reader could take one for the other.
- Remove: `Research for a decision, not a plan to build`: the document is research,
  and the negation adds nothing.
- Remove: `A session is a status, not a place, so it is shown here and not in the
  column`: one contrast carries the reason, and the second repeats it.

## No unnecessary pronouns

A comment or an interface string names the thing it means. A pronoun is used only
when the antecedent is in the same sentence and the meaning stays clear.

- `the files a person keeps next to a bookmark belong to that person`, not `the
  files a person keeps next to a bookmark are their business`
- `a client the person already set up`, not `a client they already set up`
- `the remaining lines are counted`, not `those lines are counted`
- `an ISO date sorts the way it reads`, not `those sort the way they read`
- `the rows are written as read`, not `the rows are written as they were read`
- `Nothing listens until the person turns it on`, not `Nothing listens until
  they do`

`these` and `those` need a noun: `the following conditions`, not `these
conditions`; `the capture rules`, not `those rules`.

First person is removed: `this program's own shape`, not `our own shape`;
`a file this program wrote`, not `a file we wrote`.

## File headers

A file header states the responsibility of the file in one short paragraph of
at most eight lines. A `text` code block that shows the on-disk layout does not
count toward the limit.

Reasoning about a past design, a rejected alternative, or a comparison with
another project belongs in the project's design document, not in a file header.
The header may point at that document.

Do not open with a narrative preamble. Forbidden openings include `This file
contains`, `This module is responsible for`, and a retelling of the file's
functions in prose.

## Comments explain why

A comment states a reason, a constraint, or a fact that the code cannot show. A
comment that repeats the line below it is removed.

- Keep: `// Six hops is enough for the longest chain a person meets.`
- Remove: `// Loop over the records.`

A doc comment on an obvious field is removed. `pub url: String` needs no
comment. A field whose meaning is not obvious from its name and type gets one
line.

## Ratio

Comments stay under half of the lines in a file, counting a doc comment block
as its own lines. A file that crosses this line needs shorter comments, not
fewer explanations: move the reasoning into the project's design document.
