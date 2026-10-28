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

    error NotListed();
    error PoolInsufficient();
    error TransferFailed();
    error ZeroAmount();

    event Deposited(address indexed from, uint256 amount);
    event Withdrawn(address indexed wallet, uint256 amount);

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
        // Check for custom errors
        if (amount == 0) revert ZeroAmount();
        if (!registry.listed(wallet)) revert NotListed();
        if (amount > pool) revert PoolInsufficient();

        // State changes before ETH leaves
        pool -= amount;

        // Added an emit event in place of pull
        registry.consume(wallet, amount); // reverts if over allowance
        emit Withdrawn(wallet, amount);

        // Interacting after
        (bool sent, ) = wallet.call{value: amount}("");
        if (!sent) revert TransferFailed();
    }
}
