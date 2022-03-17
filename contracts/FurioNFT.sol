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
    uint256 public price = 5;

    /**
     * Sales Tax.
     */
    uint256 public tax = 1;

    /**
     * Generation struct.
     * @dev Data structure for generation info.
     * this allows us to increase the supply with new art and description.
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
     */
    mapping(uint256 => Generation) private _generations;

    /**
     * Mapping to store token generations.
     */
    mapping(uint256 => uint256) private _tokenGenerations;

    /**
     * Token id tracker.
     * @dev Keeps track of the current token id.
     */
    Counters.Counter private _tokenIdTracker;

    /**
     * Contract constructor.
     */
    constructor(address paymentToken_) ERC721('Furio NFT', 'FNFT') {
        paymentToken = IERC20(paymentToken_);
    }

    /**
     * -------------------------------------------------------------------------
     * USER FUNCTIONS
     * -------------------------------------------------------------------------
     */

    /**
     * Buy an NFT.
     * @param quantity_ The amount of NFTs to purchase.
     * @notice Allows a user to buy NFTs.
     */
    function buy(uint256 quantity_) external {
        require(totalSupply() + quantity_ <= maxSupply(), "Not enough supply");
        require(paymentToken.transferFrom(msg.sender, address(this), quantity_ * price), "Payment failed");
        for(uint256 i = 1; i <= quantity_; i ++) {
            _tokenIdTracker.increment();
            _mint(msg.sender, _tokenIdTracker.current());
        }
    }

    /**
     * Sell an NFT.
     * @param tokenId_ Id of the token.
     * @notice Allows a user to sell an NFT. They get back the original purchase
     * price minus a tax. Token is burnt.
     */
    function sell(uint256 tokenId_) external {
        require(msg.sender == ERC721.ownerOf(tokenId_), "Sender does not own token");
        require(paymentToken.transfer(msg.sender, price - tax), "Payment failed");
        // burn NFT
        _burn(tokenId_);
        // burn tax
        paymentToken.transfer(address(0), tax);
    }

    /**
     * Total supply.
     * @return uint256
     * @notice returns the total amount of NFTs created.
     */
    function totalSupply() public view returns (uint256)
    {
        return _tokenIdTracker.current();
    }

    /**
     * Max supply.
     * @return uint256
     * @notice Returns the sum of the max supply for all generations.
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
     * @return string
     * @notice Returns base64 encoded json metadata for the contract used by some marketplaces.
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
     * Token URI.
     * @param tokenId_ The id of the token.
     * @notice This returns base64 encoded json for the token metadata. Allows us
     * to avoid putting metadata on IPFS.
     */
    function tokenURI(uint256 tokenId_) public view override returns (string memory) {
        return string(
            abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            name(),
                            ' #',
                            tokenId_,
                            '","description":"',
                            _generations[_tokenGenerations[tokenId_]].description,
                            '","image":"',
                            _generations[_tokenGenerations[tokenId_]].imageUri,
                            '}"'
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
     * @param maxSupply_ The maximum NFT supply for this generation.
     * @param description_ The description for this generation.
     * @param imageUri_ The image URI for this generation.
     * @notice This method creates a new NFT generation.
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
}
