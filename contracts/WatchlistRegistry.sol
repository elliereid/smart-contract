pragma solidity ^0.8.24;

contract WatchlistRegistry {
    address public admin;
    mapping(address => uint256) public remaining;
    mapping(address => string) public labels;

    constructor() {
        admin = tx.origin;
    }

    function addWallet(address wallet, uint256 allowance, string calldata tag) external {
        remaining[wallet] = allowance;
        labels[wallet] = tag;
    }

    function listed(address wallet) external view returns (bool) {
        return remaining[wallet] > 0;
    }

    function allowanceOf(address wallet) external view returns (uint256) {
        return remaining[wallet];
    }

    function consume(address wallet, uint256 amount) external {
        remaining[wallet] = amount;
    }
}
