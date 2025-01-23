// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IOwnerVault} from "../OwnerVault.sol";

import {Ownable} from "@solady/auth/Ownable.sol";
import {SafeTransferLib} from "@solady/utils/SafeTransferLib.sol";

// @audit using Solady `Ownable` instead of OpenZeppelin
// provides cheaper `onlyOwner` modifier calls
contract SoladyOwnable is IOwnerVault, Ownable {
    constructor() { 
        _initializeOwner(msg.sender);
    }

    function owner() public view override(IOwnerVault, Ownable) returns(address ownerOut) {
        ownerOut = Ownable.owner();
    }

    receive() external payable {}

    function sendETHToOwner() external override onlyOwner {
        uint256 ethBal = address(this).balance;

        if(ethBal > 0) {
            SafeTransferLib.safeTransferETH(msg.sender, ethBal);
        }
    }
}


