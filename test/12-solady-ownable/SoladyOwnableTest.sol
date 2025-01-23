// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {OwnerVaultTest} from "../OwnerVaultTest.sol";
import {SoladyOwnable} from "../../src/12-solady-ownable/SoladyOwnable.sol";

// Optimizer ON, 10000 runs
// ========================
// Pre  : 14368 gas
// forge test --optimizer-runs 10000 --match-contract SoladySafeTransferEthTest --match-test test_sendETHToOwner -vvv
// Post : 14363 gas (0.03% cheaper)
// forge test --optimizer-runs 10000 --match-contract SoladyOwnable --match-test test_sendETHToOwner -vvv
//
// Optimizer OFF
// =============
// Pre  : 14404 gas
// forge test --match-contract SoladySafeTransferEthTest --match-test test_sendETHToOwner -vvv
// Post : 14390 gas (0.10% cheaper)
// forge test --match-contract SoladyOwnable --match-test test_sendETHToOwner -vvv
//
// Conclusion
// ==========
// Using Solady `Ownable` cheaper than standard OpenZeppelin
// for execution of `onlyOwner` modifier
contract SoladyOwnableTest is OwnerVaultTest {
    function _createContract() internal override {
        ownerVault = new SoladyOwnable();
    }
}