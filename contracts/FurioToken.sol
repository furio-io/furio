// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

contract FurioToken is ERC20PresetMinterPauser {
    uint256 public constant MAX_INT = 2**256 - 1;
    uint256 public constant targetSupply = MAX_INT;
    uint256 public totalTxs;
    uint256 public players;
    /**
     * Constructor.
     */
    constructor() ERC20PresetMinterPauser('Furio Token', '$FUR') {}

    /**
     * MINTING.
     */
    // properties.
    uint256 public mintedSupply;
    bool public mintingFinished = false;
    // events.
    event Mint(address indexed to, uint256 amount);
    event MintFinished();
    // modifiers.
    modifier canMint() {
        require(!mintingFinished, "Minting has finished");
        _;
    }

    /**
     * Remaining mintable supply.
     */
    function remainingMintableSupply() external view returns(uint256) {
        return targetSupply - mintedSupply;
    }
}
