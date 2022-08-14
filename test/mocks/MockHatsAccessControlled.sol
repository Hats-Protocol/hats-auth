// SPDX-License-Identifier: CC0
pragma solidity >=0.8.0;

import {HatsAccessControl} from "../../src/HatsAccessControl.sol";
import "forge-std/Test.sol";

contract MockHatsAccessControlled is HatsAccessControl {
    constructor(uint256 adminHat, address hatsContract) {
        _changeHatsContract(hatsContract);

        _grantRole(DEFAULT_ADMIN_ROLE, adminHat);
    }

    function setRoleAdmin(bytes32 roleId, bytes32 adminRoleId) public {
        _setRoleAdmin(roleId, adminRoleId);
    }

    function senderProtected(bytes32 roleId) public onlyRole(roleId) {}
}
