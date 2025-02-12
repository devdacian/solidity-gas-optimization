// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ModifyInputUnop} from "./ModifyInputUnop.sol";

contract ModifyInputFixed is ModifyInputUnop {

    constructor(uint256[] memory _comps) ModifyInputUnop(_comps) {}

    function returnLowest(uint256 input) external view override returns(uint256 lowest) {
        lowest = input;

        uint256 compsLen = comps.length;
        for(uint256 i; i<compsLen; i++) {
            // overwrite input for comparison, no need for additional
            // temporary variable if original input val doesn't need preservation
            input = comps[i];

            if(input < lowest) {
                lowest = input;
            }
        }
    }
}