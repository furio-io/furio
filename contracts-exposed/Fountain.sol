// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.6.0;

import "../contracts/Fountain.sol";

contract $Ownable is Ownable {
    constructor() {}
}

contract $Whitelist is Whitelist {
    constructor() {}
}

contract $BEP20 is BEP20 {
    constructor() {}

    function $_balances(address arg0) external view returns (uint256) {
        return _balances[arg0];
    }

    function $_allowed(address arg0, address arg1) external view returns (uint256) {
        return _allowed[arg0][arg1];
    }

    function $_totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function $_transfer(address from,address to,uint256 value) external {
        return super._transfer(from,to,value);
    }

    function $_mint(address account,uint256 value) external {
        return super._mint(account,value);
    }

    function $_burn(address account,uint256 value) external {
        return super._burn(account,value);
    }

    function $_approve(address owner,address spender,uint256 value) external {
        return super._approve(owner,spender,value);
    }

    function $_burnFrom(address account,uint256 value) external {
        return super._burnFrom(account,value);
    }
}

contract $SafeMath {
    constructor() {}

    function $mul(uint256 a,uint256 b) external pure returns (uint256) {
        return SafeMath.mul(a,b);
    }

    function $div(uint256 a,uint256 b) external pure returns (uint256) {
        return SafeMath.div(a,b);
    }

    function $sub(uint256 a,uint256 b) external pure returns (uint256) {
        return SafeMath.sub(a,b);
    }

    function $safeSub(uint256 a,uint256 b) external pure returns (uint256) {
        return SafeMath.safeSub(a,b);
    }

    function $add(uint256 a,uint256 b) external pure returns (uint256) {
        return SafeMath.add(a,b);
    }

    function $max(uint256 a,uint256 b) external pure returns (uint256) {
        return SafeMath.max(a,b);
    }

    function $min(uint256 a,uint256 b) external pure returns (uint256) {
        return SafeMath.min(a,b);
    }
}

abstract contract $IToken is IToken {
    constructor() {}
}

contract $Fountain is Fountain {
    constructor(address token_addr) Fountain(token_addr) {}

    function $token() external view returns (IToken) {
        return token;
    }

    function $lastBalance_() external view returns (uint256) {
        return lastBalance_;
    }

    function $trackingInterval_() external view returns (uint256) {
        return trackingInterval_;
    }

    function $_providers(address arg0) external view returns (bool) {
        return _providers[arg0];
    }

    function $_txs(address arg0) external view returns (uint256) {
        return _txs[arg0];
    }

    function $_balances(address arg0) external view returns (uint256) {
        return _balances[arg0];
    }

    function $_allowed(address arg0, address arg1) external view returns (uint256) {
        return _allowed[arg0][arg1];
    }

    function $_totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function $_transfer(address from,address to,uint256 value) external {
        return super._transfer(from,to,value);
    }

    function $_mint(address account,uint256 value) external {
        return super._mint(account,value);
    }

    function $_burn(address account,uint256 value) external {
        return super._burn(account,value);
    }

    function $_approve(address owner,address spender,uint256 value) external {
        return super._approve(owner,spender,value);
    }

    function $_burnFrom(address account,uint256 value) external {
        return super._burnFrom(account,value);
    }
}
