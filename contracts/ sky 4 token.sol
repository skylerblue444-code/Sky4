// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Sky4Token is ERC20, ERC20Burnable, Ownable {
    uint256 public constant MAX_SUPPLY = 100_000_000 ether;

    constructor(address timelock) ERC20("Sky4 Token", "SKY4") {
        _mint(timelock, MAX_SUPPLY);
        _transferOwnership(timelock);
    }
}