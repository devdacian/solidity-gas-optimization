// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {OwnerVault} from "../OwnerVault.sol";

contract MsgSenderNotOwner is OwnerVault {
    function sendETHToOwner() external override onlyOwner {
        uint256 ethBal = address(this).balance;

        if(ethBal > 0) {
            // @audit more efficient to use `msg.sender` than `owner()`
            (bool sent, ) = msg.sender.call{value: ethBal}("");
            if(!sent) revert EthTransferFailed();
        }
    }
}


