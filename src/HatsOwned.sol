// SPDX-License-Identifier: CC0
pragma solidity >=0.8.13;

import "hats-protocol/IHats.sol";
import "./HatsOwnedCommon.sol";

/// @notice Single owner authorization mixin using Hats Protocol
/// @dev For inherentence into contracts not deployed as proxies. Forked from solmate (https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol).
/// @author Hats Protocol
abstract contract HatsOwned is HatsOwnedCommon {
    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(uint256 _ownerHat, address _hatsContract) {
        ownerHat = _ownerHat;
        HATS = IHats(_hatsContract);

        emit OwnerHatUpdated(_ownerHat, _hatsContract);
    }
}
