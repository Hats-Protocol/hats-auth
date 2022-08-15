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

contract HatsOwnedTestObjects {
    event OwnerHatUpdated(
        uint256 indexed ownerHat,
        address indexed hatsContract
    );
}

contract HatsAccessControlTestObjects {
    error NotWearingRoleHat(bytes32 role, uint256 hat, address account);

    event RoleGranted(
        bytes32 indexed role,
        uint256 indexed hat,
        address indexed sender
    );

    event RoleRevoked(
        bytes32 indexed role,
        uint256 indexed hat,
        address indexed sender
    );

    event RoleAdminChanged(
        bytes32 indexed role,
        bytes32 indexed previousAdminRole,
        bytes32 indexed newAdminRole
    );

    event HatsContractChanged(
        address previousHatsContract,
        address newHatsContract
    );

    event RoleHatChanged(
        bytes32 indexed role,
        uint256 indexed previousRoleHat,
        uint256 indexed newRoleHat
    );
}
