// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IOrderBook} from "./EIP7201TrapUnop.sol";

contract EIP7201TrapFixed is IOrderBook {
    // EIP7201 Namespaced Storage Layout
    bytes32 private constant ORDER_PIPELINE_STORAGE_SLOT =
        0x110c926fa16509da894f0a2a08278b82b2a2f9ffc38d1ed1975f32ef34198800;

    struct OrderPipelineStorage {
        uint256 instrumentId;
        // snip : lots of different fields
    }
    function _getOrderPipelineStorage() internal pure returns (OrderPipelineStorage storage store) {
        assembly {
            store.slot := ORDER_PIPELINE_STORAGE_SLOT
        }
    }

    // just so functions have something to do
    uint256 public immutable EXPECTED_VAL;
    constructor(uint256 expectedVal) {
        EXPECTED_VAL = expectedVal;
        _getOrderPipelineStorage().instrumentId = expectedVal;
    }

    // entry function for processing an order
    function createOrder() external {
        // read the value once
        uint256 readOne = _getOrderPipelineStorage().instrumentId;
        assert(readOne == EXPECTED_VAL);

        // pass the cached value to child functions
        _beforeOrderCheck(readOne);

        // use the cached value within same function
        assert(readOne == EXPECTED_VAL);

        _afterOrderCheck(readOne);
    }

    function _beforeOrderCheck(uint256 readOne) internal {
        assert(readOne == EXPECTED_VAL);

        _beforeOrderCheckParent(readOne);

        assert(readOne == EXPECTED_VAL);
    }

    function _beforeOrderCheckParent(uint256 readOne) internal {
        assert(readOne == EXPECTED_VAL);
    }

    function _afterOrderCheck(uint256 readOne) internal {
        assert(readOne == EXPECTED_VAL);

         _instantSettlement(readOne);
    }

    function _instantSettlement(uint256 readOne) internal {
        assert(readOne == EXPECTED_VAL);

         _partialSettlement(readOne);
    }

    function _partialSettlement(uint256 readOne) internal {
        assert(readOne == EXPECTED_VAL);
    }
}