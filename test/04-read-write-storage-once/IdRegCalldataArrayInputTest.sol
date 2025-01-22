// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IdRegUnopTest} from "../IdRegUnopTest.sol";
import {IdRegReadWriteStorageOnce} from "../../src/04-read-write-storage-once/IdRegReadWriteStorageOnce.sol";

// Optimizer ON, 10000 runs
// ========================
// Pre  : 124554 gas
// forge test --optimizer-runs 10000 --match-contract IdRegCalldataArrayInputTest --match-test test_generateIds -vvv
// Post : 123737 gas (0.66% cheaper)
// forge test --optimizer-runs 10000 --match-contract IdRegReadWriteStorageOnceTest --match-test test_generateIds -vvv
//
// Optimizer OFF
// =============
// Pre  : 124827 gas
// forge test --match-contract IdRegCalldataArrayInputTest --match-test test_generateIds -vvv
// Post : 124010 gas (0.65% cheaper)
// forge test --match-contract IdRegReadWriteStorageOnceTest --match-test test_generateIds -vvv
//
// Conclusion
// ==========
// Cache storage reads and writes is cheaper
contract IdRegReadWriteStorageOnceTest is IdRegUnopTest {
    function setUp() external override {
        idReg = new IdRegReadWriteStorageOnce();
    }
}