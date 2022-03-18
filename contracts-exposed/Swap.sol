// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.6.0;

import "../contracts/Swap.sol";

contract $Swap is Swap {
    constructor(address swapToken_) Swap(swapToken_) {}

    function $_lastBalance() external view returns (uint256) {
        return _lastBalance;
    }

    function $_trackingInterval() external view returns (uint256) {
        return _trackingInterval;
    }

    function $_providers(address arg0) external view returns (bool) {
        return _providers[arg0];
    }

    function $_transactions(address arg0) external view returns (uint256) {
        return _transactions[arg0];
    }

    function $swapInput(uint256 sold_,uint256 minTokens_,address buyer_,address recipient_) external {
        return super.swapInput(sold_,minTokens_,buyer_,recipient_);
    }

    function $_transfer(address from,address to,uint256 amount) external {
        return super._transfer(from,to,amount);
    }

    function $_mint(address account,uint256 amount) external {
        return super._mint(account,amount);
    }

    function $_burn(address account,uint256 amount) external {
        return super._burn(account,amount);
    }

    function $_approve(address owner,address spender,uint256 amount) external {
        return super._approve(owner,spender,amount);
    }

    function $_spendAllowance(address owner,address spender,uint256 amount) external {
        return super._spendAllowance(owner,spender,amount);
    }

    function $_beforeTokenTransfer(address from,address to,uint256 amount) external {
        return super._beforeTokenTransfer(from,to,amount);
    }

    function $_afterTokenTransfer(address from,address to,uint256 amount) external {
        return super._afterTokenTransfer(from,to,amount);
    }

    function $_checkRole(bytes32 role,address account) external view {
        return super._checkRole(role,account);
    }

    function $_setupRole(bytes32 role,address account) external {
        return super._setupRole(role,account);
    }

    function $_setRoleAdmin(bytes32 role,bytes32 adminRole) external {
        return super._setRoleAdmin(role,adminRole);
    }

    function $_grantRole(bytes32 role,address account) external {
        return super._grantRole(role,account);
    }

    function $_revokeRole(bytes32 role,address account) external {
        return super._revokeRole(role,account);
    }

    function $_msgSender() external view returns (address) {
        return super._msgSender();
    }

    function $_msgData() external view returns (bytes memory) {
        return super._msgData();
    }
}
