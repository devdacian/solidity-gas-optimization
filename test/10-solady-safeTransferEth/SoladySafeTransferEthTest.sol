// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {OwnerVaultTest} from "../OwnerVaultTest.sol";
import {SoladySafeTransferEth} from "../../src/10-solady-safeTransferEth/SoladySafeTransferEth.sol";

// Optimizer ON, 10000 runs
// ========================
// Pre  : 14420 gas
// forge test --optimizer-runs 10000 --match-contract MsgSenderNotOwnerTest --match-test test_sendETHToOwner -vvv
// Post : 14368 gas (0.36% cheaper)
// forge test --optimizer-runs 10000 --match-contract SoladySafeTransferEthTest --match-test test_sendETHToOwner -vvv
//
// Optimizer OFF
// =============
// Pre  : 14456 gas
// forge test --match-contract MsgSenderNotOwnerTest --match-test test_sendETHToOwner -vvv
// Post : 14404 gas (0.36% cheaper)
// forge test --match-contract SoladySafeTransferEthTest --match-test test_sendETHToOwner -vvv
//
// Conclusion
// ==========
// Using Solady SafeTransferEth cheaper than standard Solidity using `call`
contract SoladySafeTransferEthTest is OwnerVaultTest {
    function _createContract() internal override {
        ownerVault = new SoladySafeTransferEth();
    }
}