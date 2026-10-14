pragma solidity ^0.8.24;

contract WatchlistRegistry {
    address public admin;
    mapping(address => uint256) public remaining;
    // PROBLEM 3
    mapping(address => string) public labels;

    constructor() {
        admin = tx.origin;
        // PROBLEM 1
    }

    function addWallet(address wallet, uint256 allowance, string calldata tag) external {
        // PROBLEM 1
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
