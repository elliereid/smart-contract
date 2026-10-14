# Wallet Watchlist problems

These are issues ops hit on the registry and vault. On this branch the matching spots are tagged in the source. Search for `PROBLEM 1`, `PROBLEM 2`, or `PROBLEM 3`.

Work through them in the code, and make commits with clear messages as you go. You may rewrite the contracts in the stack you ship with. Keep the vault behavior.

## 1. Anyone can add wallets (`PROBLEM 1`)

What we need: only the admin can add a wallet, and only with a non-zero wallet address. A missing or spoofed caller must not count as admin. Admin should be the deploying contract caller (`msg.sender`), not `tx.origin`.

What happens now:
- `addWallet` does not check `msg.sender` against `admin`. `address(0)` still lands in `remaining`.
- Both constructors set `admin = tx.origin`, so a factory or relay can make a different EOA look like admin.

Where to look:
- `contracts/WatchlistRegistry.sol` - constructor, `addWallet`
- `contracts/WatchlistVault.sol` - constructor

## 2. Deposits and withdraws do not hold (`PROBLEM 2`)

What we need: amounts must be greater than 0. A deposit must credit the vault with the ETH actually sent (`msg.value`). Only a listed wallet can withdraw, and only up to remaining allowance. A successful withdraw cuts both the pool and remaining. Failed withdraws should revert, not be swallowed.

What happens now:
- `deposit` adds `amount` to `pool` and ignores `msg.value`, so a `0` value still credits the pool.
- `withdraw` always cuts `pool` first, does not call `consume`, and wraps `pull` in try/catch so a failed send still looks finished.
- `consume` sets remaining to `amount` instead of subtracting, and anyone can call it.

Where to look:
- `contracts/WatchlistVault.sol` - `deposit`, `withdraw`, `pull`
- `contracts/WatchlistRegistry.sol` - `consume`

## 3. A missing wallet looks like remaining 0 (`PROBLEM 3`)

What we need: remaining allowance may reach `0` after withdraws. That must not look the same as "never listed". `listed` should not mean "remaining is above 0".

What happens now:
- `allowanceOf` and `remaining` return `0` for an address that was never added, because the mapping default is `0`.
- `listed` is `remaining[wallet] > 0`, so a fully used wallet looks unlisted.

Where to look:
- `contracts/WatchlistRegistry.sol` - `remaining`, `listed`, `allowanceOf`
