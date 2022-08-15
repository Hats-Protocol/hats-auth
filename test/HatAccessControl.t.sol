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
        vm.expectRevert(abi.encodeWithSelector(NotWearingRoleHat.selector));

        mockHAC.grantRole(ROLE, roleHat);
    }

    // a single role can't be granted to more than one hat at a time

    //// Revoking

    // empty roles can't be revoked

    // admin can revoke a non-empty role

    //// Setting Role Admin

    // role admin can be changed

    // new admin can grant the role

    // new admin can revoke the role

    //// onlyOwner modifier

    // does not revert if sender has role

    // reverts if sender doesn't have role

    //// Changing Hats Contract

    // admin can set new contract

    // non-admin cannot set new contract
}
