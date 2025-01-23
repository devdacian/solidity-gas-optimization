// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {OwnerVault, IOwnerVault} from "../src/OwnerVault.sol";

contract OwnerVaultTest is Test {
    IOwnerVault internal ownerVault;

    uint256 internal constant ETH_BAL = 1e18;

    // will be overriden by child tests
    function _createContract() internal virtual {
        ownerVault = new OwnerVault();
    }

    function setUp() external virtual {
        // create contract being tested
        _createContract();

        // fund contract
        vm.deal(address(ownerVault), ETH_BAL);

        // verify contract has balance
        assertEq(address(ownerVault).balance, ETH_BAL);

        // verify contract owned by test harness
        assertEq(ownerVault.owner(), address(this));
    }

    // this contract needs to receive eth from vault
    receive() external payable {}

    function test_sendETHToOwner() external {
        uint256 thisEthPre = address(this).balance;

        // call function under test
        uint256 gasPre = gasleft();
        ownerVault.sendETHToOwner();
        console.log("sendETHToOwner() cost %d gas", gasPre - gasleft());

        // verify contract has no balance remaining
        assertEq(address(ownerVault).balance, 0);

        // verify owner received eth
        assertEq(address(this).balance, thisEthPre + ETH_BAL);
    }
}