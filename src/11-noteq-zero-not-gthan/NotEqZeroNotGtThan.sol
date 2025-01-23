// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {OwnerVault} from "../OwnerVault.sol";

import {SafeTransferLib} from "@solady/utils/SafeTransferLib.sol";

contract NotEqZeroNotGtThan is OwnerVault {
    function sendETHToOwner() external override onlyOwner {
        uint256 ethBal = address(this).balance;

        // @audit using `!= 0` instead of `> 0` for unsigned
        // comparisons costs the same gas
        if(ethBal != 0) {
            SafeTransferLib.safeTransferETH(msg.sender, ethBal);
        }
    }
}


