// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IdRegUnop} from "../IdRegUnop.sol";

contract IdRegDontCacheCalldataLength is IdRegUnop {
    function getOwnersForIds(uint256[] calldata ids) external view override returns(address[] memory) {
        // @audit don't cache calldata length
        // allocate output array in memory
        address[] memory owners = new address[](ids.length);

        // populate output array
        for(uint256 i; i<ids.length; i++) {
            owners[i] = idToOwner[ids[i]];
        }

        // return output array
        return owners;
    }
}