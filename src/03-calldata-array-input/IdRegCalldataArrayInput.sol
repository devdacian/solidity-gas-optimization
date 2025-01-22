// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IdRegUnop} from "../IdRegUnop.sol";

contract IdRegCalldataArrayInput is IdRegUnop {
    constructor() {
        nextId = 1;
    }

    // @audit use `calldata` for read-only array inputs
    function generateIds(uint256 numIds, address[] calldata owners) external override {
        if(numIds != owners.length)
            revert NumIdsOwnersLengthMismatch(numIds, owners.length);

        for(uint256 i; i<numIds; i++) {
            // read next id from storage
            uint256 newId = nextId;

            // update the mapping
            idToOwner[newId] = owners[i];

            // update storage to increment next id
            nextId = newId + 1;
        }
    }
}