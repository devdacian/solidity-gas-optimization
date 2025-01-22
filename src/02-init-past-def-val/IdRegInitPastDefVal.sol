// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IdRegUnop} from "../IdRegUnop.sol";

contract IdRegInitPastDefVal is IdRegUnop {
    // @audit since first id is always 1 initialize
    // storage past default 0 value
    constructor() {
        nextId = 1;
    }

    function generateIds(uint256 numIds, address[] memory owners) external override {
        if(numIds != owners.length)
            revert NumIdsOwnersLengthMismatch(numIds, owners.length);

        for(uint256 i; i<numIds; i++) {
            // read next id from storage
            uint256 newId = nextId;

            // @audit don't need to check against 0 every time
            // as we now initialize past 0

            // update the mapping
            idToOwner[newId] = owners[i];

            // update storage to increment next id
            nextId = newId + 1;
        }
    }
}