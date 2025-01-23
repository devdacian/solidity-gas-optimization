// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {OwnerVaultTest} from "../OwnerVaultTest.sol";
import {MsgSenderNotOwner} from "../../src/09-msgsender-not-owner/MsgSenderNotOwner.sol";

// Optimizer ON, 10000 runs
// ========================
// Pre  : 14530 gas
// forge test --optimizer-runs 10000 --match-contract OwnerVaultTest --match-test test_sendETHToOwner -vvv
// Post : 14420 gas (0.76% cheaper)
// forge test --optimizer-runs 10000 --match-contract MsgSenderNotOwnerTest --match-test test_sendETHToOwner -vvv
//
// Optimizer OFF
// =============
// Pre  : 14578 gas
// forge test --match-contract OwnerVaultTest --match-test test_sendETHToOwner -vvv
// Post : 14456 gas (0.84% cheaper)
// forge test --match-contract MsgSenderNotOwnerTest --match-test test_sendETHToOwner -vvv
//
// Conclusion
// ==========
// Using `msg.sender` instead of `owner()` is cheaper
contract MsgSenderNotOwnerTest is OwnerVaultTest {
    function _createContract() internal override {
        ownerVault = new MsgSenderNotOwner();
    }
}