// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { Ownable } from "@openzeppelin/access/Ownable.sol";

interface IOwnerVault {
    // errors
    error EthTransferFailed();

    // public API
    //
    // view functions
    function owner() external view returns(address);

    // non-view functions which change state
    function sendETHToOwner() external;
}

// allows an owner to store eth & retrieve it later
contract OwnerVault is IOwnerVault, Ownable {
    constructor() Ownable(msg.sender) {}

    function owner() public view override(IOwnerVault, Ownable) returns(address ownerOut) {
        ownerOut = Ownable.owner();
    }

    receive() external payable {}

    function sendETHToOwner() external virtual onlyOwner {
        uint256 ethBal = address(this).balance;

        if(ethBal > 0) {
            (bool sent, ) = owner().call{value: ethBal}("");
            if(!sent) revert EthTransferFailed();
        }
    }
}