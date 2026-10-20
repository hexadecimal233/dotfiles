---
name: responsible-ai-contribution
description: Use when writing, modifying, or reviewing code with an AI agent, to catch the agent's typical anti-patterns (eagerness, laziness, uncertainty, bloat) before submission and ensure the final submitted code is human-owned and human-reviewed.
---

# Contributing Responsibly with AI

## General Principle

Use whatever agent and whatever methodology you like—but **you** are responsible for the final code. Before submitting, you must have reviewed it yourself in full. Submissions that obviously skip this step should be rejected.

There is no need to declare that you used AI, unless project policy explicitly requires disclosure.

---

## Four Agent Anti-Patterns to Watch For

### 1. Eagerness: Writing Code Before Thinking

Agents tend to jump straight to writing code. To counter this:

- Explain the architecture you want first, based on **your own understanding**, before letting it implement;
- Or have the agent explore the code and suggest approaches first, then choose one and implement;
- If the first implementation does not look quite right, **start over** and use what you learned to do better next time, rather than patching the wrong foundation.

### 2. Laziness: Making Its Own Job Easy

Agents will take the easiest path:

- Writing trivial tests;
- Making types wide or optional just to keep the compiler quiet;
- Catching exceptions and only logging them instead of actually handling errors;
- Copying local patterns whether appropriate or not.

**Push back**: require accurate types, meaningful tests, and real error handling.

### 3. Uncertainty: Claiming to Understand When It Does Not

Agents will declare "I see the issue now clearly," but often they do not. Watch whether they are flailing. Telltale signs:

- The agent starts listing the number of ways it "fixed" an issue;
- The agent starts writing overly defensive code.

If you see the agent flailing, **call it on it**—or just start over.

### 4. Bloat: Piling Up Redundant Content

Agents like to insert redundant material:

- Redundant comments—worse, comments about **the change at hand** rather than **the resulting code**;
- Loads of tests that do not really test anything; even when they do, they test **the implementation** rather than **the intention**;
- Logging everything, just in case.

Remove these. Comments should explain the code itself, tests should assert intention, and logs should appear only where needed.

---

## Pre-Submission Checklist

- [ ] I have personally read the entire diff in full
- [ ] Architecture was agreed on before implementation, rather than jumping straight into code
- [ ] Tests assert **intention**, not implementation details
- [ ] Types are accurate and have not been widened or made optional
- [ ] Errors are handled, not merely logged
- [ ] Comments explain the final code, not the change at hand
- [ ] There are no unnecessary logs, defensive filler, or redundant content