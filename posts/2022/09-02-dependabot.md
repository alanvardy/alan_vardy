==title==
Keep your Elixir projects up-to-date with Dependabot

==author==
Alan Vardy

==footer==

==description==
Make updates incremental and low-risk through automation

==tags==
elixir,github,dependabot,dependencies

==body==

## Why stay up-to-date?

Staying current can be challenging when there is so much to do daily. Whether critical infrastructure for a million-dollar business or an open-source library you work on on the weekend, it is difficult to find the time to update every little package in your dependency tree. The state of neglect worsens when multiple people are on a project, and the need for updating becomes a tragedy of the commons because when something is everyone's responsibility, it is also no one's.

Eventually, our dependencies might get so out of date that a large, risky, and heroic effort is needed to bring the codebase back into the modern era. Brave developers will have to grind away late at night and, in severe cases, miss deadlines because the problem was allowed to metastasize.

An excellent solution to this problem is using automation to manage daily incremental updates. This approach ensures that every deployment is as low-risk as possible.

## Enter Dependabot

Dependabot started as a private outfit but has since been acquired by Microsoft. Its primary purpose is to open PRs that incrementally update dependencies in supported languages on GitHub (also owned by Microsoft).

Once Dependabot is set up, we developers can rely on it to open PRs and tirelessly champion the update process with a single-minded purpose no biological lifeform could ever hope to match. That's somewhat useful, in my opinion :)

![A dependabot pull request](dependabot.png "A dependabot pull request")

## What's the catch?

There are 4 requirements. Three are set in stone; the fourth is a bit looser.

### 1. GitHub

This one is pretty self-explanatory: we need to use GitHub. Microsoft is seeking to maximize the value of its product.

### 2. A good test suite

We need a trustworthy test suite that will frequently catch dependency regressions.

If we cannot perform minor updates without extensive manual testing, it may be best to prioritize work on the test suite before pursuing Dependabot further. Without "dependable" automated testing, Dependabot would only dramatically increase a team's workload as the PR's come in.

### 3. Effective monitoring

It would be best to have good production monitoring to detect dependency issues that slip past the test suite. Once in a while regressions do make it into production despite our best efforts, and we will need that second line of defense. For example, we will want to know if that one endpoint suddenly stops serving requests correctly.

### 4. Trunk-based development (probably)

Using trunk-based development will greatly speed the frequency and speed of updates reaching production. Trunk-based development centers around merging into the main branch frequently and minimizing long-lived feature branches. Ideally, all updates merged in will end up in production, one by one, as soon as possible. Then, you can revert the last change and avert disaster if something goes wrong. But, of course, if that doesn't happen, you will end up with high-risk deploys containing multiple dependency updates AND business logic changes. And it won't be long before the former gets delayed to benefit the latter, and we end up back where we started.

## Adding Dependabot

Add the following to `.github/dependabot.yml` in your repository.

```yaml
version: 2
 updates:
  - package-ecosystem: "mix"
  directory: "/"
  open-pull-requests-limit: 1
  reviewers:
  - "thenameofyourteam"
  schedule:
  interval: "daily"
```

This will open one pull request at a time, daily, which is more than enough to keep a repository up to date. Make sure to add your team's name so that Dependabot can rotate through the team members for the reviews.

[Read more about configuring Dependabot](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuring-dependabot-version-updates)

## Handling the PRs as they come in

So Dependabot opens up the first PR. Yay! Let's talk about the next steps.

### 1. Read the changelog (and maybe the git diff)

Dependabot will conveniently attach the changelog to the PR. Read it thoroughly and follow up on any items that seem squirrelly. For example, is the changelog low effort? Is it missing entirely? Then look at the git diff as well.

### 2. Evaluate the library

Decide how much you can trust the maintainer of the library in question and their processes. Do they test? How is their test coverage? Do they do pull requests or just YOLO to main? Does their commit history look like they were drunk texting? A quick overview of the codebase might tell you a story.

### 3. Tag in an expert

Did someone else write the majority of the code that uses the dependency? Is there a subject matter expert who knows the ins and outs of that API? Bring them in as a second set of eyes.

### 4. Consider YOUR tests and monitoring

If there is a regression in the library, would it be detected before you get a bug report from your end users? Would you like to take this time to write one last unit test? Add another metric? Or make an offering at the shrine of a favoured deity? 

### 5. Deploy and monitor as soon as possible

If there is an undetected problem with the updated dependency and it remains undeployed, all you have done is set a trap for the next person who pushes to production. Get it out there, monitor it, and then move on to the next thing! Of course, once in a while, something will break despite your best efforts, but at least you will know which update did it and be ready to roll back.
