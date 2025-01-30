// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IOrderBook {
    function createOrder() external;
    function EXPECTED_VAL() external returns(uint256);
}

contract EIP7201TrapUnop is IOrderBook {
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
        uint256 readOne = _getOrderPipelineStorage().instrumentId;
        assert(readOne == EXPECTED_VAL);

        _beforeOrderCheck();

        uint256 readTwo = _getOrderPipelineStorage().instrumentId;
        assert(readTwo == EXPECTED_VAL);

        _afterOrderCheck();
    }

    function _beforeOrderCheck() internal {
        uint256 readThree = _getOrderPipelineStorage().instrumentId;
        assert(readThree == EXPECTED_VAL);

        _beforeOrderCheckParent();

        uint256 readFour = _getOrderPipelineStorage().instrumentId;
        assert(readFour == EXPECTED_VAL);
    }

    function _beforeOrderCheckParent() internal {
        uint256 readFive = _getOrderPipelineStorage().instrumentId;
        assert(readFive == EXPECTED_VAL);
    }

    function _afterOrderCheck() internal {
        uint256 readSix = _getOrderPipelineStorage().instrumentId;
        assert(readSix == EXPECTED_VAL);

         _instantSettlement();
    }

    function _instantSettlement() internal {
        uint256 readSeven = _getOrderPipelineStorage().instrumentId;
        assert(readSeven == EXPECTED_VAL);

         _partialSettlement();
    }

    function _partialSettlement() internal {
        uint256 readEight = _getOrderPipelineStorage().instrumentId;
        assert(readEight == EXPECTED_VAL);
    }
}