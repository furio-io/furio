// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
// INTERFACES
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Furio NFT
 * @author Steve Harmeyer
 * @notice This is the NFT needed to access downline bonuses.
 */
contract FurioNFT is Ownable, ERC721 {
    using Counters for Counters.Counter;

    /**
     * ERC20 contract for buys and sells.
     */
    IERC20 public paymentToken;

    /**
     * Price.
     */
    uint256 public price;

    /**
     * Sales Tax.
     */
    uint256 public salesTax;

    /**
     * Token values.
     * @dev keep track of original sales price for buy backs in case price changes.
     */
    mapping(uint256 => uint256) private _tokenValues;

    /**
     * Generation struct.
     * @dev Data structure for generation info.
     */
    struct Generation {
        uint256 maxSupply;
        string description;
        string imageUri;
    }

    /**
     * Generation tracker.
     * @dev Keeps track of how many generations exist.
     */
    Counters.Counter private _generationTracker;

    /**
     * Mapping to store generation info.
     * @dev Index is the total
     */
    mapping(uint256 => Generation) private _generations;

    /**
     * Token id tracker.
     * @dev Keeps track of the current token id.
     */
    Counters.Counter private _tokenIdTracker;

    /**
     * Contract constructor.
     */
    constructor(
        string memory name_,
        string memory symbol_,
        string memory description_,
        string memory imageUri_,
        uint256 maxSupply_,
        uint256 price_,
        uint256 salesTax_,
        address tokenAddress_
    ) ERC721(name_, symbol_) {
        createGeneration(maxSupply_, description_, imageUri_);
        setPrice(price_);
        setSalesTax(salesTax_);
        setErc20(tokenAddress_);
    }

    /**
     * -------------------------------------------------------------------------
     * USER FUNCTIONS
     * -------------------------------------------------------------------------
     */

    /**
     * Buy an NFT.
     */
    function buy(uint256 quantity_) external {
        require(totalSupply() + quantity_ <= maxSupply(), "Not enough supply");
        require(paymentToken.transferFrom(msg.sender, address(this), quantity_ * price), "Payment failed");
        for(uint256 i = 1; i <= quantity_; i ++) {
            _tokenIdTracker.increment();
            _mint(msg.sender, _tokenIdTracker.current());
            _tokenValues[_tokenIdTracker.current()] = price;
        }
    }

    /**
     * Sell an NFT.
     */
    function sell(uint256 tokenId_) external {
        require(msg.sender == ERC721.ownerOf(tokenId_), "Sender does not own token");
        uint256 tax = _tokenValues[tokenId_] * salesTax / 100;
        uint256 value = _tokenValues[tokenId_] - tax;
        require(paymentToken.transfer(msg.sender, value), "Payment failed");
        // burn NFT
        _burn(tokenId_);
        // burn tax
        paymentToken.transfer(address(0), tax);
    }

    /**
     * Total supply.
     * @notice returns the total amount of NFTs created.
     * @return uint256
     */
    function totalSupply() public view returns (uint256)
    {
        return _tokenIdTracker.current();
    }

    /**
     * Max supply.
     * @notice Returns the sum of the max supply for all generations.
     * @return uint256
     */
    function maxSupply() public view returns (uint256)
    {
        uint256 _maxSupply;
        for(uint256 i = 1; i <= _generationTracker.current(); i++) {
            _maxSupply += _generations[i].maxSupply;
        }
        return _maxSupply;
    }

    /**
     * Contract URI.
     * @notice Returns metadata for the contract used by some marketplaces.
     * @return string
     */
    function contractURI() public pure returns (string memory) {
        return string(
            abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"Furio NFT","description":"Furio NFT required for downline bonuses."}'
                        )
                    )
                )
            )
        );
    }

    /**
     * -------------------------------------------------------------------------
     * OWNER FUNCTIONS
     * -------------------------------------------------------------------------
     */

    /**
     * Create a generation.
     * @notice This method creates a new NFT generation.
     * @param maxSupply_ The maximum NFT supply for this generation.
     * @param description_ The description for this generation.
     * @param imageUri_ The image URI for this generation.
     */
    function createGeneration(
        uint256 maxSupply_,
        string memory description_,
        string memory imageUri_
    ) public onlyOwner
    {
        _generationTracker.increment();
        uint256 _g = _generationTracker.current();
        _generations[_g].maxSupply = maxSupply_;
        _generations[_g].description = description_;
        _generations[_g].imageUri = imageUri_;
    }

    /**
     * Set price
     */
    function setPrice(uint256 price_) public onlyOwner {
        price = price_;
    }

    /**
     * Set sales tax
     */
    function setSalesTax(uint256 salesTax_) public onlyOwner {
        salesTax = salesTax_;
    }
    /**
     * Set ERC20
     */
    function setErc20(address paymentToken_) public onlyOwner {
        paymentToken = IERC20(paymentToken_);
    }

}
