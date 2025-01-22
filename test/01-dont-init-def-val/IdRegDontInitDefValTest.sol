// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IdRegUnopTest} from "../IdRegUnopTest.sol";
import {IdRegDontInitDefVal} from "../../src/01-dont-init-def-val/IdRegDontInitDefVal.sol";

// Optimizer ON, 10000 runs
// ========================
// Pre  : 142049 gas
// forge test --optimizer-runs 10000 --match-contract IdRegUnopTest --match-test test_generateIds -vvv
// Post : 142049 gas (no improvement)
// forge test --optimizer-runs 10000 --match-contract IdRegDontInitDefValTest --match-test test_generateIds -vvv
//
// Optimizer OFF
// =============
// Pre  : 142325 gas
// forge test --match-contract IdRegUnopTest --match-test test_generateIds -vvv
// Post : 142325 gas (no improvement)
// forge test --match-contract IdRegDontInitDefValTest --match-test test_generateIds -vvv
//
// Conclusion
// ==========
// `for(uint256 i=0;)` costs the same as `for(uint256 i;)`
contract IdRegDontInitDefValTest is IdRegUnopTest {
    function setUp() external override {
        idReg = new IdRegDontInitDefVal();
    }
}