// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDevWallets {
    /**
     * Addresses.
     */
    function addresses() external view returns (address[] memory);
}
