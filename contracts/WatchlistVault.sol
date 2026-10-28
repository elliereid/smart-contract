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

    error ZeroAmount();
    event Deposited(address indexed from, uint256 amount);

    constructor(address registry_) {
        admin = msg.sender;
        // PROBLEM 1
        registry = IWatchlistRegistry(registry_);
    }

    function deposit(uint256/* amount */) external payable {
        // Check for zero amount and credit msg.value on deposit
        if (msg.value == 0) revert ZeroAmount();
        pool += msg.value; // Changed bc we don't trust the actual parameter, only ETH sent
        emit Deposited(msg.sender, msg.value);
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
