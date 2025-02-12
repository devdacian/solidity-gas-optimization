// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {IModifyInput, ModifyInputUnop} from "../../src/14-modify-input/ModifyInputUnop.sol";
import {ModifyInputFixed} from "../../src/14-modify-input/ModifyInputFixed.sol";

// Optimizer ON, 10000 runs
// ========================
// Pre  : 19260 gas
// Post : 19223 gas (0.19% cheaper)
// forge test --optimizer-runs 10000 --match-contract ModifyInputTest --match-test test_returnLowest -vvv
//
// Optimizer OFF
// =============
// Pre  : 19278 gas
// Post : 19241 gas (0.19% cheaper)
// forge test --match-contract ModifyInputTest --match-test test_returnLowest -vvv
//
// Conclusion
// ==========
// Modifying an input variable whose value doesn't need to be preserved
// is more gas-efficient than using an additional temporary variable
contract ModifyInputTest is Test {
    IModifyInput internal modifyInputUnop;
    IModifyInput internal modifyInputFixed;

    function setUp() external virtual {
        // create contracts being tested
        uint256[] memory comps = new uint256[](5);
        comps[0] = 5;
        comps[1] = 4;
        comps[2] = 3;
        comps[3] = 2;
        comps[4] = 1;

        modifyInputUnop  = new ModifyInputUnop(comps);
        modifyInputFixed = new ModifyInputFixed(comps);

        assertEq(modifyInputUnop.returnLowest(10), comps[4]);
        assertEq(modifyInputFixed.returnLowest(10), comps[4]);
    }

    function test_returnLowest() external view {
        // call functions under test
        uint256 gasPre = gasleft();
        modifyInputUnop.returnLowest(10);
        console.log("Unoptimized returnLowest() cost %d gas", gasPre - gasleft());

        gasPre = gasleft();
        modifyInputFixed.returnLowest(10);
        console.log("Optimized   returnLowest() cost %d gas", gasPre - gasleft());
    }
}