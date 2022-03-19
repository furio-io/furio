// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Furio Address Book
 * @author Steve Harmeyer
 * @notice This contract stores the list of important addresses in
 * the Furio ecosystem.
 */
contract AddressBook is Ownable {
    /**
     * Dev wallets.
     * @dev Internal storage for dev wallets.
     */
    address[] internal _devWallets;

    /**
     * Payment token.
     * @notice Payment token address.
     */
    address public paymentToken;

    /**
     * Fur token.
     * @notice $FUR token address.
     */
    address public furToken;

    /**
     * FurSwap.
     * @notice FurSwap address.
     */
    address public furSwap;

    /**
     * FurVault.
     * @notice FurVault address.
     */
    address public furVault;

    /**
     * FurPool.
     * @notice FurPool address.
     */
    address public furPool;

    /**
     * Add dev wallet.
     * @notice Adds an address to the list of dev wallets.
     */
    function addDevWallet(address address_) external onlyOwner {
        require(!isDevWallet(address_), "Address already exists");
        _devWallets.push(address_);
    }

    /**
     * Dev wallets.
     * @notice List all dev wallets.
     */
    function devWallets() external view returns (address[] memory) {
        return _devWallets;
    }

    /**
     * Dev count.
     * @notice Returns the number of dev wallets.
     */
    function devCount() external view returns (uint256) {
        return _devWallets.length;
    }

    /**
     * Is dev wallet.
     * @notice Returns true if address is a dev wallet.
     */
    function isDevWallet(address address_) public view returns (bool) {
        bool exists = false;
        for(uint i = 0; i < _devWallets.length; i ++) {
            if(_devWallets[i] == address_) {
                exists = true;
            }
        }
        return exists;
    }

    /**
     * Set payment token.
     * @notice Sets the address for the payment token (USDC).
     */
    function setPaymentToken(address address_) external onlyOwner {
        require(paymentToken == address(0), "Payment token already set");
        paymentToken = address_;
    }

    /**
     * Set Fur token.
     * @notice Sets the address for $FUR token.
     */
    function setFurToken(address address_) external onlyOwner {
        require(furToken == address(0), "Fur token already set");
        furToken = address_;
    }

    /**
     * Set FurSwap.
     * @notice Sets the address for FurSwap.
     */
    function setFurSwap(address address_) external onlyOwner {
        require(furSwap == address(0), "FurSwap already set");
        furSwap = address_;
    }

    /**
     * Set FurVault.
     * @notice Sets the address for FurVault.
     */
    function setFurVault(address address_) external onlyOwner {
        require(furVault == address(0), "FurVault already set");
        furVault = address_;
    }

    /**
     * Set FurPool.
     * @notice Sets the address for FurPool.
     */
    function setFurPool(address address_) external onlyOwner {
        require(furPool == address(0), "FurPool already set");
        furPool = address_;
    }
}
