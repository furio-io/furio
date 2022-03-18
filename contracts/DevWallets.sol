// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Furio DevWallets
 * @author Steve Harmeyer
 * @notice This contract stores the list of developer wallets in a public
 * place for full transparency. The contract can and will be frozen after
 * all dev wallets have been added in order to prevent future wallets from
 * being added.
 */
contract DevWallets is Ownable {
    /**
     * Wallets.
     * @dev Internal storage for dev addresses.
     */
    address[] internal _addresses;

    /**
     * Frozen.
     * @notice Whether the contract is frozen or not.
     */
    bool public frozen = false;
    event Frozen();

    /**
     * Add address.
     * @notice Adds an address to the list of dev addresses.
     */
    function addAddress(address address_) external onlyOwner {
        require(!frozen, "Dev wallets is frozen");
        require(!isDevWallet(address_), "Address already exists");
        _addresses.push(address_);
    }

    /**
     * Freeze contract.
     * @notice This is unrecoverable. Permanently prevents new addresses from
     * being added to contract.
     */
    function freeze() external onlyOwner {
        frozen = true;
        emit Frozen();
    }

    /**
     * Addresses.
     * @notice List all dev addresses.
     */
    function addresses() external view returns (address[] memory) {
        return _addresses;
    }

    /**
     * Count.
     * @notice Returns the number of dev addresses.
     */
    function count() external view returns (uint256) {
        return _addresses.length;
    }

    /**
     * Is dev wallet.
     * @notice Returns true if address is a dev wallet.
     */
     function isDevWallet(address address_) public view returns (bool) {
        bool exists = false;
        for(uint i = 0; i < _addresses.length; i ++) {
            if(_addresses[i] == address_) {
                exists = true;
            }
        }
        return exists;
     }
}
