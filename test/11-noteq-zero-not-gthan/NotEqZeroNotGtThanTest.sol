// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {OwnerVaultTest} from "../OwnerVaultTest.sol";
import {NotEqZeroNotGtThan} from "../../src/11-noteq-zero-not-gthan/NotEqZeroNotGtThan.sol";

// Optimizer ON, 10000 runs
// ========================
// Pre  : 14368 gas
// forge test --optimizer-runs 10000 --match-contract SoladySafeTransferEthTest --match-test test_sendETHToOwner -vvv
// Post : 14368 gas (no improvement)
// forge test --optimizer-runs 10000 --match-contract NotEqZeroNotGtThan --match-test test_sendETHToOwner -vvv
//
// Optimizer OFF
// =============
// Pre  : 14404 gas
// forge test --match-contract SoladySafeTransferEthTest --match-test test_sendETHToOwner -vvv
// Post : 14404 gas (no improvement)
// forge test --match-contract NotEqZeroNotGtThan --match-test test_sendETHToOwner -vvv
//
// Conclusion
// ==========
// Using Solady SafeTransferEth cheaper than standard Solidity using `call`
contract NotEqZeroNotGtThanTest is OwnerVaultTest {
    function _createContract() internal override {
        ownerVault = new NotEqZeroNotGtThan();
    }
}