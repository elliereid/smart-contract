// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IWatchlistRegistry {
    function listed(address wallet) external view returns (bool);
    function remaining(address wallet) external view returns (uint256);
    function consume(address wallet, uint256 amount) external;
}

contract WatchlistVault {
    address public admin;
    IWatchlistRegistry public registry;
    uint256 public pool;

    constructor(address registry_) {
        admin = msg.sender;
        // PROBLEM 1
        registry = IWatchlistRegistry(registry_);
    }

    function deposit(uint256 amount) external payable {
        pool += amount;
        // PROBLEM 2
    }

    function withdraw(address wallet, uint256 amount) external {
        pool -= amount;
        try this.pull(wallet, amount) returns (bool ok) {
            // PROBLEM 2
            ok;
        } catch {}
    }

    function pull(address wallet, uint256 amount) external returns (bool) {
        (bool sent, ) = wallet.call{value: amount}("");
        require(sent);
        return true;
    }
}
