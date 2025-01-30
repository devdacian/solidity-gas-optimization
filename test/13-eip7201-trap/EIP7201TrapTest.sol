// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {IOrderBook, EIP7201TrapUnop} from "../../src/13-eip7201-trap/EIP7201TrapUnop.sol";
import {EIP7201TrapFixed} from "../../src/13-eip7201-trap/EIP7201TrapFixed.sol";

// Optimizer ON, 10000 runs
// ========================
// Pre  : 8361 gas
// Post : 7571 gas (9.45% cheaper)
// forge test --optimizer-runs 10000 --match-contract EIP7201TrapTest --match-test test_createOrder -vvv
//
// Optimizer OFF
// =============
// Pre  : 8617 gas
// Post : 7595 gas (11.86% cheaper)
// forge test --match-contract EIP7201TrapTest --match-test test_createOrder -vvv
//
// Conclusion
// ==========
// Caching variables which aren't changed by particular functionality and
// passing them to child functions instead of re-reading them from storage
// is significantly cheaper
contract EIP7201TrapTest is Test {
    IOrderBook internal orderBookUnop;
    IOrderBook internal orderBookFixed;

    function setUp() external virtual {
        // create contracts being tested
        uint256 expectedVal = 100;
        orderBookUnop = new EIP7201TrapUnop(expectedVal);
        orderBookFixed = new EIP7201TrapFixed(expectedVal);
        assertEq(orderBookUnop.EXPECTED_VAL(), expectedVal);
        assertEq(orderBookFixed.EXPECTED_VAL(), expectedVal);
    }

    function test_createOrder() external {
        // call functions under test
        uint256 gasPre = gasleft();
        orderBookUnop.createOrder();
        console.log("Unoptimized createOrder() cost %d gas", gasPre - gasleft());

        gasPre = gasleft();
        orderBookFixed.createOrder();
        console.log("Optimized   createOrder() cost %d gas", gasPre - gasleft());
    }
}