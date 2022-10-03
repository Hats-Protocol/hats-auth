// SPDX-License-Identifier: CC0
pragma solidity >=0.8.0;

import {HatsOwnedInitializable} from "../../src/HatsOwnedInitializable.sol";

contract MockHatsOwnedInitializable is HatsOwnedInitializable {
    bool public flag;

    // constructor(uint256 ownerHat, address hatsContract)
    //     HatsOwned(ownerHat, hatsContract)
    // {}

    function setUp(uint256 _ownerHat, address _hatsContract)
        public
        initializer
    {
        _HatsOwned_init(_ownerHat, _hatsContract);
    }

    function updateFlag() public virtual onlyOwner {
        flag = true;
    }
}
