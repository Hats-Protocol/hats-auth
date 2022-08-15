// SPDX-License-Identifier: CC0
pragma solidity >=0.8.0;

import {HatsAuthTestSetup, HatsAccessControlTestObjects} from "./HatsAuthTestSetup.sol";
import "./mocks/MockHatsAccessControlled.sol";

contract HatsAccessControlTest is
    HatsAuthTestSetup,
    HatsAccessControlTestObjects
{
    MockHatsAccessControlled mockHAC;

    uint256 roleHat;
    uint256 newRoleHat;

    uint256 otherRoleHat;
    uint256 newOtherRoleHat;

    bytes32 constant ROLE = keccak256("ROLE");
    bytes32 constant OTHER_ROLE = keccak256("OTHER_ROLE");
    bytes32 constant DEFAULT_ADMIN = 0x00;

    function setUp() public override {
        super.setUp();

        mockHAC = new MockHatsAccessControlled(ownerHat, hatsAddress);
    }

    //// Default admin

    function testDeploy() public {
        mockIsWearerCall(ownerHat, true);

        assertEq(mockHAC.hatsContract(), hatsAddress);

        assertTrue(mockHAC.hasRole(DEFAULT_ADMIN, address(this)));
    }

    function testRoleAdminsStartAsDefault() public {
        // other role's admin is the default admin role
        assertEq(mockHAC.getRoleAdmin(ROLE), DEFAULT_ADMIN);
        assertEq(mockHAC.getRoleAdmin(OTHER_ROLE), DEFAULT_ADMIN);
    }

    function testDefaultAdminIsOwnAdmin() public {
        // default admin role's admin is itself
        assertEq(mockHAC.getRoleAdmin(DEFAULT_ADMIN), DEFAULT_ADMIN);
    }

    //// Granting

    function testNonAdminCantGrantRoles() public {
        // non-admin can't grant roles to other hats
        mockIsWearerCall(ownerHat, false);

        // expect revert
        vm.expectRevert(
            abi.encodeWithSignature(
                "NotWearingRoleHat(bytes32,uint256,address)",
                DEFAULT_ADMIN,
                ownerHat,
                address(this)
            )
        );

        mockHAC.grantRole(ROLE, roleHat);
    }

    function testAdminCanGrantRole() public {
        roleHat = uint256(1);

        mockIsWearerCall(ownerHat, true);

        vm.expectEmit(true, true, true, true);
        emit RoleGranted(ROLE, roleHat, address(this));

        mockHAC.grantRole(ROLE, roleHat);

        assertEq(mockHAC.getRoleAdmin(ROLE), DEFAULT_ADMIN);
    }

    // a single role can't be granted to more than one hat at a time

    function testAdminCantGrantRoleTwice() public {
        roleHat = uint256(1);
        otherRoleHat = uint256(2);

        mockIsWearerCall(ownerHat, true);

        mockHAC.grantRole(ROLE, roleHat);

        vm.expectRevert(
            abi.encodeWithSignature(
                "RoleAlreadyAssigned(bytes32,uint256)",
                ROLE,
                roleHat
            )
        );

        mockHAC.grantRole(ROLE, otherRoleHat);
    }

    //// Revoking

    function testEmptyRoleCantBeRevoked() public {
        roleHat = uint256(1);

        // empty roles can't be revoked
        mockIsWearerCall(ownerHat, true);

        mockHAC.revokeRole(ROLE, roleHat);
    }

    function testAdminCanRevokeAssignedRole() public {
        roleHat = uint256(1);

        // admin can revoke a non-empty role
        mockIsWearerCall(ownerHat, true);

        mockHAC.grantRole(ROLE, roleHat);

        vm.expectEmit(true, true, true, true);
        emit RoleRevoked(ROLE, roleHat, address(this));

        mockHAC.revokeRole(ROLE, roleHat);

        mockIsWearerCall(roleHat, true);

        vm.expectRevert();
        mockHAC.hasRole(ROLE, address(this));
    }

    //// Setting Role Admin

    // role admin can be changed
    function testChangeAdminRole() public {
        mockIsWearerCall(ownerHat, true);
        // first, grant a role
        roleHat = uint256(1);
        mockHAC.grantRole(ROLE, roleHat);

        // change admin for second role to first role
        vm.expectEmit(true, true, true, true);
        emit RoleAdminChanged(OTHER_ROLE, DEFAULT_ADMIN, ROLE);

        mockHAC.setRoleAdmin(OTHER_ROLE, ROLE);

        assertEq(mockHAC.getRoleAdmin(OTHER_ROLE), ROLE);
    }

    // new admin can grant the role
    function testNewAdminCanGrantRole() public {
        // first, grant the first role
        mockIsWearerCall(ownerHat, true);

        roleHat = uint256(1);
        mockHAC.grantRole(ROLE, roleHat);

        // then, change the role admin
        mockHAC.setRoleAdmin(OTHER_ROLE, ROLE);

        // now grant the second role from the new admin
        otherRoleHat = uint256(2);

        mockIsWearerCall(roleHat, true);

        vm.expectEmit(true, true, true, true);
        emit RoleGranted(OTHER_ROLE, otherRoleHat, address(this));

        mockHAC.grantRole(OTHER_ROLE, otherRoleHat);
    }

    // new admin can revoke the role
    function testNewAdminCanRevokeRole() public {
        // first, grant the first role
        mockIsWearerCall(ownerHat, true);

        roleHat = uint256(1);
        mockHAC.grantRole(ROLE, roleHat);

        // then, change the role admin
        mockHAC.setRoleAdmin(OTHER_ROLE, ROLE);

        // then, grant the second role from the new admin
        otherRoleHat = uint256(2);

        mockIsWearerCall(roleHat, true);
        mockHAC.grantRole(OTHER_ROLE, otherRoleHat);

        // now, revoke the second role
        vm.expectEmit(true, true, true, true);
        emit RoleRevoked(OTHER_ROLE, otherRoleHat, address(this));

        mockHAC.revokeRole(OTHER_ROLE, otherRoleHat);
    }

    //// onlyOwner modifier

    // does not revert if sender has role
    function testOnlyModifierCall() public {
        mockIsWearerCall(ownerHat, true);

        mockHAC.senderProtected(DEFAULT_ADMIN);
    }

    // reverts if sender doesn't have role
    function testOnlyModifierCallRevert() public {
        mockIsWearerCall(ownerHat, false);

        // expect revert
        vm.expectRevert(
            abi.encodeWithSignature(
                "NotWearingRoleHat(bytes32,uint256,address)",
                DEFAULT_ADMIN,
                ownerHat,
                address(this)
            )
        );

        mockHAC.senderProtected(DEFAULT_ADMIN);
    }

    //// Changing Hats Contract

    // admin can set new contract
    function testAdminCanSetNewHatsContract() public {
        newHatsAddress = address(0x4a152);

        mockIsWearerCall(ownerHat, true);

        mockHAC.changeHatsContract(newHatsAddress);

        assertEq(mockHAC.hatsContract(), newHatsAddress);
    }

    // non-admin cannot set new contract
    function testNonAdminCannotSetNewHatsContract() public {
        newHatsAddress = address(0x4a152);

        mockIsWearerCall(ownerHat, false);

        // expect revert
        vm.expectRevert(
            abi.encodeWithSignature(
                "NotWearingRoleHat(bytes32,uint256,address)",
                DEFAULT_ADMIN,
                ownerHat,
                address(this)
            )
        );

        mockHAC.changeHatsContract(newHatsAddress);
    }

    //// Change Role Hat

    // admin can change role hat
    function testAdminCanChangeRoleHat() public {
        roleHat = uint256(1);
        otherRoleHat = uint256(2);

        mockIsWearerCall(ownerHat, true);

        mockHAC.grantRole(ROLE, roleHat);

        vm.expectEmit(true, true, true, true);
        emit RoleHatChanged(ROLE, roleHat, otherRoleHat);

        mockHAC.changeRoleHat(ROLE, otherRoleHat);
    }

    // non-admin cannot change role hat
    function testAdminCannotChangeRoleHat() public {
        roleHat = uint256(1);
        otherRoleHat = uint256(2);

        mockIsWearerCall(ownerHat, true);

        mockHAC.grantRole(ROLE, roleHat);

        mockIsWearerCall(ownerHat, false);
        vm.expectRevert(
            abi.encodeWithSignature(
                "NotWearingRoleHat(bytes32,uint256,address)",
                DEFAULT_ADMIN,
                ownerHat,
                address(this)
            )
        );

        mockHAC.changeRoleHat(ROLE, otherRoleHat);
    }
}
