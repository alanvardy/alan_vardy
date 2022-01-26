==title==
3 Bad Arguments Against Writing Tests

==author==
Alan Vardy

==footer==


==description==
Rebuttals to common arguments about writing tests

==tags==
testing

==body==
Are you struggling with that one person who resists writing tests at every turn? 

- A co-worker who does the bare minimum to get a Pull Request approved and scoffs at every suggestion to cover a code pathway with an automated test?
- How about a product manager who insists that there is no time in the budget for automated tests and that you should simply "write the code correctly the first time"?
- A team lead who cries out in dismay that every test written is something that requires maintenance at the expense of getting "real work done"?

This article is for you!

I have felt the pain and misery of working on a codebase with few functioning tests, with people who insist that a test suite is not necessary, even as they ironically devote countless hours to manually testing bugs and regressions.

Maybe this article is for me too!

Without further ado:

![alt text](gears.jpg "Gears")

# "My code is simple and doesn't do much."
To this I feel like the answer is simple: *just write one test*

We should never underestimate our collective abilities to screw up simple things. Humans have fragile squishy brains that are easily distracted and forget things at the drop of a hat. We can easily write code that returns an integer when it should have been a string, or alter a rarely used code pathway months later. Even one test that just checks the return value can be vastly superior to no tests at all.

# "OK, maybe my code is complex, but writing tests takes too long! I can manually test it instead!"

You sure can! When directly comparing the time it takes to manually exercise the code you write, and actually creating the test files, manual testing wins out if the time horizon is short enough!

And that is the only benefit.

Every time the code changes from now on the manual testing will need to be performed again, and again. A teammate less familiar with the code would manually test but not know which parts are important and miss critical issues. Everyone, including future you, will be forced to slowly and painfully exercise every path of every new feature (and every new feature previously written)...

### Until!

One day, a person *who barely knows what your legacy code does* may find themselves forced to painstakingly write tests in order to change that code. Now your code has experienced the worst of both worlds, agonizing manual testing AND the later addition of automated tests under even more difficult circumstances.

# "Sure, maybe writing tests is good in theory, but what about maintaining tests? Every test I write is something added to a parallel codebase that then needs to be maintained!"

I have found that the process of tests "breaking" when code is changed to be rather reassuring, because the tests are reflecting my changes back at me and confirming the difference in functionality between then and now. A well-tested codebase is like a pair programmer keeping track of what I do and asking if I am sure before pushing the code.

Inversely, I have had situations where I have written code that makes such a change that I know there should be test failures, but the suite passes. This feels like motorcycling without a helmet; I am forced to slow down because I know that there is nothing to save me when I go over the handlebars.

In summary:

## The only benefit to not writing tests is the few minutes you save when first writing the code, the drawback is the countless hours lost by both you and your teammates.

![alt text](broken_house.jpg "Gears")
