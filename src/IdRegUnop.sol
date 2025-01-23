// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IIdReg {
    // errors
    error NumIdsOwnersLengthMismatch(uint256 numIds, uint256 ownersLength);

    // public API
    //
    // view functions
    function nextId() external view returns(uint256);
    function idToOwner(uint256 id) external view returns(address);
    function getOwnersForIds(uint256[] calldata ids) external view returns(address[] memory);

    // non-view functions which change state
    function generateIds(uint256 numIds, address[] memory owners) external;
    function resetId(uint256 id) external;
}

// unoptimized implementation
contract IdRegUnop is IIdReg {
    // next available id
    uint256 public nextId;
    
    // mapping of valid ids to their owner
    mapping(uint256 id => address owner) public idToOwner;

    // creates `numIds` new valid ids in ascending
    // order from previously created ids
    // @audit external and public result in same gas cost, tested
    // manually as this would break compilation with existing structure
    function generateIds(uint256 numIds, address[] memory owners) external virtual {
        if(numIds != owners.length)
            revert NumIdsOwnersLengthMismatch(numIds, owners.length);

        for(uint256 i=0; i<numIds; i++) {
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

    // reset an id back to no owner
    function resetId(uint256 id) external virtual {
        idToOwner[id] = address(0);
    }

    // get owners for given list of ids
    function getOwnersForIds(uint256[] calldata ids) external view virtual returns(address[] memory) {
        // cache length
        uint256 idsLength = ids.length;

        // allocate output array in memory
        address[] memory owners = new address[](idsLength);

        // populate output array
        for(uint256 i; i<idsLength; i++) {
            owners[i] = idToOwner[ids[i]];
        }

        // return output array
        return owners;
    }
}