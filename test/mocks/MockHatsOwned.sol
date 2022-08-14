// SPDX-License-Identifier: CC0
pragma solidity >=0.8.0;

import {HatsOwned} from "../../src/HatsOwned.sol";

contract MockHatsOwned is HatsOwned {
    bool public flag;

    constructor(uint256 ownerHat, address hatsContract)
        HatsOwned(ownerHat, hatsContract)
    {}

    function updateFlag() public virtual onlyOwner {
        flag = true;
    }
}
