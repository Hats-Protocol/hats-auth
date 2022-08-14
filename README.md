# hats-auth

[Hats Protocol](https://github.com/Hats-Protocol/hats-protocol)-enabled auth and ownable contract mix-ins

## HatsOwned

A fork of [solmate's `Owned.sol`](https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol) that grants ownership of an inhereting contract to the wearer of a given [hat](https://github.com/Hats-Protocol/hats-protocol).

`HatsOwned.sol` preserves the name of the `onlyOwner` modifier, so switching from `Owned.sol` only requires inhereting the new contract. No other code changes required.

## HatsOwnable

TODO

A (not yet implemented) fork of OpenZeppelin's `Ownable.sol` that grants ownership of an inhereting contract to the wearer of a given [hat](https://github.com/Hats-Protocol/hats-protocol).

## HatsAccessControl

TODO

A (not yet implemented) fork of OpenZeppelin's `AccessControl.sol` that grants access to various roles within an inhereting contract to the wearer of given [hats](https://github.com/Hats-Protocol/hats-protocol).
