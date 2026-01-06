// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Sky4Treasury is Ownable {
    IERC20 public immutable token;

    constructor(address token_) {
        token = IERC20(token_);
    }

    function withdraw(address to, uint256 amount) external onlyOwner {
        token.transfer(to, amount);
    }
}