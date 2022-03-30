// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IDevWallet.sol";
import "./interfaces/IDownlineNFT.sol";
import "./interfaces/IPool.sol";
import "./interfaces/IPresaleNFT.sol";
import "./interfaces/IVault.sol";

/**
 * @title Token
 * @author Steve Harmeyer
 * @notice This is the ERC20 contract for $FUR token.
 */
contract Token {
    /**
     * @dev Contract administrator address.
     */
    address public contractAdmin;

    /**
     * @dev Paused state.
     */
    bool public paused = true;

    /**
     * @dev Mapping to track balances.
     */
    mapping(address => uint256) private _balances;

    /**
     * @dev Mapping to track allowances.
     */
    mapping(address => mapping(address => uint256)) private _allowances;

    /**
     * @dev Contract statistics.
     */
    struct Stats {
        uint256 transactions;
        uint256 minted;
    }
    mapping(address => Stats) public stats;
    uint256 public players;
    uint256 public totalSupply;
    uint256 public transactions;
    uint256 public minted;

    /**
     * @dev Tax rates.
     */
    uint256 public burnTax = 0; // This amount is burned from each tx
    uint256 public liquidityTax = 0; // This amount is sent to the pool
    uint256 public vaultTax = 10; // This amount is sent to the vault
    uint256 public devTax = 0; // This amount is sent to the dev wallet

    /**
     * @dev Other contracts in the Furio ecosystem.
     */
    IDevWallet public devWallet;
    IDownlineNFT public downlineNFT;
    IPool public pool;
    IPresaleNFT public presaleNFT;
    IVault public vault;

    /**
     * @dev Contract events.
     */
    event Approval(address indexed owner_, address indexed spender_, uint256 value_);
    event Mint(address indexed to_, uint256 amount_);
    event TaxPayed(address from, address vault, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Contract constructor.
     */
    constructor() {
        contractAdmin = msg.sender;
    }

    /**
     * -------------------------------------------------------------------------
     * ERC20 STANDARDS
     * -------------------------------------------------------------------------
     */

    /**
     * @dev see {IERC20-name}.
     */
    function name() external pure returns (string memory) {
        return 'Furio Token';
    }

    /**
     * @dev see {IERC20-symbol}.
     */
    function symbol() external pure returns (string memory) {
        return '$FUR';
    }

    function decimals() external pure returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account_) public view returns (uint256) {
        return _balances[account_];
    }

    /**
     * @dev See {IERC20-transfer}.
     */
    function transfer(address to_, uint256 amount_) external isNotPaused returns (bool) {
        return _internalTransfer(msg.sender, to_, amount_, taxRate());
    }

    /**
     * @dev See {IERC20-transferFrom}.
     */
    function transferFrom(address from_, address to_, uint256 amount_) external isNotPaused returns (bool) {
        uint256 _allowance_ = allowance(from_, to_);
        require(_allowance_ >= amount_, "Insufficient allowance");
        _allowances[from_][to_] -= amount_;
        return _internalTransfer(from_, to_, amount_, taxRate());
    }

    /**
     * @dev See {IERC20-approve}.
     */
    function approve(address spender_, uint256 amount_) external isNotPaused returns (bool) {
        _allowances[msg.sender][spender_] = amount_;
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner_, address spender_) public view isNotPaused returns (uint256) {
        return _allowances[owner_][spender_];
    }

    /**
     * -------------------------------------------------------------------------
     * USER FUNCTIONS
     * -------------------------------------------------------------------------
     */

    /**
     * Effective tax rate.
     * @notice This returns the combined tax rate for all taxes.
     */
    function taxRate() public view returns (uint256) {
        return burnTax + liquidityTax + vaultTax + devTax;
    }

    /**
     * -------------------------------------------------------------------------
     * PROTECTED FUNCTIONS
     * -------------------------------------------------------------------------
     */

    /**
     * Set contract admin.
     * @param address_ The address of the admin wallet.
     */
    function setContractAdmin(address address_) external admin
    {
        contractAdmin = address_;
    }

    /**
     * @dev Pause contract.
     */
    function pause() external admin
    {
        paused = true;
    }

    /**
     * @dev Unpause contract.
     */
    function unpause() external admin
    {
        paused = false;
    }

    /**
     * Set dev wallet.
     * @param address_ The address of the dev wallet.
     */
    function setDevWallet(address address_) external admin
    {
        devWallet = IDevWallet(address_);
    }

    /**
     * Set downline nft.
     * @param address_ The address of the downline nft.
     */
    function setDownlineNFT(address address_) external admin
    {
        downlineNFT = IDownlineNFT(address_);
    }

    /**
     * Set pool.
     * @param address_ The address of the pool.
     */
    function setPool(address address_) external admin
    {
        pool = IPool(address_);
    }

    /**
     * Set presale NFT.
     * @param address_ The address of the presale NFT.
     */
    function setPresaleNFT(address address_) external admin
    {
        presaleNFT = IPresaleNFT(address_);
    }

    /**
     * Set vault.
     * @param address_ The address of the vault.
     */
    function setVault(address address_) external admin
    {
        vault = IVault(address_);
    }

    /**
     * Set burn tax.
     * @param tax_ The amount of burn tax.
     * @notice This tax is burnt forever.
     */
    function setBurnTax(uint256 tax_) external admin
    {
        burnTax = tax_;
    }

    /**
     * Set liquidity tax.
     * @param tax_ The amount of liquidity tax.
     * @notice This tax is paid to the liquidity pool contract.
     */
    function setLiquidityTax(uint256 tax_) external admin
    {
        liquidityTax = tax_;
    }

    /**
     * Set vault tax.
     * @param tax_ The amount of vault tax.
     * @notice This tax is paid to the vault contract to fund rewards.
     */
    function setVaultTax(uint256 tax_) external admin
    {
        vaultTax = tax_;
    }

    /**
     * Set dev tax.
     * @param tax_ The amount of dev tax.
     * @notice This tax is paid to a dev wallet to fund further development.
     */
    function setDevTax(uint256 tax_) external admin
    {
        devTax = tax_;
    }

    /**
     * Protected transfer.
     * @param from_ The address to transfer from.
     * @param to_ The address to transfer to.
     * @param amount_ The amount to transfer.
     * @param taxRate_ The tax rate that should be applied.
     * @notice Only other Furio contracts can call this method.
     */
    function protectedTransfer(address from_, address to_, uint256 amount_, uint256 taxRate_) public trusted returns (bool)
    {
        return _internalTransfer(from_, to_, amount_, taxRate_);
    }

    /**
     * Mint.
     * @param to_ Address to mint to.
     * @param amount_ Amount of tokens to mint.
     * @notice Only other Furio contracts can call this method.
     */
    function mint(address to_, uint256 amount_) external trusted {
        totalSupply += amount_;
        _balances[to_] += amount_;
        emit Transfer(address(0), to_, amount_);
        emit Mint(to_, amount_);
        _updateStats(to_);
        stats[to_].minted += amount_;
        transactions ++;
        minted ++;
    }

    /**
     * Burn.
     * @param from_ Address to burn from.
     * @param amount_ Amount of tokens to burn.
     * @notice Only other Furio contracts can call this method.
     */
    function burn(address from_, uint256 amount_) external trusted {
        require(_balances[from_] >= amount_, "Insufficient funds");
        _balances[from_] -= amount_;
        totalSupply -= amount_;
        emit Transfer(from_, address(0), amount_);
    }

    /**
     * -------------------------------------------------------------------------
     * INTERNAL FUNCTIONS
     * -------------------------------------------------------------------------
     */

    /**
     * Internal transfer.
     * @param from_ Transfer from address.
     * @param to_ Transfer to address.
     * @param amount_ Transfer amount.
     * @param taxRate_ Tax rate.
     * @return bool
     */
    function _internalTransfer(address from_, address to_, uint256 amount_, uint256 taxRate_) internal returns (bool)
    {
        require(from_ != address(0), "No transfers from the zero address");
        require(to_ != address(0), "No transfers to the zero address");
        require(_balances[from_] >= amount_, "Insufficient funds");
        _balances[from_] -= amount_;
        if(taxRate_ > 0) {
            uint256 _tax_ = amount_ * taxRate_ / 100;
            uint256 _totalTaxRate_ = taxRate();
            uint256 _burnTax_ = _tax_ * (burnTax / _totalTaxRate_) / 100;
            uint256 _liquidityTax_ = _tax_ * (liquidityTax / _totalTaxRate_) / 100;
            uint256 _vaultTax_ = _tax_ * (vaultTax / _totalTaxRate_) / 100;
            uint256 _devTax_ = _tax_ * (devTax / _totalTaxRate_) / 100;
            if(_burnTax_ > 0) {
                totalSupply -= _burnTax_;
                emit Transfer(from_, address(0), _burnTax_);
                emit TaxPayed(from_, address(0), _burnTax_);
            }
            if(_liquidityTax_ > 0) {
                _balances[address(pool)] += _liquidityTax_;
                emit Transfer(from_, address(pool), _liquidityTax_);
                emit TaxPayed(from_, address(pool), _liquidityTax_);
            }
            if(_vaultTax_ > 0) {
                _balances[address(vault)] += _vaultTax_;
                emit Transfer(from_, address(vault), _vaultTax_);
                emit TaxPayed(from_, address(vault), _vaultTax_);
            }
            if(_devTax_ > 0) {
                _balances[address(devWallet)] += _devTax_;
                emit Transfer(from_, address(devWallet), _devTax_);
                emit TaxPayed(from_, address(devWallet), _devTax_);
            }
            amount_ -= _tax_;
        }
        _balances[to_] += amount_;
        _updateStats(from_);
        _updateStats(to_);
        transactions ++;
        return true;
    }

    /**
     * Update stats.
     * @param player_ Address of player to update.
     */
    function _updateStats(address player_) internal {
        if(stats[player_].transactions == 0) {
            players ++;
        }
        stats[player_].transactions ++;
    }

    /**
     * -------------------------------------------------------------------------
     * MODIFIERS
     * -------------------------------------------------------------------------
     */

    /**
     * @notice Requires sender to be admin. These are methods that will be
     * called by a trusted user.
     */
    modifier admin()
    {
        require(msg.sender == contractAdmin, "Unauthorized");
        _;
    }

    /**
     * @notice Requires callers is a trusted contract. These are automated
     * methods that facilitate Furio contract interaction.
     */
    modifier trusted()
    {
        require(
            msg.sender == address(downlineNFT) ||
            msg.sender == address(pool) ||
            msg.sender == address(presaleNFT) ||
            msg.sender == address(vault),
            "Unauthorized"
        );
        _;
    }

    /**
     * @notice Requires the contract to not be paused.
     */
    modifier isNotPaused()
    {
        require(!paused, "Contract is paused");
        _;
    }
}
