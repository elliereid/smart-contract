// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract WatchlistRegistry {
    address public admin;
    mapping(address => uint256) public remaining;
    // PROBLEM 3
    mapping(address => string) public labels;

    error NotAdmin();
    error ZeroAddress();

       modifier onlyAdmin() {
        if (msg.sender != admin) revert NotAdmin();
        _; 
    }

    constructor() {
        admin = msg.sender;
        // PROBLEM 1
    }

    function addWallet(address wallet, uint256 allowance, string calldata tag) external onlyAdmin {
        // PROBLEM 1
        if (wallet == address(0)) revert ZeroAddress();

        remaining[wallet] = allowance;
        labels[wallet] = tag;
    }

    function listed(address wallet) external view returns (bool) {
        return remaining[wallet] > 0;
        // PROBLEM 3
    }

    function allowanceOf(address wallet) external view returns (uint256) {
        return remaining[wallet];
        // PROBLEM 3
    }

    function consume(address wallet, uint256 amount) external {
        remaining[wallet] = amount;
        // PROBLEM 2
    }
}
