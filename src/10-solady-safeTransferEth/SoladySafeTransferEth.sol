// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {OwnerVault} from "../OwnerVault.sol";

import {SafeTransferLib} from "@solady/utils/SafeTransferLib.sol";

contract SoladySafeTransferEth is OwnerVault {
    function sendETHToOwner() external override onlyOwner {
        uint256 ethBal = address(this).balance;

        if(ethBal > 0) {
            SafeTransferLib.safeTransferETH(msg.sender, ethBal);
        }
    }
}


