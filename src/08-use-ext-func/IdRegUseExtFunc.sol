// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IdRegUnop} from "../IdRegUnop.sol";

contract IdRegUseExtFunc is IdRegUnop {
    // @audit change from `external` to `public` to see if
    // gas costs increase (compile breaks the other way)
    function resetId(uint256 id) public override {
        idToOwner[id] = address(0);
    }
}


