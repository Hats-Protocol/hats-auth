// SPDX-License-Identifier: CC0
pragma solidity >=0.8.0;

import "forge-std/Test.sol";

contract HatsAuthTestSetup is Test {
    address hatsAddress;
    address newHatsAddress;
    uint256 ownerHat;
    uint256 newOwnerHat;

    function mockIsWearerCall(uint256 hat, bool result) public {
        bytes memory data = abi.encodeWithSignature(
            "isWearerOfHat(address,uint256)",
            address(this),
            hat
        );
        vm.mockCall(hatsAddress, data, abi.encode(result));
    }

    function setUp() public virtual {
        hatsAddress = address(0x4a15);
        ownerHat = uint256(1);
    }
}
