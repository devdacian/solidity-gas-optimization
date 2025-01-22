// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IdRegUnop} from "../IdRegUnop.sol";

contract IdRegUseNamedReturn is IdRegUnop {
    function getOwnersForIds(uint256[] calldata ids) external view override returns(address[] memory owners) {
        // @audit using named return, allocate output array in memory
        owners = new address[](ids.length);

        // populate output array
        for(uint256 i; i<ids.length; i++) {
            owners[i] = idToOwner[ids[i]];
        }

        // @audit removed explicit `return` statement
    }
}