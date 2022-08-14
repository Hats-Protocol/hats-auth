// SPDX-License-Identifier: CC0
pragma solidity >=0.8.0;

import "forge-std/Test.sol";
import "./mocks/MockHatsOwned.sol";

// import "../src/Interfaces/IHats.sol";

contract HatsOwnedTest is Test {
    MockHatsOwned mockHatsOwned;
    address hatsAddress;
    address newHatsAddress;
    uint256 ownerHat;
    uint256 nonOwnerHat;
    uint256 newOwnerHat;

    bytes mockIsWearerCall;

    event OwnerHatUpdated(
        uint256 indexed ownerHat,
        address indexed hatsContract
    );

    function encodeIsWearerCall(uint256 hatId)
        public
        view
        returns (bytes memory)
    {
        return
            abi.encodeWithSignature(
                "isWearerOfHat(address,uint256)",
                address(this),
                hatId
            );
    }

    function setUp() public {
        hatsAddress = address(0x4a15);
        ownerHat = uint256(1);

        mockHatsOwned = new MockHatsOwned(ownerHat, hatsAddress);
    }

    function testDeploy() public {
        // vm.expectEmit(true, true, false, true);
        // emit OwnerHatUpdated(ownerHat, hatsAddress);

        mockHatsOwned = new MockHatsOwned(ownerHat, hatsAddress);

        assertEq(mockHatsOwned.ownerHat(), ownerHat);
        assertEq(mockHatsOwned.getHatsContract(), hatsAddress);
    }

    function testSetOwnerHat() public {
        newOwnerHat = uint256(2);

        // encode mock call to hats.isWearerOfHat() inside of onlyOwner modifier
        mockIsWearerCall = encodeIsWearerCall(ownerHat);
        vm.mockCall(hatsAddress, mockIsWearerCall, abi.encode(true));

        vm.expectEmit(true, true, false, true);
        emit OwnerHatUpdated(newOwnerHat, hatsAddress);

        mockHatsOwned.setOwnerHat(newOwnerHat, hatsAddress);

        assertEq(mockHatsOwned.ownerHat(), newOwnerHat);
        assertEq(mockHatsOwned.getHatsContract(), hatsAddress);
    }

    function testSetHatsContract() public {
        newHatsAddress = address(0x4a152);

        // encode mock call to hats.isWearerOfHat() inside of onlyOwner modifier
        mockIsWearerCall = encodeIsWearerCall(ownerHat);
        vm.mockCall(hatsAddress, mockIsWearerCall, abi.encode(true));

        vm.expectEmit(true, true, false, true);
        emit OwnerHatUpdated(ownerHat, newHatsAddress);

        mockHatsOwned.setOwnerHat(ownerHat, newHatsAddress);

        assertEq(mockHatsOwned.ownerHat(), ownerHat);
        assertEq(mockHatsOwned.getHatsContract(), newHatsAddress);
    }

    function testSetHatsContractAndOwnerHat() public {
        newOwnerHat = uint256(2);
        newHatsAddress = address(0x4a152);

        // encode mock call to hats.isWearerOfHat() inside of onlyOwner modifier
        mockIsWearerCall = encodeIsWearerCall(ownerHat);
        vm.mockCall(hatsAddress, mockIsWearerCall, abi.encode(true));

        vm.expectEmit(true, true, false, true);
        emit OwnerHatUpdated(newOwnerHat, newHatsAddress);

        mockHatsOwned.setOwnerHat(newOwnerHat, newHatsAddress);

        assertEq(mockHatsOwned.ownerHat(), newOwnerHat);
        assertEq(mockHatsOwned.getHatsContract(), newHatsAddress);
    }

    function testSetOwnerNoChanges() public {
        // encode mock call to hats.isWearerOfHat() inside of onlyOwner modifier
        mockIsWearerCall = encodeIsWearerCall(ownerHat);
        vm.mockCall(hatsAddress, mockIsWearerCall, abi.encode(true));

        vm.expectRevert("NO CHANGES");

        mockHatsOwned.setOwnerHat(ownerHat, hatsAddress);
    }

    function testCallFunctionAsOwner() public {
        // encode mock call to hats.isWearerOfHat() inside of onlyOwner modifier
        mockIsWearerCall = encodeIsWearerCall(ownerHat);
        vm.mockCall(hatsAddress, mockIsWearerCall, abi.encode(true));

        mockHatsOwned.updateFlag();
    }

    function testCallFunctionAsNonOwner() public {
        // encode mock call to hats.isWearerOfHat() inside of onlyOwner modifier
        mockIsWearerCall = encodeIsWearerCall(ownerHat);
        vm.mockCall(hatsAddress, mockIsWearerCall, abi.encode(false));

        vm.expectRevert("UNAUTHORIZED");
        mockHatsOwned.updateFlag();
    }
}
