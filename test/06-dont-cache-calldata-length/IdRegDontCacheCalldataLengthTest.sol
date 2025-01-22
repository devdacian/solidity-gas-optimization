// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IdRegUnopTest} from "../IdRegUnopTest.sol";
import {IdRegDontCacheCalldataLength} from "../../src/06-dont-cache-calldata-length/IdRegDontCacheCalldataLength.sol";

// Optimizer ON, 10000 runs
// ========================
// Pre  : 5294 gas
// forge test --optimizer-runs 10000 --match-contract IdRegUnopTest --match-test test_getOwnersForIds -vvv
// Post : 5289 gas (0.09% cheaper)
// forge test --optimizer-runs 10000 --match-contract IdRegDontCacheCalldataLength --match-test test_getOwnersForIds -vvv
//
// Optimizer OFF
// =============
// Pre  : 5580 gas
// forge test --match-contract IdRegUnopTest --match-test test_getOwnersForIds -vvv
// Post : 5575 gas (0.09% cheaper)
// forge test --match-contract IdRegDontCacheCalldataLength --match-test test_getOwnersForIds -vvv
//
// Conclusion
// ==========
// Cheaper not to cache `calldata` length
contract IdRegDontCacheCalldataLengthTest is IdRegUnopTest {
    function setUp() external override {
        idReg = new IdRegDontCacheCalldataLength();
    }
}