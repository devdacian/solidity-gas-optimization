// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IdRegUnopTest} from "../IdRegUnopTest.sol";
import {IdRegInitPastDefVal} from "../../src/02-init-past-def-val/IdRegInitPastDefVal.sol";

// Optimizer ON, 10000 runs
// ========================
// Pre  : 142049 gas
// forge test --optimizer-runs 10000 --match-contract IdRegUnopTest --match-test test_generateIds -vvv
// Post : 124829 gas (12% cheaper)
// forge test --optimizer-runs 10000 --match-contract IdRegInitPastDefValTest --match-test test_generateIds -vvv
//
// Optimizer OFF
// =============
// Pre  : 142325 gas
// forge test --match-contract IdRegUnopTest --match-test test_generateIds -vvv
// Post : 125105 gas (12% cheaper)
// forge test --match-contract IdRegInitPastDefValTest --match-test test_generateIds -vvv
//
// Conclusion
// ==========
// Initializing values past their default is cheaper
contract IdRegInitPastDefValTest is IdRegUnopTest {
    function setUp() external override {
        idReg = new IdRegInitPastDefVal();
    }
}