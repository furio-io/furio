// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// INTERFACES
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "./interfaces/IToken.sol";

/**
 * @title Presale NFT
 * @author Steve Harmeyer
 * @notice This is the presale NFT contract. Anyone holding one of these NFTs
 * can exchange them for 500 FUR tokens + 2 downline NFTs.
 */
contract PresaleNFT {
    /**
     * @dev Contract owner address.
     */
    address public owner;

    /**
     * @dev Paused state.
     */
    bool public paused = true;

    /**
     * @dev Payment token.
     */
    IERC20 public paymentToken;

    /**
     * @dev $FUR token.
     */
    IToken public furToken;

    /**
     * @dev Pool address.
     */
    address public poolAddress;

    /**
     * @dev Array of addresses that can buy while paused.
     */
    mapping(address => bool) private _presaleWallets;

    /**
     * @dev Stats.
     */
    uint256 public totalSupply;
    uint256 public totalCreated;
    uint256 public maxSupply = 300;
    uint256 public maxPerUser = 1;
    uint256 public price = 250e16;
    uint256 public tokenValue = 500e16;
    uint256 public nftValue = 2;
    uint256 private _currentTokenId;
    mapping(uint256 => bool) private _exists;
    mapping(address => uint256) public balanceOf;
    mapping(uint256 => address) public ownerOf;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /**
     * @dev Contract events.
     */
    event Transfer(address indexed from_, address indexed to_, uint256 indexed tokenId_);
    event Approval(address indexed owner_, address indexed approved_, uint256 indexed tokenId_);
    event ApprovalForAll(address indexed owner_, address indexed operator_, bool approved_);

    /**
     * @dev Contract constructor.
     */
    constructor()
    {
        owner = msg.sender;
    }

    /**
     * -------------------------------------------------------------------------
     * ERC721 STANDARDS
     * -------------------------------------------------------------------------
     */

    /**
     * @dev see {IERC721-name}.
     */
    function name() external pure returns (string memory)
    {
        return "Furio Presale NFT";
    }

    /**
     * @dev see {IERC721-symbol}.
     */
    function symbol() external pure returns (string memory)
    {
        return "$FURPRESALE";
    }

    /**
     * @dev see {IERC721-tokenURI}.
     */
    function tokenURI(uint256 tokenId_) external view returns (string memory)
    {
        require(_exists[tokenId_], "Token does not exist");
        return string(abi.encodePacked("ipfs://QmdVos2MHKUWLuRHthJ4ADS6JNgWJNNgHMBqAm8Nt21JPE", tokenId_));
    }

    /**
     * @dev see {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(address from_, address to_, uint256 tokenId_, bytes memory data_) public isNotPaused
    {
        require(to_ != address(0), "Cannot transfer to zero address");
        address _owner_ = ownerOf[tokenId_];
        require(msg.sender == _owner_ || msg.sender == getApproved(tokenId_) || isApprovedForAll(_owner_, msg.sender), "Unauthorized");
        _tokenApprovals[tokenId_] = address(0);
        emit Approval(_owner_, address(0), tokenId_);
        balanceOf[from_] -= 1;
        balanceOf[to_] += 1;
        ownerOf[tokenId_] = to_;
        emit Transfer(from_, to_, tokenId_);
    }

    /**
     * @dev see {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(address from_, address to_, uint256 tokenId_) external isNotPaused
    {
        safeTransferFrom(from_, to_, tokenId_, "");
    }

    /**
     * @dev see {IERC721-transferFrom}.
     */
    function transferFrom(address from_, address to_, uint256 tokenId_) external isNotPaused
    {
        safeTransferFrom(from_, to_, tokenId_, "");
    }

    /**
     * @dev see {IERC721-approve}.
     */
    function approve(address approved_, uint256 tokenId_) public isNotPaused
    {
        address _owner_ = ownerOf[tokenId_];
        require(approved_ != _owner_, "Cannot approve to current owner");
        require(msg.sender == _owner_ || isApprovedForAll(_owner_, msg.sender), "Unauthorized");
        _tokenApprovals[tokenId_] = approved_;
        emit Approval(_owner_, approved_, tokenId_);
    }

    /**
     * @dev see {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator_, bool approved_) external isNotPaused
    {
        require(msg.sender != operator_, "Cannot approve to current owner");
        _operatorApprovals[msg.sender][operator_] = approved_;
        emit ApprovalForAll(msg.sender, operator_, approved_);
    }

    /**
     * @dev see {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId_) public view returns (address)
    {
        require(_exists[tokenId_], "Token does not exist");
        return _tokenApprovals[tokenId_];
    }

    /**
     * @dev see {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner_, address operator_) public view returns (bool)
    {
        return _operatorApprovals[owner_][operator_];
    }

    /**
     * -------------------------------------------------------------------------
     * ERC165 STANDARDS
     * -------------------------------------------------------------------------
     */
    function supportsInterface(bytes4 interfaceId_) external pure returns (bool)
    {
        return interfaceId_ == type(IERC721).interfaceId || interfaceId_ == type(IERC721Metadata).interfaceId;
    }

    /**
     * -------------------------------------------------------------------------
     * ADMIN FUNCTIONS
     * -------------------------------------------------------------------------
     */

    /**
     * Set contract owner.
     * @param address_ The address of the owner wallet.
     */
    function setContractOwner(address address_) external onlyOwner
    {
        owner = address_;
    }

    /**
     * @dev Pause contract.
     */
    function pause() external onlyOwner
    {
        paused = true;
    }

    /**
     * @dev Unpause contract.
     */
    function unpause() external onlyOwner
    {
        paused = false;
    }

    /**
     * @dev Set payment token.
     */
    function setPaymentToken(address address_) external onlyOwner
    {
        paymentToken = IERC20(address_);
    }

    /**
     * @dev Set $FUR token.
     */
    function setFurToken(address address_) external onlyOwner
    {
        furToken = IToken(address_);
    }

    /**
     * @dev Add a presale wallet.
     */
    function addPresaleWallet(address address_) external onlyOwner
    {
        _presaleWallets[address_] = true;
    }

    /**
     * @dev Mint an NFT.
     */
    function mint(address to_) external onlyOwner
    {
        _mint(to_);
    }

    /**
     * -------------------------------------------------------------------------
     * USER FUNCTIONS
     * -------------------------------------------------------------------------
     */

    /**
     * @dev Buy an NFT.
     */
    function buy() external
    {
        require(!paused || _presaleWallets[msg.sender], "Sale is not open");
        require(address(paymentToken) != address(0), "Payment token not set");
        require(poolAddress != address(0), "Pool address not set");
        require(paymentToken.transferFrom(msg.sender, poolAddress, price, "Transfer failed");
        _mint(msg.sender);
    }

    /**
     * @dev Claim an NFT.
     */
    function claim() external
    {

    }

    /**
     * -------------------------------------------------------------------------
     * INTERNAL FUNCTIONS
     * -------------------------------------------------------------------------
     */

    function _mint(address to_) internal
    {
        require(totalCreated < maxSupply, "Out of supply");
        require(balanceOf[to_] < maxPerUser, "User has max");
        _currentTokenId ++;
        totalSupply ++;
        balanceOf[to_] += 1;
        ownerOf[_currentTokenId] = to_;
        emit Transfer(address(0), to_, _currentTokenId);
    }

    /**
     * -------------------------------------------------------------------------
     * MODIFIERS
     * -------------------------------------------------------------------------
     */

    /**
     * @dev Requires caller to be owner. These are methods that will be
     * called by a trusted user.
     */
    modifier onlyOwner()
    {
        require(msg.sender == owner, "Unauthorized");
        _;
    }

    /**
     * @dev Requires the contract to not be paused.
     */
    modifier isNotPaused()
    {
        require(!paused, "Contract is paused");
        _;
    }
}
