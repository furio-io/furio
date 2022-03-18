// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.6.0;

import "../contracts/Reservoir.sol";

abstract contract $IToken is IToken {
    constructor() {}
}

abstract contract $ISwap is ISwap {
    constructor() {}
}

contract $Reservoir is Reservoir {
    constructor() {}

    function $entryFee_() external view returns (uint8) {
        return entryFee_;
    }

    function $exitFee_() external view returns (uint8) {
        return exitFee_;
    }

    function $furioFee() external view returns (uint8) {
        return furioFee;
    }

    function $instantFee() external view returns (uint8) {
        return instantFee;
    }

    function $payoutRate_() external view returns (uint8) {
        return payoutRate_;
    }

    function $magnitude() external view returns (uint256) {
        return magnitude;
    }

    function $MAX_UINT() external view returns (uint256) {
        return MAX_UINT;
    }

    function $lastBalance_() external view returns (uint256) {
        return lastBalance_;
    }

    function $buyFor(address _customerAddress,uint256 _buy_amount) external returns (uint256) {
        return super.buyFor(_customerAddress,_buy_amount);
    }

    function $approveSwap() external {
        return super.approveSwap();
    }

    function $sellTokens(uint256 amount) external returns (uint256) {
        return super.sellTokens(amount);
    }

    function $sellBnb(uint256 amount) external returns (uint256) {
        return super.sellBnb(amount);
    }

    function $purchaseTokens(address _customerAddress,uint256 _incomingtokens) external returns (uint256) {
        return super.purchaseTokens(_customerAddress,_incomingtokens);
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
