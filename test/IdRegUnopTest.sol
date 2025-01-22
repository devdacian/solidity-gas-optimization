// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {IdRegUnop, IIdReg} from "../src/IdRegUnop.sol";

contract IdRegUnopTest is Test {
    IIdReg internal idReg;

    uint256 constant NUM_IDS   = 5;
    address constant OWNER_ID1 = address(0x1111);
    address constant OWNER_ID2 = address(0x1112);
    address constant OWNER_ID3 = address(0x1113);
    address constant OWNER_ID4 = address(0x1114);
    address constant OWNER_ID5 = address(0x1115);

    function setUp() external virtual {
        idReg = new IdRegUnop();
    }

    function test_generateIds() public {
        // prepare inputs
        address[] memory owners = new address[](NUM_IDS);
        owners[0] = OWNER_ID1;
        owners[1] = OWNER_ID2;
        owners[2] = OWNER_ID3;
        owners[3] = OWNER_ID4;
        owners[4] = OWNER_ID5;

        // call function under test
        uint256 gasPre = gasleft();
        idReg.generateIds(NUM_IDS, owners);
        console.log("generateIds() cost %d gas", gasPre - gasleft());

        // validate expected storage changes
        //
        // next id should be one greater than last created
        assertEq(idReg.nextId(), NUM_IDS + 1);

        // id should always start at 1; ID 0 should be invalid
        assertEq(idReg.idToOwner(0), address(0));
        
        // valid ids correctly set
        assertEq(idReg.idToOwner(1), OWNER_ID1);
        assertEq(idReg.idToOwner(2), OWNER_ID2);
        assertEq(idReg.idToOwner(3), OWNER_ID3);
        assertEq(idReg.idToOwner(4), OWNER_ID4);
        assertEq(idReg.idToOwner(5), OWNER_ID5);
    }

    function test_resetId() external {
        // setup the ids
        test_generateIds();

        // call function under test
        uint256 gasPre = gasleft();
        idReg.resetId(1);
        console.log("resetId() cost %d gas", gasPre - gasleft());

        // verify it was reset
        assertEq(idReg.idToOwner(1), address(0));
    }

    function test_getOwnersForIds() external {
        // setup the ids
        test_generateIds();

        // prepare input
        uint256[] memory ids = new uint256[](NUM_IDS);
        ids[0] = 1;
        ids[1] = 2;
        ids[2] = 3;
        ids[3] = 4;
        ids[4] = 5;

        // call function under test
        uint256 gasPre = gasleft();
        address[] memory owners = idReg.getOwnersForIds(ids);
        console.log("getOwnersForIds() cost %d gas", gasPre - gasleft());

        // verify correct owners returned
        assertEq(owners[0], OWNER_ID1);
        assertEq(owners[1], OWNER_ID2);
        assertEq(owners[2], OWNER_ID3);
        assertEq(owners[3], OWNER_ID4);
        assertEq(owners[4], OWNER_ID5);
    }
}
