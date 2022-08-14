// SPDX-License-Identifier: CC0
pragma solidity >=0.8.13;

import "./Interfaces/IHats.sol";

/// @notice Single owner authorization mixin using Hats Protocol
/// @dev Forked from solmate (https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol)
/// @author Hats Protocol
abstract contract HatsOwned {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event OwnerHatUpdated(
        uint256 indexed ownerHat,
        address indexed hatsContract
    );

    /*//////////////////////////////////////////////////////////////
                            OWNERSHIP STORAGE
    //////////////////////////////////////////////////////////////*/

    IHats internal hatsContract;
    uint256 public ownerHat;

    modifier onlyOwner() virtual {
        require(
            hatsContract.isWearerOfHat(msg.sender, ownerHat),
            "UNAUTHORIZED"
        );

        _;
    }

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(uint256 _ownerHat, address _hatsContract) {
        ownerHat = _ownerHat;
        hatsContract = IHats(_hatsContract);

        emit OwnerHatUpdated(_ownerHat, _hatsContract);
    }

    /*//////////////////////////////////////////////////////////////
                             OWNERSHIP LOGIC
    //////////////////////////////////////////////////////////////*/

    function setOwnerHat(uint256 _ownerHat, address _hatsContract)
        public
        virtual
        onlyOwner
    {
        uint256 changes;

        if (ownerHat != _ownerHat) {
            ownerHat = _ownerHat;
            // max of 2, so will never overflow
            unchecked {
                ++changes;
            }
        }

        IHats hats = IHats(_hatsContract);

        if (hatsContract != hats) {
            hatsContract = hats;
            // max of 2, so will never overflow
            unchecked {
                ++changes;
            }
        }

        require(changes > 0, "NO CHANGES");

        emit OwnerHatUpdated(_ownerHat, _hatsContract);
    }

    /*//////////////////////////////////////////////////////////////
                            VIEW FUNCTIONs
    //////////////////////////////////////////////////////////////*/

    function getHatsContract() public view returns (address) {
        return address(hatsContract);
    }
}
