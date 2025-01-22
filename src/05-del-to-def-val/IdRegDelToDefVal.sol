// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IdRegUnop} from "../IdRegUnop.sol";

contract IdRegDelToDefVal is IdRegUnop {
    function resetId(uint256 id) external override {
        // @audit instead of writing the default value to storage,
        // use `delete` for a potential gas refund
        delete idToOwner[id];
    }
}