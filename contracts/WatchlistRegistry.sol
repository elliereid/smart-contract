// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract WatchlistRegistry {
    address public admin;
    address public vault; // only address that can spend allowances

    mapping(address => uint256) public remaining;
    // PROBLEM 3
    mapping(address => string) public labels;

    // Errors
    error NotAdmin();
    error NotVault();
    error ZeroAddress();
    error ZeroAmount();
    error InsufficientAllowance();


    event VaultSet(address indexed vault);

       modifier onlyAdmin() {
        if (msg.sender != admin) revert NotAdmin();
        _; 
    }

    constructor() {
        admin = msg.sender;
        // PROBLEM 1
    }

    // sets the vault to onlyAdmin
    function setVault (address vault_) external onlyAdmin {
        if (vault_ == address(0)) revert ZeroAddress();
        vault = vault_;
        emit VaultSet(vault_);
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
        // Authorize msg.sender as vault
        if (msg.sender != vault) revert NotVault();

        // Validate that there isn't a 0 amount
        if (amount == 0) revert ZeroAmount();

        //Read local storage once & reuse
        uint256 leftAmount = remaining[wallet];

        if (amount > leftAmount) revert InsufficientAllowance();

        // Changed to allow no one to be able to reset wallet's allowance
        remaining[wallet] = leftAmount - amount;
        // PROBLEM 2
    }
}
