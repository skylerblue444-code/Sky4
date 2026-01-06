// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Sky4BurnAdapter is Ownable {
    IERC20 public immutable token;

    constructor(address token_) {
        token = IERC20(token_);
    }

    function burnFrom(address from, uint256 amount) external onlyOwner {
        token.transferFrom(from, address(0xdead), amount);
    }
}