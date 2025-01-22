// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IdRegUnop} from "../IdRegUnop.sol";

contract IdRegReadWriteStorageOnce is IdRegUnop {
    constructor() {
        nextId = 1;
    }

    function generateIds(uint256 numIds, address[] calldata owners) external override {
        if(numIds != owners.length)
            revert NumIdsOwnersLengthMismatch(numIds, owners.length);

        // @audit read `nextId` from storage once
        // read next id from storage
        uint256 newId = nextId;

        for(uint256 i; i<numIds; i++) {
            // update the mapping
            // @audit use cached `newId` to set idToOwner storage
            // then increment cached `newId`
            idToOwner[newId++] = owners[i];
        }

        // @audit write final `newId` to `nextId` storage once
        nextId = newId;

        // instead of reading from and to writing `nextId` storage
        // during every loop iteration, we now only read and write
        // storage once which is cheaper
    }
}