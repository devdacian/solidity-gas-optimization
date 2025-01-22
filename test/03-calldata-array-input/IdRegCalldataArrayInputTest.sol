// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IdRegUnopTest} from "../IdRegUnopTest.sol";
import {IdRegCalldataArrayInput} from "../../src/03-calldata-array-input/IdRegCalldataArrayInput.sol";

// Optimizer ON, 10000 runs
// ========================
// Pre  : 124829 gas
// forge test --optimizer-runs 10000 --match-contract IdRegInitPastDefValTest --match-test test_generateIds -vvv
// Post : 124554 gas (0.22% cheaper)
// forge test --optimizer-runs 10000 --match-contract IdRegCalldataArrayInputTest --match-test test_generateIds -vvv
//
// Optimizer OFF
// =============
// Pre  : 125105 gas
// forge test --match-contract IdRegInitPastDefValTest --match-test test_generateIds -vvv
// Post : 124827 gas (0.22% cheaper)
// forge test --match-contract IdRegCalldataArrayInputTest --match-test test_generateIds -vvv
//
// Conclusion
// ==========
// Using `calldata` for array inputs is cheaper than `memory`
contract IdRegCalldataArrayInputTest is IdRegUnopTest {
    function setUp() external override {
        idReg = new IdRegCalldataArrayInput();
    }
}