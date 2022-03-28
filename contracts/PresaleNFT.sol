// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./utilities/Pausable.sol";
// INTERFACES
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Presale NFT
 * @author Steve Harmeyer
 * @notice This is the presale NFT contract. Anyone holding one of these NFTs
 * can exchange them for 500 FUR tokens + 2 downline NFTs.
 */
contract PresaleNFT is Ownable, Pausable, ERC721 {
    using Counters for Counters.Counter;

    /**
     * Token metadata.
     * @dev Name and symbol.
     */
    string private _name = 'FUR Presale NFT';
    string private _symbol = 'FURPRESALE';

    /**
     * ERC20 contract for buys and sells.
     * @notice ERC20 token used to purchase this NFT.
     */
    IERC20 private _paymentToken;

    /**
     * Price.
     * @notice Price is 250.
    */
    uint256 public price = 250e16;

    /**
     * Max supply.
     * @notice Max supply is 300.
     */
    uint256 public maxSupply = 300;

    /**
     * Purchased.
     * @notice Mapping to keep track of whether an address purchased or not.
     * @dev Do not use balanceOf for this because people can transfer the token
     * to another address and buy again. The mapping makes it so it's
     * only one per address.
     */
    mapping(address => bool) public purchased;

    /**
     * Token id tracker.
     * @dev Keeps track of the current token id.
     */
    Counters.Counter private _tokenIdTracker;

    /**
     * Freeze URI event.
     * @dev Tells opensea that the metadata is frozen.
     */
    event PermanentURI(string value_, uint256 indexed id_);

    /**
     * Contract constructor.
     * @dev Set the addresses for devWallets and paymentToken, then mint
     * ONE NFT per dev wallet.
     */
    constructor() ERC721(_name, _symbol) {}

    /**
     * Payment token.
     * @notice The ERC20 token used to buy and sell FUR.
     */
    function paymentToken() external view returns (address)
    {
        return address(_paymentToken);
    }

    /**
     * Set payment token.
     * @param address_ The address of the payment token.
     * @notice Once this is set, it is immutable.
     */
    function setPaymentToken(address address_) external onlyOwner
    {
        require(address(_paymentToken) == address(0), "Payment token already set");
        _paymentToken = IERC20(address_);
    }

    /**
     * Buy an NFT.
     * @notice Allows a user to buy an NFT.
     */
    function buy() external isNotPaused
    {
        require(address(_paymentToken) != address(0), "Payment token not set");
        require(_paymentToken.transferFrom(msg.sender, address(this), price), "Payment failed");
        require(!purchased[msg.sender], "Address already purchased");
        require(totalSupply() < maxSupply, "Sold out");
        _tokenIdTracker.increment();
        uint256 _id_ = _tokenIdTracker.current();
        super._mint(msg.sender, _id_);
        purchased[msg.sender] = true;
        emit PermanentURI(tokenURI(_id_), _id_);
    }

    /**
     * Mint an NFT.
     * @param to_ The address receiving the NFT.
     * @notice This function is used to mint presale NFTs for team addresses.
     */
    function mint(address to_) external onlyOwner
    {
        require(!purchased[to_], "Address already purchased");
        require(totalSupply() < maxSupply, "Sold out");
        _tokenIdTracker.increment();
        uint256 _id_ = _tokenIdTracker.current();
        super._mint(to_, _id_);
        purchased[to_] = true;
        emit PermanentURI(tokenURI(_id_), _id_);
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
     * Find which tokens a user owns.
     * @param owner_ Address of NFT owner.
     * @param index_ The index of the token looking for. Hint: all are 0.
     * @notice This function returns the token id owned by address_.
     * @dev This function is simplified since each address can only own
     * one NFT. No need to do complex enumeration.
     */
    function tokenOfOwnerByIndex(address owner_, uint256 index_) public view returns(uint256)
    {
        require(index_ == 0, "Owner index out of bounds");
        for (uint256 i = 1; i <= _tokenIdTracker.current(); i ++) {
            if(ownerOf(i) == owner_) {
                return i;
            }
        }
        return 0;
    }

    /**
     * Token URI.
     * @param tokenId_ The id of the token.
     * @notice This returns base64 encoded json for the token metadata. Allows us
     * to avoid putting metadata on IPFS.
     */
    function tokenURI(uint256 tokenId_) public view override returns (string memory) {
        require(tokenId_ > 0 && tokenId_ <= _tokenIdTracker.current(), "Token does not exist");
        return string(abi.encodePacked("ipfs://QmdVos2MHKUWLuRHthJ4ADS6JNgWJNNgHMBqAm8Nt21JPE/", Strings.toString(tokenId_)));
    }
}
