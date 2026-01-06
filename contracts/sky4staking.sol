// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Sky4Staking is ReentrancyGuard, Ownable {
    IERC20 public immutable token;

    uint256 public rewardRate; // per second
    uint256 public lastUpdate;
    uint256 public accRewardPerShare;
    uint256 public totalStaked;

    struct StakeInfo {
        uint256 amount;
        uint256 rewardDebt;
        uint256 unlockTime;
    }

    mapping(address => StakeInfo) public stakes;

    constructor(address token_, uint256 rewardRate_) {
        token = IERC20(token_);
        rewardRate = rewardRate_;
        lastUpdate = block.timestamp;
    }

    function _update() internal {
        if (totalStaked > 0) {
            uint256 delta = block.timestamp - lastUpdate;
            accRewardPerShare += (delta * rewardRate * 1e12) / totalStaked;
        }
        lastUpdate = block.timestamp;
    }

    function stake(uint256 amount, uint256 lockDays) external nonReentrant {
        require(amount > 0, "zero stake");
        require(lockDays == 0 || lockDays == 30 || lockDays == 90 || lockDays == 365, "bad lock");

        _update();
        StakeInfo storage s = stakes[msg.sender];

        if (s.amount > 0) {
            uint256 pending = (s.amount * accRewardPerShare) / 1e12 - s.rewardDebt;
            if (pending > 0) token.transfer(msg.sender, pending);
        }

        token.transferFrom(msg.sender, address(this), amount);
        s.amount += amount;
        totalStaked += amount;

        uint256 bonus;
        if (lockDays == 30) bonus = 2;
        if (lockDays == 90) bonus = 5;
        if (lockDays == 365) bonus = 10;

        s.unlockTime = block.timestamp + lockDays * 1 days;
        s.rewardDebt = (s.amount * accRewardPerShare) / 1e12;
        rewardRate += (rewardRate * bonus) / 100;
    }

    function unstake(uint256 amount) external nonReentrant {
        StakeInfo storage s = stakes[msg.sender];
        require(block.timestamp >= s.unlockTime, "locked");
        require(amount <= s.amount, "exceeds stake");

        _update();
        uint256 pending = (s.amount * accRewardPerShare) / 1e12 - s.rewardDebt;
        if (pending > 0) token.transfer(msg.sender, pending);

        s.amount -= amount;
        totalStaked -= amount;
        token.transfer(msg.sender, amount);

        s.rewardDebt = (s.amount * accRewardPerShare) / 1e12;
    }
}