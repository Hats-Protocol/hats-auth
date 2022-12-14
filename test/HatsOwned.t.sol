// SPDX-License-Identifier: CC0
pragma solidity >=0.8.0;

import "./mocks/MockHatsOwned.sol";
import "./mocks/MockHatsOwnedInitializable.sol";
import {HatsAuthTestSetup, HatsOwnedTestObjects} from "./HatsAuthTestSetup.sol";

// import "../src/Interfaces/IHats.sol";

contract HatsOwnedTest is HatsAuthTestSetup, HatsOwnedTestObjects {
    MockHatsOwned mockHatsOwned;

    function setUp() public override {
        super.setUp();

        mockHatsOwned = new MockHatsOwned(ownerHat, hatsAddress);
    }

    function testDeploy() public {
        vm.expectEmit(true, true, false, true);
        emit OwnerHatUpdated(ownerHat, hatsAddress);

        mockHatsOwned = new MockHatsOwned(ownerHat, hatsAddress);

        assertEq(mockHatsOwned.ownerHat(), ownerHat);
        assertEq(mockHatsOwned.getHatsContract(), hatsAddress);
    }

    function testSetOwnerHat() public {
        newOwnerHat = uint256(2);

        mockIsWearerCall(ownerHat, true);

        vm.expectEmit(true, true, false, true);
        emit OwnerHatUpdated(newOwnerHat, hatsAddress);

        mockHatsOwned.setOwnerHat(newOwnerHat, hatsAddress);

        assertEq(mockHatsOwned.ownerHat(), newOwnerHat);
        assertEq(mockHatsOwned.getHatsContract(), hatsAddress);
    }

    function testSetHatsContract() public {
        newHatsAddress = address(0x4a152);

        mockIsWearerCall(ownerHat, true);

        vm.expectEmit(true, true, false, true);
        emit OwnerHatUpdated(ownerHat, newHatsAddress);

        mockHatsOwned.setOwnerHat(ownerHat, newHatsAddress);

        assertEq(mockHatsOwned.ownerHat(), ownerHat);
        assertEq(mockHatsOwned.getHatsContract(), newHatsAddress);
    }

    function testSetHatsContractAndOwnerHat() public {
        newOwnerHat = uint256(2);
        newHatsAddress = address(0x4a152);

        mockIsWearerCall(ownerHat, true);

        vm.expectEmit(true, true, false, true);
        emit OwnerHatUpdated(newOwnerHat, newHatsAddress);

        mockHatsOwned.setOwnerHat(newOwnerHat, newHatsAddress);

        assertEq(mockHatsOwned.ownerHat(), newOwnerHat);
        assertEq(mockHatsOwned.getHatsContract(), newHatsAddress);
    }

    function testSetOwnerNoChanges() public {
        mockIsWearerCall(ownerHat, true);

        vm.expectRevert("NO CHANGES");

        mockHatsOwned.setOwnerHat(ownerHat, hatsAddress);
    }

    function testCallFunctionAsOwner() public {
        mockIsWearerCall(ownerHat, true);

        mockHatsOwned.updateFlag();
    }

    function testCallFunctionAsNonOwner() public {
        mockIsWearerCall(ownerHat, false);

        vm.expectRevert("UNAUTHORIZED");
        mockHatsOwned.updateFlag();
    }
}

contract HatsOwnedInitializableTest is HatsAuthTestSetup, HatsOwnedTestObjects {
    MockHatsOwnedInitializable mockHatsOwned;

    function setUp() public override {
        super.setUp();

        mockHatsOwned = new MockHatsOwnedInitializable();

        mockHatsOwned.setUp(ownerHat, hatsAddress);
    }

    function testDeploy() public {
        vm.expectEmit(true, true, false, true);
        emit OwnerHatUpdated(ownerHat, hatsAddress);

        mockHatsOwned = new MockHatsOwnedInitializable();

        mockHatsOwned.setUp(ownerHat, hatsAddress);

        assertEq(mockHatsOwned.ownerHat(), ownerHat);
        assertEq(mockHatsOwned.getHatsContract(), hatsAddress);
    }

    function testCantSetupTwice() public {
        vm.expectRevert("Initializable: contract is already initialized");

        mockHatsOwned.setUp(ownerHat + 1, address(0x1));
    }

    function testSetOwnerHat() public {
        newOwnerHat = uint256(2);

        mockIsWearerCall(ownerHat, true);

        vm.expectEmit(true, true, false, true);
        emit OwnerHatUpdated(newOwnerHat, hatsAddress);

        mockHatsOwned.setOwnerHat(newOwnerHat, hatsAddress);

        assertEq(mockHatsOwned.ownerHat(), newOwnerHat);
        assertEq(mockHatsOwned.getHatsContract(), hatsAddress);
    }

    function testSetHatsContract() public {
        newHatsAddress = address(0x4a152);

        mockIsWearerCall(ownerHat, true);

        vm.expectEmit(true, true, false, true);
        emit OwnerHatUpdated(ownerHat, newHatsAddress);

        mockHatsOwned.setOwnerHat(ownerHat, newHatsAddress);

        assertEq(mockHatsOwned.ownerHat(), ownerHat);
        assertEq(mockHatsOwned.getHatsContract(), newHatsAddress);
    }

    function testSetHatsContractAndOwnerHat() public {
        newOwnerHat = uint256(2);
        newHatsAddress = address(0x4a152);

        mockIsWearerCall(ownerHat, true);

        vm.expectEmit(true, true, false, true);
        emit OwnerHatUpdated(newOwnerHat, newHatsAddress);

        mockHatsOwned.setOwnerHat(newOwnerHat, newHatsAddress);

        assertEq(mockHatsOwned.ownerHat(), newOwnerHat);
        assertEq(mockHatsOwned.getHatsContract(), newHatsAddress);
    }

    function testSetOwnerNoChanges() public {
        mockIsWearerCall(ownerHat, true);

        vm.expectRevert("NO CHANGES");

        mockHatsOwned.setOwnerHat(ownerHat, hatsAddress);
    }

    function testCallFunctionAsOwner() public {
        mockIsWearerCall(ownerHat, true);

        mockHatsOwned.updateFlag();
    }

    function testCallFunctionAsNonOwner() public {
        mockIsWearerCall(ownerHat, false);

        vm.expectRevert("UNAUTHORIZED");
        mockHatsOwned.updateFlag();
    }
}
