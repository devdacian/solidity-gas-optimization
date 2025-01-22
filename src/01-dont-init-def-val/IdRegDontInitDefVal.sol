// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IdRegUnop} from "../IdRegUnop.sol";

contract IdRegDontInitDefVal is IdRegUnop {
    function generateIds(uint256 numIds, address[] memory owners) external override {
        if(numIds != owners.length)
            revert NumIdsOwnersLengthMismatch(numIds, owners.length);

        // @audit don't initialize loop variable to zero as solidity
        // automatically initializes variable to their default value
        // note: test shows no gas savings but does eliminate useless code
        for(uint256 i; i<numIds; i++) {
            // read next id from storage
            uint256 newId = nextId;

            // first id should start at 1
            if(newId == 0) newId = 1;

            // update the mapping
            idToOwner[newId] = owners[i];

            // update storage to increment next id
            nextId = newId + 1;
        }
    }
} 