// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

// Layout of contract
// version
// imports
// errors
// interfaces, libraries, contracts
// type declarations
// state variables
// events
// modifiers
// Functions

// Layout of Functions
// Constructor
// Recieve function(if exists)
// fallback function(if exists)
// External
// Public
// Internal
// Private
// View & Pure functions

/*
 * @title DecentalisedStableCoin
 * @author Nkemjika
 * Collateral: Exogenous ETH and BTC
 * Minting: Algorithmic
 * Relative stability: Pegged to USD
 *
 * This is the contract meant to be governed by DSCEngine.
 * This contract is the ERC20 implementation of our stablecoin system
 */

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract DecentralisedStableCoin is ERC20, ERC20Burnable, Ownable {
    error DecentralisedStableCoin_AmountMustBeGreaterThanZero();
    error DecentralisedStableCoin_BurnAmountExceedsBalance();
    error DecentralisedStableCoin_NotZeroAddress();

    constructor(address owner) ERC20("DecentralisedStableCoin", "DSC") Ownable(owner) {}

    function burn(uint256 _amount) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);

        if (_amount <= 0) {
            revert DecentralisedStableCoin_AmountMustBeGreaterThanZero();
        }

        if (balance < _amount) {
            revert DecentralisedStableCoin_BurnAmountExceedsBalance();
        }

        // We are using super because we are calling the burn function in the imported super class.
        super.burn(_amount);
    }

    function mint(address _to, uint256 _amount) external onlyOwner returns (bool success) {
        if (_to == address(0)) {
            revert DecentralisedStableCoin_NotZeroAddress();
        }

        if (_amount <= 0) {
            revert DecentralisedStableCoin_AmountMustBeGreaterThanZero();
        }

        _mint(_to, _amount);

        return true;
    }
}
