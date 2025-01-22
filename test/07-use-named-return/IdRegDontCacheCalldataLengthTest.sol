// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IdRegUnopTest} from "../IdRegUnopTest.sol";
import {IdRegUseNamedReturn} from "../../src/07-use-named-return/IdRegUseNamedReturn.sol";

// Optimizer ON, 10000 runs
// ========================
// Pre  : 5289 gas
// forge test --optimizer-runs 10000 --match-contract IdRegDontCacheCalldataLength --match-test test_getOwnersForIds -vvv
// Post : 5281 gas (0.15% cheaper)
// forge test --optimizer-runs 10000 --match-contract IdRegUseNamedReturn --match-test test_getOwnersForIds -vvv
//
// Optimizer OFF
// =============
// Pre  : 5575 gas
// forge test --match-contract IdRegDontCacheCalldataLength --match-test test_getOwnersForIds -vvv
// Post : 5567 gas (0.14% cheaper)
// forge test --match-contract IdRegUseNamedReturn --match-test test_getOwnersForIds -vvv
//
// Conclusion
// ==========
// Using named returns is cheaper
contract IdRegUseNamedReturnTest is IdRegUnopTest {
    function setUp() external override {
        idReg = new IdRegUseNamedReturn();
    }
}