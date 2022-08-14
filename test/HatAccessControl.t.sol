// SPDX-License-Identifier: CC0
pragma solidity >=0.8.0;

import "./HatsAuthTestSetup.sol";
import "./mocks/MockHatsAccessControlled.sol";

contract HatsAccessControlTest is HatsAuthTestSetup {
    MockHatsAccessControlled mockHAC;

    uint256 roleHat;
    uint256 newRoleHat;
    uint256 otherRoleHat;
    uint256 newOtherRoleHat;

    function setUp() public override {
        super.setUp();

        mockHAC = new MockHatsAccessControlled(ownerHat, hatsAddress);
    }

    //// Default admin

    // deploy admin hat is set up correctly
    function testDeploy() public {
        mockIsWearerCall(ownerHat, true);

        assertEq(mockHAC.hatsContract(), hatsAddress);

        assertTrue(mockHAC.hasRole(0x00, address(this)));
    }

    // deploy hats contract is set up correctly

    // other role's admin is the default admin role

    // default admin role's admin is itself

    //// Granting

    // non-admin can't grant roles to other hats

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
