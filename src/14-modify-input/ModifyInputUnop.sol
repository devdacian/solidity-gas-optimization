// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IModifyInput {
    function returnLowest(uint256 input) external view returns(uint256 lowest);
}

contract ModifyInputUnop is IModifyInput {
    uint256[] internal comps;

    constructor(uint256[] memory _comps) {
        for(uint256 i; i<_comps.length; i++) {
            comps.push(_comps[i]);
        }
    }

    function returnLowest(uint256 input) external view virtual returns(uint256 lowest) {
        lowest = input;

        uint256 compsLen = comps.length;
        for(uint256 i; i<compsLen; i++) {
            // use a temporary variable for the comparison
            uint256 temp = comps[i];

            if(temp < lowest) {
                lowest = temp;
            }
        }
    }
}