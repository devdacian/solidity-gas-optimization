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