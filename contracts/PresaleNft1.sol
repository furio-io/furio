// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract PresaleNft1 is ERC721PresetMinterPauserAutoId
{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdTracker;

    /**
     * USDC coin on polygon.
     */
    IERC20 public paymentToken = IERC20(0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174);

    /**
     * Start time... midnight GMT 4/19/2022.
     */
    uint256 public startTime = 1650398400;

    /**
     * Max each address can hold.
     */
    uint256 public maxPerAddress = 1;

    /**
     * Purchase price.
     */
    uint256 public price = 250e6;

    /**
     * Max supply.
     */
    uint256 public maxSupply = 300;

    /**
     * Purchased.
     */
    mapping(address => uint256) public purchased;

    /**
     * Constructor.
     */
    constructor() ERC721PresetMinterPauserAutoId(
        'Furio Presale NFT Group 1',
        '$FURPRESALE1',
        'ipfs://QmSZhsoYWeb9gCXAaGDe7vs9AVFPxr5nn2GWxicBKKouui/'
    ) {}

    /**
     * Buy an NFT.
     */
    function buy(uint256 _quantity) external
    {
        require(_tokenIdTracker.current() < maxSupply, "Sold out");
        require(purchased[msg.sender] + _quantity < maxPerAddress, "Already purchased maximum amount");
        require(paymentToken.transferFrom(msg.sender, address(this), price * _quantity), "Payment transfer failed");
        for(uint256 i = 1; i <= _quantity; i ++) {
            _tokenIdTracker.increment();
            _mint(msg.sender, _tokenIdTracker.current());
        }
    }
}
