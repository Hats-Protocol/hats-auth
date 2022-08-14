# hats-auth

[Hats Protocol](https://github.com/Hats-Protocol/hats-protocol)-enabled auth and ownable contract mix-ins

## HatsOwned

A fork of [solmate's `Owned.sol`](https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol) that grants ownership of an inheriting contract to the wearer of a given [hat](https://github.com/Hats-Protocol/hats-protocol).

`HatsOwned.sol` preserves the name of the `onlyOwner` modifier, so switching from `Owned.sol` only requires inhereting the new contract and adjusting the constructor to set `uint256 ownerHat` rather than `address owner`. No other code changes required.

## HatsOwnable

A (not yet implemented) fork of OpenZeppelin's `Ownable.sol` that grants ownership of an inheriting contract to the wearer of a given [hat](https://github.com/Hats-Protocol/hats-protocol).

 TODO

- [ ] contracts
- [ ] tests

## HatsAccessControl

A fork of OpenZeppelin's `AccessControl.sol` that grants access to various roles within an inheriting contract to the wearer of given [hats](https://github.com/Hats-Protocol/hats-protocol).

### Differences compared to `AccessControl.sol`

1. Assigns roles to `uint256 hat` rather than `address member`.

2. Since a single hat can have multiple wearers (up to [`hat.maxSupply`](https://github.com/Hats-Protocol/hats-protocol#hats-logic), only a single hat can be granted a given role.

3. No support for `renounceRole`. To renounce a role, the wearer of a given hat should renounce the hat itself.

TODO

- [x] contracts
- [ ] tests
