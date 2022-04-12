// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "./interfaces/IToken.sol";

contract PresaleNft is Ownable, ERC721
{
    /**
     * Token id tracker.
     */
    uint256 private _tokenId;

    /**
     * Payment token.
     */
    IERC20 public paymentToken;

    /**
     * Treasury.
     */
    address public treasury;

    /**
     * Furio token.
     */
    IToken public furioToken;

    /**
     * Start times.
     */
    uint256 public presaleOneStart = 1650398370; // Tue Apr 19 2022 19:59:30 GMT+0000
    uint256 public presaleTwoStart = 1650743970; // Sat Apr 23 2022 19:59:30 GMT+0000
    uint256 public presaleThreeStart = 1651089570; // Wed Apr 27 2022 19:59:30 GMT+0000
    uint256 public claimStart = 1651435170; // Sun May 01 2022 19:59:30 GMT+0000

    /**
     * Max each address can hold.
     */
    uint256 public presaleOneMax = 1;
    uint256 public presaleTwoMax = 10;
    uint256 public presaleThreeMax = 10;

    /**
     * Purchase prices.
     */
    uint256 public presaleOnePrice = 250e6;
    uint256 public presaleTwoPrice = 150e6;
    uint256 public presaleThreePrice = 175e6;

    /**
     * Max supplies.
     */
    uint256 public presaleOneSupply = 300;
    uint256 public presaleTwoSupply = 1250;
    uint256 public presaleThreeSupply = 1250;

    /**
     * Values.
     */
    uint256 public presaleOneValue = 500e18;
    uint256 public presaleTwoValue = 100e18;
    uint256 public presaleThreeValue = 100e18;

    /**
     * Purchased.
     */
    mapping(address => uint256) public presaleOnePurchased;
    mapping(address => uint256) public presaleTwoPurchased;
    mapping(address => uint256) public presaleThreePurchased;

    /**
     * Metadata.
     */
    string private _tokenUri = 'ipfs://Qme28bzD3z119fAqBPXgpDb9Z79bqEheQjkejWsefcd4Gj/1';

    /**
     * Events.
     */
    event TokensPurchased(address buyer_, uint256 quantity_);
    event TokenClaimed(uint256 tokenId_);

    /**
     * Constructor.
     */
    constructor() ERC721 (
        'Furio Presale NFT',
        '$FURPRESALE'
    ) {}

    /**
     * Token URI.
     * @param tokenId_ Id of the token.
     */
    function tokenURI(uint256 tokenId_) public view override returns (string memory) {
        require(_exists(tokenId_), "Token does not exist");
        return _tokenUri;
    }

    /**
     * Buy an NFT.
     * @param quantity_ The number of NFTs to purchase.
     */
    function buy(uint256 quantity_) external
    {
        require(address(paymentToken) != address(0), "Payment token not set");
        require(treasury != address(0), "Treasury not set");
        uint256 _time_ = block.timestamp;
        uint8 _type_ = 0;
        if(_time_ > presaleOneStart) _type_ = 1;
        if(_time_ > presaleTwoStart) _type_ = 2;
        if(_time_ > presaleThreeStart) _type_ = 3;
        require(_type_ > 0, "Presale has not started");
        if(_type_ == 1) {
            require(_tokenId + quantity_ <= presaleOneSupply, "Quantity is too high");
            require(presaleOnePurchased[msg.sender] + quantity_ <= presaleOneMax, "Quantity is too high");
            require(paymentToken.transferFrom(msg.sender, treasury, presaleOnePrice * quantity_), "Payment failed");
            presaleOnePurchased[msg.sender] += quantity_;
        }
        if(_type_ == 2) {
            if(_tokenId < presaleOneSupply) _tokenId = presaleOneSupply;
            require(_tokenId + quantity_ <= presaleOneSupply + presaleTwoSupply, "Quantity is too high");
            require(presaleTwoPurchased[msg.sender] + quantity_ <= presaleTwoMax, "Quantity is too high");
            require(paymentToken.transferFrom(msg.sender, treasury, presaleTwoPrice * quantity_), "Payment failed");
            presaleTwoPurchased[msg.sender] += quantity_;
        }
        if(_type_ == 3) {
            if(_tokenId < presaleOneSupply + presaleTwoSupply) _tokenId = presaleOneSupply + presaleTwoSupply;
            require(_tokenId + quantity_ <= presaleOneSupply + presaleTwoSupply + presaleThreeSupply, "Quantity is too high");
            require(presaleThreePurchased[msg.sender] + quantity_ <= presaleThreeMax, "Quantity is too high");
            require(paymentToken.transferFrom(msg.sender, treasury, presaleThreePrice * quantity_), "Payment failed");
            presaleThreePurchased[msg.sender] += quantity_;
        }
        for(uint256 i = 1; i <= quantity_; i ++) {
            _tokenId ++;
            _mint(msg.sender, _tokenId);
        }
        emit TokensPurchased(msg.sender, quantity_);
    }

    /**
     * Claim.
     * @param tokenId_ Token id to claim.
     */
    function claim(uint256 tokenId_) external
    {
        require(address(furioToken) != address(0), "Furio token not set");
        require(_exists(tokenId_), "Token does not exist");
        require(ownerOf(tokenId_) == msg.sender, "Token does not belong to you");
        uint256 _amount_ = presaleThreeValue;
        if(tokenId_ <= presaleOneSupply + presaleTwoSupply) _amount_ = presaleTwoValue;
        if(tokenId_ <= presaleOneSupply) _amount_ = presaleOneValue;
        furioToken.mint(msg.sender, _amount_);
        _burn(tokenId_);
        emit TokenClaimed(tokenId_);
    }

    /**
     * -------------------------------------------------------------------------
     * ADMIN FUNCTIONS
     * -------------------------------------------------------------------------
     */

    /**
     * Set payment token.
     * @param address_ Address of the payment token.
     */
    function setPaymentToken(address address_) external onlyOwner
    {
        paymentToken = IERC20(address_);
    }

    /**
     * Set treasury.
     * @param address_ Address of the treasury contract.
     */
    function setTreasury(address address_) external onlyOwner
    {
        treasury = address_;
    }

    /**
     * Set Furio token.
     * @param address_ Address of the Furio token contract.
     */
    function setFurioToken(address address_) external onlyOwner
    {
        furioToken = IToken(address_);
    }

    /**
     * Set presale one start.
     * @param start_ New start timestamp.
     */
    function setPresaleOneStart(uint256 start_) external onlyOwner
    {
        presaleOneStart = start_;
    }

    /**
     * Set presale two start.
     * @param start_ New start timestamp.
     */
    function setPresaleTwoStart(uint256 start_) external onlyOwner
    {
        presaleTwoStart = start_;
    }

    /**
     * Set presale three start.
     * @param start_ New start timestamp.
     */
    function setPresaleThreeStart(uint256 start_) external onlyOwner
    {
        presaleThreeStart = start_;
    }

    /**
     * Set presale one max.
     * @param max_ New max.
     */
    function setPresaleOneMax(uint256 max_) external onlyOwner
    {
        presaleOneMax = max_;
    }

    /**
     * Set presale two max.
     * @param max_ New max.
     */
    function setPresaleTwoMax(uint256 max_) external onlyOwner
    {
        presaleTwoMax = max_;
    }

    /**
     * Set presale three max.
     * @param max_ New max.
     */
    function setPresaleThreeMax(uint256 max_) external onlyOwner
    {
        presaleThreeMax = max_;
    }

    /**
     * Set presale one price.
     * @param price_ New price.
     */
    function setPresaleOnePrice(uint256 price_) external onlyOwner
    {
        presaleOnePrice = price_;
    }

    /**
     * Set presale two price.
     * @param price_ New price.
     */
    function setPresaleTwoPrice(uint256 price_) external onlyOwner
    {
        presaleTwoPrice = price_;
    }

    /**
     * Set presale three price.
     * @param price_ New price.
     */
    function setPresaleThreePrice(uint256 price_) external onlyOwner
    {
        presaleThreePrice = price_;
    }

    /**
     * Set presale one supply.
     * @param supply_ New supply.
     */
    function setPresaleOneSupply(uint256 supply_) external onlyOwner
    {
        presaleOneSupply = supply_;
    }

    /**
     * Set presale two supply.
     * @param supply_ New supply.
     */
    function setPresaleTwoSupply(uint256 supply_) external onlyOwner
    {
        presaleTwoSupply = supply_;
    }

    /**
     * Set presale three supply.
     * @param supply_ New supply.
     */
    function setPresaleThreeSupply(uint256 supply_) external onlyOwner
    {
        presaleThreeSupply = supply_;
    }

    /**
     * Set presale one value.
     * @param value_ New value.
     */
    function setPresaleOneValue(uint256 value_) external onlyOwner
    {
        presaleOneValue = value_;
    }

    /**
     * Set presale two value.
     * @param value_ New value.
     */
    function setPresaleTwoValue(uint256 value_) external onlyOwner
    {
        presaleTwoValue = value_;
    }

    /**
     * Set presale three value.
     * @param value_ New value.
     */
    function setPresaleThreeValue(uint256 value_) external onlyOwner
    {
        presaleThreeValue = value_;
    }

    /**
     * Set token URI.
     * @param uri_ New URI.
     */
    function setPresaleThreeValue(string memory uri_) external onlyOwner
    {
        _tokenUri = uri_;
    }
}
