==title==
Stay in the flow by stacking your PRs with Graphite

==author==
Alan Vardy

==footer==

==description==
It's hard to keep your pull requests small when you don't know how long you will need to wait for the following review. So stack up pull requests without pain using Graphite.

==tags==
git,github,graphite

==body==

## The problem

There is tension between large and small pull requests.

I like small pull requests; I like them a lot! They are easy to review, bugfix, deploy, and migrate because the changes are much more atomic. They are less likely to conflict with the work of our teammates and are an excellent way to get feedback from your reviewers and production telemetry much earlier. They are commonly accepted as an ideal to aim towards but a hard one to consistently hit.

That is because of reviews. We make a delightful 100-line PR, proudly mark it as ready for review, and then... wait. What can we do in the meantime? Maybe:

1. Context switch and work on something unrelated, or
2. Branch off of the current commit and continue on the next thing (thus risking future merge conflict hell)

![Merge conflict or context switch](merge.png "Merge conflict or context switch")

Ok, and now we have done the next item; what now? Let's do it again. And therefore, by the end of the day, the damage is done. We will either be mentally scattered by too many different tasks or [emotionally shattered by the inevitable rebasing](https://threkk.medium.com/escaping-a-git-merge-hell-e08f37511f37). And all we wanted to do was the right thing.

So, we eventually wise up and start writing vast PRs, because then we can stay in the flow longer, rebase less often, and be blocked waiting on reviews less. Then, of course, we feel ashamed to have abandoned the ideal, but we had no choice, right?

## Enter stacked PRs

Imagine creating multiple branches, where each branch is one commit, and each commit follows the next one. The collection of branches linked together can be called a "stack" and is the result of following option #2 (branch off current commit)

```elixir
branch_three
  ^
  |
branch_two
  ^
  |
branch_one
  ^
  |
main
```

This workflow is possible but also very painful in many cases. For example, if commits are added or rebased in `branch_one`, `branch_two` and `branch_three` will often need to be rebased and any merge conflicts addressed. Rebasing becomes lengthy every time we alter a commit in the middle of the stack.

[Graphite](https://graphite.dev) makes the process of working with stacked PRs much easier. It can rebase and update a whole stack in one command, is much better at resolving rebases than the standard tooling, and works wonderfully in the terminal.

[You can read the Graphite documentation here](https://docs.graphite.dev)

It posts the relationships between the PRs in the stack to GitHub as a comment so that reviewers can traverse the relationships.

![A Graphite comment on a pull request](graphite_comment.png "A Graphite comment on a pull request")

And it can show you the relationships in the terminal and lets us navigate up and down the stack with commands like `gt up` and `gt down 3`

And the free version is more than enough to reap the benefits.

## The benefits

### Less context switching and more flow

Being able to stay on the same task is huge for me. A big part of developer happiness is the experience of being able to work for long stretches on challenging problems. This workflow enables us to batch up coding sessions and deployment sessions and does not leave you blocked by reviews. As a result, I felt motivated to write more code as I didn't feel like a brick wall was waiting for me.

### More reviews

Pull request reviews generally come in bursts. There will be long periods of no movement punctuated by sudden acts of mass review. This behaviour matches up with the common preference of batching up work. Therefore, the more PRs we can have ready when the next reviewer comes along, the more throughput we can manage.

### Safer deployments

The order in which we deploy matters, especially when it comes to microservices.

- We run the migration before deploying the related logic.
- We deploy the new API server before the client.
- We remove the calling code before deleting the deprecated function.
- Small PRs mean small merges and small deployments. Each deployment can be a small safe step. The alternative could be a large merge and a high-risk deployment that needs to be micro-managed and monitored.

### Smaller testing loops

Each of those PRs will have to pass the continuous integration tests, so we write tests and verify functionality in tighter loops. We can also work on the next PR in the stack while the previous one runs through CI.

### Better planning

I've found that my tickets are getting more detailed, and I am not just describing my work in smaller chunks but also deployment instructions around VMs, migrations, and monitoring. It's easy to miss these things when tickets are for larger scopes of work.

## Considerations and drawbacks

### It helps when we are better organized

Because you might be much farther ahead in the stack when a PR at the bottom of the pile gets merged, it is essential to note down actions that we need to take after merging like:

- Deployments
- Migrations
- Communication with stakeholders
- Monitoring

Because otherwise, we will miss things.

### You will still need to rebase occasionally

Graphite is good at rebasing, but there will still be conflicts. I feel like I am doing a fraction of the rebasing I would have done before (I still have nightmares), but there will still be rebasing occasionally.

### Don't manage more than a stack or two

The temptation is there to create many stacks or forks of stacks, but I recommend avoiding it because it brings back all the downsides of context switching. Instead, stay on the same task and add another PR to the stack.

### Stick to one commit per branch

When I first started, I tended to push multiple commits to the same branch and then use interactive rebase to either squash or drop commits. However, rebasing this way outside of Graphite managed to break Graphite's stack metadata, so I recommend using a single commit and amending it as you go.

## My code workflow

Some notes about tooling

- `gh` is the [GitHub CLI](https://cli.github.com/)
- `gt` is the [Graphite CLI](https://docs.graphite.dev/). Any commands passed in that Graphite does not recognize will fall through to git. So you do not need to use git commands anymore if you don't want to.

### Create a ticket

I like working with one ticket per PR, so thus start with a ticket that describes the changes and actions to be taken once merged.

### Create a commit, branch, and WIP PR

The long way of doing this would be

```bash
git add .
git commit -m "COMMIT MESSAGE"
gt branch create BRANCH_NAME
gt branch submit
```

I created a fish alias to do this in one command.

```bash
# gb BRANCH_NAME COMMIT MESSAGE

function gb
  gt branch create "$argv[1]" -a -m "$argv[2..-1]" --no-interactive && \
  gt branch submit --no-interactive
end

```

### Amend commit

Add onto your existing work by amending the current commit instead of pushing up a new one.

```bash
git add .
git commit --amend --no-edit
git push --force-with-lease
```

I recommend aliasing this too.

### Set PR as ready for review

Once I am ready for review, I run the following to turn my draft PR into a regular one.

```bash
gh pr ready
```

## Post-review care

So we have a bunch of reviewed PRs; what's next? The nice thing is that we are not blocked, so that we can merge and deploy them once enough are ready to go (or we feel like deploying things).
I periodically sync up remote and local and rebase off the main branch.

```bash
  gt repo sync --force
  gt stack restack
  gt stack submit --no-interactive
```

I generally merge branches one at a time into the main branch (starting from the "bottom" of a stack rather than the "top" if you visualize the stack as sitting on top of the default branch. Incrementally from the bottom allows me to do one deployment per PR and gradually push the work into production. Of course, while doing so, we read the ticket notes so we don't forget a migration or worse.

## In closing

I have gotten a great deal of value out of Graphite and stacked PRs over the last month or so of using it at work, and I recommend checking it out - especially if you find yourself context-switching while waiting on code review.
