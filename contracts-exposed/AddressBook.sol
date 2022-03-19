// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.6.0;

import "../contracts/AddressBook.sol";

contract $AddressBook is AddressBook {
    constructor() {}

    function $_devWallets() external view returns (address[] memory) {
        return _devWallets;
    }

    function $_transferOwnership(address newOwner) external {
        return super._transferOwnership(newOwner);
    }

    function $_msgSender() external view returns (address) {
        return super._msgSender();
    }

    function $_msgData() external view returns (bytes memory) {
        return super._msgData();
    }
}
