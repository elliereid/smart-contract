# Wallet Watchlist

On-chain treasury: a registry of listed wallets and a vault for deposits and withdraws.

We have turned several problems we face in practice into a problem review so we can see how you think. Please download the project, check out the `problems` branch, open `PROBLEMS.md`, and make commits with clear messages as you work through them.

You may rewrite the contracts in the stack you ship with. Keep the vault behavior. We care about how you work through the problems, not whether you stay in these files.

In the meeting, walk us through your approach, including your assumptions, tradeoffs, and the solution you would choose.

## Start here

You are on **`main`**.

**Check out `problems` for the current problem list:**

```bash
git checkout problems
```

Then open **`PROBLEMS.md`**.

## What is in the codebase

- `contracts/WatchlistRegistry.sol` - who is listed and remaining allowance
- `contracts/WatchlistVault.sol` - deposits and withdrawals
