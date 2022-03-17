// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.6.0;

import "../contracts/FurioToken.sol";

contract $FurioToken is FurioToken {
    constructor() {}

    function $updateStats(address _address) external {
        return super.updateStats(_address);
    }

    function $_beforeTokenTransfer(address from,address to,uint256 amount) external {
        return super._beforeTokenTransfer(from,to,amount);
    }

    function $_pause() external {
        return super._pause();
    }

    function $_unpause() external {
        return super._unpause();
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

    function $_afterTokenTransfer(address from,address to,uint256 amount) external {
        return super._afterTokenTransfer(from,to,amount);
    }

    function $_grantRole(bytes32 role,address account) external {
        return super._grantRole(role,account);
    }

    function $_revokeRole(bytes32 role,address account) external {
        return super._revokeRole(role,account);
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

    function $_msgSender() external view returns (address) {
        return super._msgSender();
    }

    function $_msgData() external view returns (bytes memory) {
        return super._msgData();
    }
}
