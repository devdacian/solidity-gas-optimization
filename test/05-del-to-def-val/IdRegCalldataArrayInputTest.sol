// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IdRegUnopTest} from "../IdRegUnopTest.sol";
import {IdRegDelToDefVal} from "../../src/05-del-to-def-val/IdRegDelToDefVal.sol";

// Optimizer ON, 10000 runs
// ========================
// Pre  : 979 gas
// forge test --optimizer-runs 10000 --match-contract IdRegUnopTest --match-test test_resetId -vvv
// Post : 979 gas (no improvement)
// forge test --optimizer-runs 10000 --match-contract IdRegDelToDefVal --match-test test_resetId -vvv
//
// Optimizer OFF
// =============
// Pre  : 1018 gas
// forge test --match-contract IdRegUnopTest --match-test test_resetId -vvv
// Post : 1018 gas (no improvement)
// forge test --match-contract IdRegDelToDefVal --match-test test_resetId -vvv
//
// Conclusion
// ==========
// Setting storage to default values costs the same
// as using the `delete` keyword
contract IdRegDelToDefValTest is IdRegUnopTest {
    function setUp() external override {
        idReg = new IdRegDelToDefVal();
    }
}