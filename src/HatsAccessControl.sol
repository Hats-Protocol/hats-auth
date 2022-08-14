// SPDX-License-Identifier: CC0
pragma solidity >=0.8.13;

import "@openzeppelin/contracts/utils/Context.sol";
import "./Interfaces/IHats.sol";

/**
 * @notice forked from OpeZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControl.sol)
 * @author Hats Protocol
 * @dev Contract module that allows children to implement role-based access
 * control mechanisms. This is a lightweight version that doesn't allow enumerating role
 * members except through off-chain means by accessing the contract event logs. Some
 * applications may benefit from on-chain enumerability, for those cases see
 * {AccessControlEnumerable}.
 *
 * Roles are referred to by their `bytes32` identifier. These should be exposed
 * in the external API and be unique. The best way to achieve this is by
 * using `public constant` hash digests:
 *
 * ```
 * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
 * ```
 *
 * Roles can be used to represent a set of permissions. To restrict access to a
 * function call, use {hasRole}:
 *
 * ```
 * function foo() public {
 *     require(hasRole(MY_ROLE, msg.sender));
 *     ...
 * }
 * ```
 *
 * Roles can be granted and revoked dynamically via the {grantRole} and
 * {revokeRole} functions. Each role has an associated admin role, and only
 * accounts that wear a role's admin hat {grantRole} and {revokeRole}.
 *
 * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
 * that only accounts wearing this hat's role will be able to grant or revoke other
 * roles. More complex role relationships can be created by using
 * {_setRoleAdmin}.
 *
 * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
 * grant and revoke this role. Extra precautions should be taken to secure
 * accounts that have been granted it.
 */
abstract contract HatsAccessControl is Context {
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

    IHats internal HATS;

    mapping(bytes32 => uint256) private _roleHats;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    /**
     * @dev Modifier that checks that an account has a specific role. Reverts
     * with a standardized message including the required role.
     */
    modifier onlyRole(bytes32 role) {
        _checkRole(role);
        _;
    }

    /**
     * @dev Returns `true` if `account` has been granted `role`,
     * based on the account wearing the correct hat.
     */
    function hasRole(bytes32 role, address account)
        public
        view
        virtual
        returns (bool)
    {
        return HATS.isWearerOfHat(account, _roleHats[role]);
    }

    /**
     * @dev Revert with a standard message if `_msgSender()` is missing `role`.
     * Overriding this function changes the behavior of the {onlyRole} modifier.
     *
     * Format of the revert message is described in {_checkRole}.
     *
     * _Available since v4.6._
     */
    function _checkRole(bytes32 role) internal view virtual {
        _checkRole(role, _msgSender());
    }

    /**
     * @dev Revert `account` is missing `role`.
     */
    function _checkRole(bytes32 role, address account) internal view virtual {
        if (!hasRole(role, account)) {
            revert NotWearingRoleHat(role, _roleHats[role], account);
        }
    }

    /**
     * @dev Grants `role` to `hat`.
     *
     * If `hat` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must wear ``role``'s hat's admin hat.
     *
     * May emit a {RoleGranted} event.
     */
    function grantRole(bytes32 role, uint256 hat) public virtual {
        address account = _msgSender();
        if (!HATS.isAdminOfHat(account, hat)) {
            revert NotWearingRoleHat(role, hat, account);
        }
        _grantRole(role, hat);
    }

    /**
     * @dev Revokes `role` from `hat`.
     *
     * If `hat` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must wear ``role``'s hat's admin hat.
     */
    function revokeRole(bytes32 role, uint256 hat) public virtual {
        address account = _msgSender();
        if (!HATS.isAdminOfHat(account, hat)) {
            revert NotWearingRoleHat(role, hat, account);
        }
        _revokeRole(role, hat);
    }

    /**
     * @dev Grants `role` to `hat`.
     *
     * Internal function without access restriction.
     */
    function _grantRole(bytes32 role, uint256 hat) internal virtual {
        if (_roleHats[role] != hat) {
            _roleHats[role] = hat;
            emit RoleGranted(role, hat, _msgSender());
        }
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * Internal function without access restriction.
     */
    function _revokeRole(bytes32 role, uint256 hat) internal virtual {
        if (_roleHats[role] == hat) {
            _roleHats[role] = 0;
            emit RoleRevoked(role, hat, _msgSender());
        }
    }
}
