// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
// INTERFACES
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IDevWallets.sol";

/**
 * @title Furio Whitelist NFT
 * @author Steve Harmeyer
 * @notice This is the NFT needed to be on the whitelist. Purchasing this NFT
 * will get the user 500 $FUR tokens and 2 FurioNFTs for downline benefits.
 */
contract Whitelist is ERC721 {
    using Counters for Counters.Counter;

    /**
     * Token metadata.
     * @notice Name and symbol.
     */
    string private _name = 'Furio Whitelist NFT';
    string private _symbol = '$FURWL';

    /**
     * Dev wallets contract.
     * @notice All developer wallets are stored in a publicly accessible contract
     * in order to provide transparency.
     */
    IDevWallets public devWallets;

    /**
     * ERC20 contract for buys and sells.
     * @notice ERC20 token used to purchase this NFT.
     */
    IERC20 public paymentToken;

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
     * Image.
     * @notice SVG image of NFT.
     */
    string public image;

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
     * Contract constructor.
     * @dev Set the addresses for devWallets and paymentToken, then mint
     * ONE NFT per dev wallet.
     */
    constructor(address devWallets_, address paymentToken_) ERC721(_name, _symbol) {
        devWallets = IDevWallets(devWallets_);
        paymentToken = IERC20(paymentToken_);
        address[] memory _devWallets = devWallets.addresses();
        for(uint i = 0; i < _devWallets.length; i ++) {
            mint(_devWallets[i]);
        }
    }

    /**
     * Buy an NFT.
     * @notice Allows a user to buy an NFT.
     */
    function buy() external {
        require(!purchased[msg.sender], "Address already purchased");
        require(totalSupply() < maxSupply, "Sold out");
        require(paymentToken.transferFrom(msg.sender, address(this), price), "Payment failed");
        mint(msg.sender);
    }

    /**
     * Mint an NFT.
     * @dev Internal function to mint an NFT. This is separate from the buy()
     * method to allow the dev wallets to receive an NFT.
     */
    function mint(address to_) internal {
        _tokenIdTracker.increment();
        _mint(to_, _tokenIdTracker.current());
        purchased[to_] = true;
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
                            '{"name":"',name(),' #',Strings.toString(tokenId_),
                            '","description":"This NFT is redeemable for 500 $FUR tokens and 2 $FURNFT tokens","image":"',
                            'data:image/svg+xml;base64,',
                            Base64.encode(bytes(image)),
                            '"}'
                        )
                    )
                )
            )
        );
    }
}
