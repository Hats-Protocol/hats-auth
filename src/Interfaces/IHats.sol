// SPDX-License-Identifier: CC0
pragma solidity >=0.8.13;

interface IHats {
    function isWearerOfHat(address _user, uint256 _hatId)
        external
        view
        returns (bool);
}
