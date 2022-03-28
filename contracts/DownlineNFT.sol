// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./utilities/Pausable.sol";

/**
 * @title Downline NFT
 * @author Steve Harmeyer
 * @notice This is the downline NFT contract. Users must hold 1 NFT per
 * accessable downline up to 15.
 */
contract DownlineNFT is Ownable, Pausable {

}
